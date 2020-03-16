`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////
// Engineers: Micah Fitzgerald and Ryan Madden
// 
// Create Date: 02/05/2020 12:19:19 PM
// Module Name: OTTER_MCU
// Project Name: lab 5
// Description: This is the top level implementation of the 
// RISC-V OTTER MCU. It contains all the submodules for a working 
// computer
// Revision 0.01 - File Created
// 
////////////////////////////////////////////////////////////////


module OTTER_MCU(
    input clk, RST, intr,
    input [31:0] iobus_in,
    output [31:0] iobus_out, iobus_addr, 
    output iobus_wr
    );
    
    wire [31:0] addr, next_addr, jalr, branch, jal, ir, d_out2, reg_in, rs1, rs2; //PC, mem, reg file
    wire [31:0] j_type, b_type, u_type, i_type, s_type, alu1, alu2;               //immed, alu
    wire [3:0] alu_fun;                                                           //alu
    wire [2:0] pcSource;
    wire [1:0] alu_srcB, rf_wr_sel;                                     //PC, alu, reg input
    wire PCWrite, rst, regWrite, memWE2, memRDEN1, memRDEN2, alu_srcA, br_eq, br_lt, br_ltu;
    
    wire intr_connect, int_taken, csr_WE;                                         // interrupts
    wire [31:0] mepc, mtvec, csr_reg;                                             // CSR outputs
    wire csr_mie;                                                                 
  
    
    assign iobus_out = rs2;
    
    // control and status register
    CSR  my_csr (
        .CLK       (clk),
        .RST       (rst),
        .INT_TAKEN (int_taken),
        .ADDR      (ir[31:20]),
        .PC        (addr),
        .WD        (rs1),
        .WR_EN     (csr_WE), 
        .RD        (csr_reg),
        .CSR_MEPC  (mepc),  
        .CSR_MTVEC (mtvec), 
        .CSR_MIE   (csr_mie)    ); 
    
    ProgramCounter pc   (
        .rst        (rst),
        .PCWrite    (PCWrite),
        .pcSource   (pcSource),
        .CLK        (clk),
        .jalr       (jalr),
        .branch     (branch),
        .jal        (jal),
        .mtvec      (mtvec),
        .mepc       (mepc),
        .address    (addr),
        .next_addr  (next_addr)
        );
            
    Memory otter_memory (
        .MEM_CLK   (clk),
        .MEM_RDEN1 (memRDEN1), 
        .MEM_RDEN2 (memRDEN2), 
        .MEM_WE2   (memWE2),
        .MEM_ADDR1 (addr[15:2]),
        .MEM_ADDR2 (iobus_addr),
        .MEM_DIN2  (rs2),  
        .MEM_SIZE  (ir[13:12]),
        .MEM_SIGN  (ir[14]),
        .IO_IN     (iobus_in),
        .IO_WR     (iobus_wr),
        .MEM_DOUT1 (ir),
        .MEM_DOUT2 (d_out2)  ); 
    
    mux_4t1_nb  #(.n(32)) reg_input_mux  (
        .SEL   (rf_wr_sel), 
        .D0    (next_addr), 
        .D1    (csr_reg), 
        .D2    (d_out2), 
        .D3    (iobus_addr),
        .D_OUT (reg_in) );     
    
    RegFile register (
        .clk       (clk),
        .wd        (reg_in),
        .en        (regWrite),
        .adr1      (ir[19:15]),
        .adr2      (ir[24:20]),
        .wa        (ir[11:7]),
        .rs1       (rs1), 
        .rs2       (rs2)     );        
                
                
    IMMED_GEN immediate_value_generator (
        .ir         (ir),
        .u_type     (u_type), 
        .i_type     (i_type), 
        .s_type     (s_type), 
        .j_type     (j_type), 
        .b_type     (b_type)      ); 
        
        
    BRANCH_ADDR_GEN branch_address_generator (
        .PC         (addr), 
        .j_type     (j_type), 
        .b_type     (b_type), 
        .i_type     (i_type), 
        .rs         (rs1),
        .jal        (jal), 
        .branch     (branch), 
        .jalr       (jalr)        );               
                
    mux_2t1_nb #(.n(32)) alu_src1_mux (
         .SEL   (alu_srcA), 
         .D0    (rs1), 
         .D1    (u_type), 
         .D_OUT (alu1) );  
            
    mux_4t1_nb  #(.n(32)) alu_src2_mux  (
         .SEL   (alu_srcB), 
         .D0    (rs2), 
         .D1    (i_type), 
         .D2    (s_type), 
         .D3    (addr),
         .D_OUT (alu2) ); 
                               
    alu arithmitic_logic_unit  (
        .OP_1       (alu1), 
        .OP_2       (alu2),
        .alu_fun    (alu_fun),
        .RESULT     (iobus_addr)    );  
        
    assign intr_connect = csr_mie & intr;              //and of intr and mie going into FSM
    
    CU_FSM cu_fsm(
        .intr     (intr_connect),
        .clk      (clk),
        .RST      (RST),
        .opcode   (ir[6:0]),   // ir[6:0]
        .pcWrite  (PCWrite),
        .regWrite (regWrite),
        .memWE2   (memWE2),
        .memRDEN1 (memRDEN1),
        .memRDEN2 (memRDEN2),
        .rst      (rst),
        .csr_WE   (csr_WE),
        .int_taken(int_taken)   );
    
    CU_DCDR cu_dcdr(
        .br_eq     (br_eq), 
        .br_lt     (br_lt), 
        .br_ltu    (br_ltu),
        .opcode    (ir[6:0]),    //-  ir[6:0]
        .func7     (ir[31:25]),    //-  ir[31:25]
        .func3     (ir[14:12]),    //-  ir[14:12] 
        .int_taken (int_taken),    //- interrupt taken signal from FSM
        .alu_fun   (alu_fun),
        .pcSource  (pcSource),
        .alu_srcA  (alu_srcA),
        .alu_srcB  (alu_srcB), 
        .rf_wr_sel (rf_wr_sel)   );
       
    BRANCH_COND_GEN condgen(
        .rs1        (rs1),
        .rs2        (rs2),
        .br_eq      (br_eq),
        .br_lt      (br_lt),
        .br_ltu     (br_ltu)    );         
            
        
endmodule
