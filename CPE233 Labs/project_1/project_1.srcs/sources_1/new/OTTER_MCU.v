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
    input clk, rst,
    input [31:0] iobus_in, CSR_reg,
    input [1:0] intr,
    output [31:0] iobus_out, iobus_addr, iobus_wr
    );
    
    wire [31:0] addr, next_addr, jalr, branch, jal, ir, alu_out, d_out2, reg_in, rs1, rs2;
    wire [31:0] j_type, b_type, u_type, i_type, s_type;
    wire [1:0] pcSource, alu_srcB, rf_wr_sel;
    wire PCWrite, pc_rst, regWrite, memWE2, memRDEN1, memRDEN2, alu_srcA;
    
    ProgramCounter pc   (
        .rst        (pc_rst),
        .PCWrite    (PCWrite),
        .pcSource   (pcSource),
        .CLK        (clk),
        .jalr       (jalr),
        .branch     (branch),
        .jal        (jal),
        .address    (addr),
        .next_adddr (next_addr)
        );
            
  Memory otter_memory (
        .MEM_CLK   (clk),
        .MEM_RDEN1 (memRDEN1), 
        .MEM_RDEN2 (memRDEN2), 
        .MEM_WE2   (memWE2),
        .MEM_ADDR1 (addr),
        .MEM_ADDR2 (alu_out),
        .MEM_WD    (0),  
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
        .D3    (alu_out),
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
        .jalr       (jalr)      );               
                
                
       //alu    
                
     alu arithmitic_logic_unit  (
        .OP_1       (), 
        .OP_2       (),
        .alu_fun    (),
        .RESULT     ()      );  
endmodule
