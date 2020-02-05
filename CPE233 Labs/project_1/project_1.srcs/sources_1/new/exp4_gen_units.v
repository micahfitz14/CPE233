`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2020 12:10:30 PM
// Design Name: 
// Module Name: exp4_gen_units
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


module exp4_gen_units(
    input rst, PCWrite, pcSource, clk,
    output [31:0] u_type_imm, s_type_imm 
    );
    
    wire [31:0] jalr, branch, jal, PC, ir, i_type, j_type, b_type;
    wire [31:0] rs = 32'hFFFFFFFC;
     
    ProgramCounter mypc (
        .rst        (rst),
        .PCWrite    (PCWrite),
        .pcSource   (pcSource),
        .CLK        (clk),
        .jalr       (jalr),
        .branch     (branch),
        .jal        (jal),
        .address    (PC) );
    
    Memory mem (
        .MEM_CLK    (clk),
        .MEM_RDEN1  (1),
        .MEM_RDEN2  (0),
        .MEM_WE2    (0),
        .MEM_ADDR1  (PC[15:2]),
        .MEM_ADDR2  (0),
        .MEM_WD     (0),
        .MEM_SIZE   (2),
        .MEM_SIGN   (0),
        .IO_IN      (0),
        .IO_WR      (),
        .MEM_DOUT1  (ir),
        .MEM_DOUT2  () );
    
    IMMED_GEN ig (
        .ir         (ir),
        .u_type     (u_type_imm),
        .i_type     (i_type),
        .s_type     (s_type_imm),
        .j_type     (j_type),
        .b_type     (b_type) );
    
    BRANCH_ADDR_GEN bag (
        .PC         (PC - 4),
        .j_type     (j_type),
        .b_type     (b_type),
        .i_type     (i_type),
        .rs         (rs) );
        
        
endmodule
