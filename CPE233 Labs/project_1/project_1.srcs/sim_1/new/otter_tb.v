`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ratner Surf Designs
// Engineer:  James Ratner
// 
// Create Date: 01/07/2020 12:59:51 PM
// Design Name: 
// Module Name: tb
// Project Name: MCU testpench
// Target Devices: 
// Tool Versions: 
// Description: Testbench file for Exp 5
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module otter_tb(); 

   reg RST; 
   reg intr; 
   reg clk; 
   reg [31:0] iobus_in; 
   wire [31:0] iobus_addr; 
   wire [31:0] iobus_out; 
   wire iobus_wr; 

OTTER_MCU  my_otter(
     .RST         (RST),
     .intr        (intr),
     .clk         (clk),
     .iobus_in    (iobus_in),
     .iobus_out   (iobus_out), 
     .iobus_addr  (iobus_addr), 
     .iobus_wr    (iobus_wr)   );
     
   //- Generate periodic clock signal    
   initial    
      begin       
         clk = 0;   //- init signal        
         forever  #10 clk = ~clk;    
      end                        
         
   initial        
   begin           
      RST=1;
      intr=0;
      iobus_in = 32'h0000FEED;  
    //  iobus_addr = 32'h11008000;
    
      #40   //iobus_in = 32'hFFFFFFFF;
//          //  iobus_addr = 32'h11008000;
      
//      #40   iobus_in = 32'b00000000;
//          //  iobus_addr = 32'h11008000;
                   

      RST = 0;  

    end
        
 endmodule