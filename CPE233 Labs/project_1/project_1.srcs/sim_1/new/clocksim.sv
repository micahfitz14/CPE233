`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2020 12:12:38 PM
// Design Name: 
// Module Name: clocksim
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


module clocksim(

    );
    logic clockin;
    logic clockout;
    logic fclk_only;
    
    clk_2n_div_test clksim (.clockin(clockin), .clockout(clockout), .fclk_only(fclk_only));
    
    always
    begin
    clockin = 1;
    #5
    clockin = 0;
    #5;
    end
    
    initial
    begin
    fclk_only = 1;
    end
    
endmodule
