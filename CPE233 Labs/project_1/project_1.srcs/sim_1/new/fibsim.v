`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2020 12:32:47 PM
// Design Name: 
// Module Name: fibsim
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


module fibsim(

    );
    reg BTN;
    wire [3:0] disp_en;
    wire [7:0] ssegs;
    reg clk;
    wire [3:0] led;
    fibonacci_seq_gen fibsim (.BTN(BTN), .disp_en(disp_en), .ssegs(ssegs), .clk(clk), .led(led));
    
    always
        begin
        clk = 1;
        #5
        clk = 0;
        #5;
        end
        
    initial
    begin
    BTN = 0;
    #10;
    BTN = 1;
    #10;
    BTN = 0;
    end
endmodule
