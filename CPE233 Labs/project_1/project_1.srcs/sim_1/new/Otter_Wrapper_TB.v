`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2020 12:14:52 PM
// Design Name: 
// Module Name: Otter_Wrapper_TB
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


module Otter_Wrapper_TB();
    reg CLK;
    reg BTNL;
    reg BTNC;
    reg [15:0] SWITCHES; 
    wire [15:0] LEDS;
    wire [7:0] CATHODES;
    wire [3:0] ANODES;

    
    OTTER_Wrapper my_otter_wrapper(
        .CLK         (CLK),
        .BTNL        (BTNL),
        .BTNC        (BTNC),
        .SWITCHES    (SWITCHES),
        .LEDS        (LEDS),
        .CATHODES    (CATHODES),
        .ANODES      (ANODES)       );
        
           //- Generate periodic clock signal    
        initial    
           begin       
              CLK = 0;   //- init signal        
              forever  #10 CLK = ~CLK;    
           end                        
     initial        
          begin           
               BTNC=1; // reset signal on
               BTNL=0;
               
               #40
               
               BTNC = 0;
               
               #10000;
               
               BTNL=1;      //interrupt button
               
               #200
               
               BTNL=0;
                             
          end
endmodule
