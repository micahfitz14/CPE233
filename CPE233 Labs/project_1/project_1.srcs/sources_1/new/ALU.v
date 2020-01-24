`timescale 1ns / 1ps
////////////////////////////////////////////////////////
// Engineers: Micah Fitzgerald and Ryan Madden
// 
// Create Date: 01/23/2020 06:33:39 PM
// Module Name: ALU
// Project Name: lab3
// Description: 
// 
/////////////////////////////////////////////////////////


module alu(
        input [31:0] OP_1, 
        input [31:0] OP_2,
        input [3:0] alu_fun,
        output reg [31:0] RESULT  
    );
    
    always@(alu_fun)
    begin
        case(alu_fun)
        
            4'b0000 : RESULT = OP_1 + OP_2;
            4'b0001 : RESULT = OP_1 << OP_2; //shift OP_1 left by the value of OP_2
            4'b0010 : if($signed(OP_1) < $signed(OP_2))
                            RESULT = 1;
                      else
                            RESULT = 0;
            4'b0011 : if(OP_1 < OP_2)
                            RESULT = 1;
                      else
                            RESULT = 0;
            4'b0100 :                 
            
            default : RESULT = 0;
       endcase 
    end
endmodule
