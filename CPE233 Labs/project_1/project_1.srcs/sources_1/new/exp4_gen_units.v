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
    input rst, PCWrite, clk,
    input [1:0] pcSource,
    output [31:0] u_type_imm, s_type_imm 
    );
    
    wire [31:0] jalr, branch, jal, PC, ir, i_type, j_type, b_type;
    wire [31:0] rs = 32'hC;
    wire [31:0] PC_1;
     
    ProgramCounter mypc (
        .rst        (rst),
        .PCWrite    (PCWrite),
        .pcSource   (pcSource),
        .CLK        (clk),
        .jalr       (jalr),
        .branch     (branch),
        .jal        (jal),
        .address    (PC),
        .next_addr () );
    
    Memory otter_memory (
        .MEM_CLK   (clk),
        .MEM_RDEN1 (1), 
        .MEM_RDEN2 (0), 
        .MEM_WE2   (0),
        .MEM_ADDR1 (PC[15:2]),
        .MEM_ADDR2 (0),
        .MEM_DIN2  (1'b0),  
        .MEM_SIZE  (2),
        .MEM_SIGN  (0),
        .IO_IN     (0),
        .IO_WR     (),
        .MEM_DOUT1 (ir),
        .MEM_DOUT2 ()  ); 
        
    IMMED_GEN ig (
        .ir         (ir),
        .u_type     (u_type_imm),
        .i_type     (i_type),
        .s_type     (s_type_imm),
        .j_type     (j_type),
        .b_type     (b_type) );
    
    assign PC_1 = PC - 3'b100;
    
    BRANCH_ADDR_GEN bag (
        .PC         (PC_1),
        .j_type     (j_type),
        .b_type     (b_type),
        .i_type     (i_type),
        .rs         (rs), 
        .jal        (jal),
        .jalr       (jalr),
        .branch     (branch)      );
        
        
endmodule
