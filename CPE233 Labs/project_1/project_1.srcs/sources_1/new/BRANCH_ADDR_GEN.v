`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2020 12:11:11 PM
// Design Name: 
// Module Name: BRANCH_ADDR_GEN
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


module BRANCH_ADDR_GEN(
       input [31:0] PC, j_type, b_type, i_type, rs,
       output reg [31:0] jal, branch, jalr
    );
    
    always @(*)
    begin
        jal = j_type + PC;
        jalr = i_type + PC;
        branch = b_type + PC;
    end
    
endmodule
