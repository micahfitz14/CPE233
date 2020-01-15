`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Ratner Surf Designs
// Engineer:  James Ratner
// 
// Create Date: 07/07/2018 08:05:03 AM
// Design Name: 
// Module Name: fsm_template
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generic FSM model with both Mealy & Moore outputs. 
//    Note: data widths of state variables are not specified 
//
// Dependencies: 
// 
// Revision:
// Revision 1.00 - File Created (07-07-2018) 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fibonacci_fsm(clk, we, btn, rco, ld, ctrl, clr); 
    input  clk, btn, rco; 
    output reg we, ctrl, ld, clr;
     
    //- next state & present state variables
    reg [1:0] NS, PS; 
    //- bit-level state representations
    parameter [1:0] st_A=2'b00, st_B=2'b01, st_C=2'b11; 
    

    //- model the state registers
    always @ (posedge clk)
    begin
       PS <= NS;
    end
    
    
    //- model the next-state and output decoders
    always @ (btn, rco, PS)
    begin
    we = 0; ctrl = 0; ld = 0; clr = 0; // assign all outputs
       case(PS)
          st_A:
          begin
             ld = 0; clr = 0; we = 0;        
             if (btn == 0)
             begin   
                NS = st_A; 
             end  
             else
             begin
                clr = 1;
                NS = st_B; 
             end  
          end
          
          st_B:
             begin
                ctrl = 0; ld = 1; we = 1;
                NS = st_C;
             end   
             
          st_C:
             begin
                 ctrl = 1; ld = 1; we = 1;
                 if (rco == 0)
                 begin
                    NS = st_C; 
                 end  
                 else
                 begin 
                    NS = st_A;
                 end  
             end
             
          default: NS = st_A; 
            
          endcase
      end              
endmodule
