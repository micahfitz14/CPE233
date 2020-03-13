`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2020 12:21:13 PM
// Design Name: 
// Module Name: BRANCH_COND_GEN
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


module BRANCH_COND_GEN(
    input [31:0] rs1, rs2,
    output reg br_eq, br_lt, br_ltu
    );
    
    always @ (rs1, rs2)
    begin  
            br_eq = 0;
            br_lt = 0;
            br_ltu = 0;
            if (rs1 < rs2)
                br_ltu = 1;
            if (rs1 == rs2)
                br_eq = 1;
            if ($signed(rs1) < $signed(rs2))
                br_lt = 1;

    end
          
endmodule
