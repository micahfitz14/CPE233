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
    
    always@(alu_fun, OP_1, OP_2)
    begin
        case(alu_fun)
        
            4'b0000 : RESULT = $signed(OP_1) + $signed(OP_2);
            4'b0001 : RESULT = OP_1 << OP_2[4:0];    //shift OP_1 left by the value of OP_2
            4'b0010 : if($signed(OP_1) < $signed(OP_2))
                            RESULT = 1;
                      else
                            RESULT = 0;
            4'b0011 : if(OP_1 < OP_2)
                            RESULT = 1;
                      else
                            RESULT = 0;
            4'b0100 : RESULT = OP_1 ^ OP_2;
            4'b0101 : RESULT = OP_1 >> OP_2[4:0];    //shift OP_1 right by the value of OP_2
            4'b0110 : RESULT = OP_1 | OP_2;
            4'b0111 : RESULT = OP_1 & OP_2;
            4'b1000 : RESULT = $signed(OP_1) - $signed(OP_2);
            4'b1101 : RESULT = $signed(OP_1) >>> OP_2[4:0];   //arithmetic shift right 
            4'b1001 : RESULT = OP_1;          
            default : RESULT = 0;
       endcase 
    end
endmodule
