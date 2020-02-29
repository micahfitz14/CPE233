`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// 
// Create Date: 01/29/2020 12:10:54 PM
// Design Name: 
// Module Name: IMMED_GEN
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: decodes the immediate values in the  J, B, U, I, and S-type
// instructions and generates 32 bit immediate values to be used by other modules. 
// 
//////////////////////////////////////////////////////////////////////////////////


module IMMED_GEN(
    input [31:0] ir,
    output reg [31:0] u_type, i_type, s_type, j_type, b_type
    
    );
    
    always@(ir)
    begin
    
        // generate immediate value for i-type instruction
        i_type = {{21{ir[31]}}, ir[30:20]};
        
        // generate immediate value for s-type instruction
        s_type = {{21{ir[31]}}, ir[30:25], ir[11:7]};
        
        // generate immediate value for b-type instruction
        b_type = {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0};
        
        // generate immediate value for u-type instruction
        u_type = {ir[31:12], {12{1'b0}}};
        
        // generate immediate value for j-type instruction
        j_type = {{12{ir[31]}}, ir[19:12], ir[20], ir[30:21], 1'b0};
    end
endmodule
