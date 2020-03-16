`timescale 1ns / 1ps
///////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2020 10:24:36 PM
// Design Name: 
// Module Name: Wrapper_intr_lab_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
////////////////////////////////////////////////////////////


module Wrapper_intr_lab_TB();

    //- inputs
    reg CLK;
    reg [4:0] BUTTONS;
    reg [15:0] SWITCHES; 
    
    //- outputs
    wire [15:0] LEDS;
    wire [7:0] CATHODES;
    wire [3:0] ANODES;
     
    //- instantation of wapper file from lab 5. used in this lab 7 
    OTTER_Wrapper my_otter_wrapper(
        .clk         (CLK),
        .buttons     (BUTTONS),
        .switches    (SWITCHES),
        .leds        (LEDS),
        .segs        (CATHODES),
        .an          (ANODES)       );
        
     reg BTNL, BTNC;           //- assign wires to the reset and interrupt buttons
     
     always@(*)
     begin
         BUTTONS[4] = BTNL;
         BUTTONS[3] = BTNC;
     end
       
           //- Generate periodic clock signal    
    initial    
        begin       
            CLK = 0;   //- init signal        
            forever  #10 CLK = ~CLK;    
        end                        
     initial        
          begin           
               BTNC = 1; // reset signal on
               BTNL = 0; // clear intr signal
               SWITCHES = 16'hff00; // some input on the switches
               
               #40
               
               BTNC = 0; // reset signal off
              
               #4000
               
               BTNL = 1; // interrupt signal on
               
               #200
               
               BTNL = 0; // interrupt signal off
               
               #1500
               
               BTNL = 1; // interrupt signal on
               
               #200
               
               BTNL = 0; // interrupt signal off
               
               
          end
endmodule