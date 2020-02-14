`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2020 12:19:19 PM
// Design Name: 
// Module Name: OTTER_MCU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OTTER_MCU(
    input clk, RST,
    input [31:0] iobus_in, CSR_reg,
    input [1:0] intr,
    output [31:0] iobus_out, iobus_addr, 
    output iobus_wr
    );
    
    wire [31:0] addr, next_addr, jalr, branch, jal, ir, d_out2, reg_in, rs1, rs2;
    wire [31:0] j_type, b_type, u_type, i_type, s_type, alu1, alu2;
    wire [3:0] alu_fun;
    wire [1:0] pcSource, alu_srcB, rf_wr_sel;
    wire PCWrite, rst, regWrite, memWE2, memRDEN1, memRDEN2, alu_srcA;
    
    assign iobus_out = rs2;
    
    ProgramCounter pc   (
        .rst        (rst),
        .PCWrite    (PCWrite),
        .pcSource   (pcSource),
        .CLK        (clk),
        .jalr       (jalr),
        .branch     (branch),
        .jal        (jal),
        .address    (addr),
        .next_addr (next_addr)
        );
            
    Memory otter_memory (
        .MEM_CLK   (clk),
        .MEM_RDEN1 (memRDEN1), 
        .MEM_RDEN2 (memRDEN2), 
        .MEM_WE2   (memWE2),
        .MEM_ADDR1 (addr[15:2]),
        .MEM_ADDR2 (iobus_addr),
        .MEM_DIN2    (1'b0),  
        .MEM_SIZE  (ir[13:12]),
        .MEM_SIGN  (ir[14]),
        .IO_IN     (iobus_in),
        .IO_WR     (iobus_wr),
        .MEM_DOUT1 (ir),
        .MEM_DOUT2 (d_out2)  ); 
    
    mux_4t1_nb  #(.n(32)) reg_input_mux  (
        .SEL   (rf_wr_sel), 
        .D0    (next_addr), 
        .D1    (CSR_reg), 
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
        
    CU_FSM cu_fsm(
        .intr     (1'b0),
        .clk      (clk),
        .RST      (RST),
        .opcode   (ir[6:0]),   // ir[6:0]
        .pcWrite  (PCWrite),
        .regWrite (regWrite),
        .memWE2   (memWE2),
        .memRDEN1 (memRDEN1),
        .memRDEN2 (memRDEN2),
        .rst      (rst)   );
    
    CU_DCDR cu_dcdr(
       .br_eq     (1'b0), 
       .br_lt     (1'b0), 
       .br_ltu    (1'b0),
       .opcode    (ir[6:0]),    //-  ir[6:0]
       .func7     (ir[31:25]),    //-  ir[31:25]
       .func3     (ir[14:12]),    //-  ir[14:12] 
       .alu_fun   (alu_fun),
       .pcSource  (pcSource),
       .alu_srcA  (alu_srcA),
       .alu_srcB  (alu_srcB), 
       .rf_wr_sel (rf_wr_sel)   );
            
        
endmodule
