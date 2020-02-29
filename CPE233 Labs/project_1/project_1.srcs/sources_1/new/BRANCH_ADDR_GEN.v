`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Micah Fitzgerald and Ryan Madden
// Create Date: 01/29/2020 12:11:11 PM
// Module Name: BRANCH_ADDR_GEN
//////////////////////////////////////////////////////////////////////////////////


module BRANCH_ADDR_GEN(
       input [31:0] PC, j_type, b_type, i_type, rs,
       output reg [31:0] jal, branch, jalr
    );
    
    always @(*)
    begin
        jal = j_type + PC;
        jalr = i_type + rs;
        branch = b_type + PC;
    end
    
endmodule
