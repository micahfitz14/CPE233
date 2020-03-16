`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Micah Fitzgerald and Ryan Madden
// 
// Create Date: 01/20/2019 10:36:50 AM
// Description: OTTER Wrapper (with Debounce, Switches, LEDS, and SSEG)
//
// revision: made it support James' mcu definitions (lettering case) 
//
//////////////////////////////////////////////////////////////////////////////////

module OTTER_Wrapper(
   input CLK,
   input BTNL,
   input BTNC,
   input [15:0] SWITCHES,
   output logic [15:0] LEDS,
   output logic[7:0] CATHODES,
   output logic [3:0] ANODES
   );
       
   
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more MMIO, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_AD = 32'h11000000;
              
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more MMIO
    localparam LEDS_AD      = 32'h11080000;
    localparam SSEG_AD     = 32'h110C0000;
    localparam ANODES_AD   = 32'h111C0000;
   
    
   // Signals for connecting OTTER_MCU to OTTER_wrapper /////////////////////////
   logic s_interrupt, btn_int;
   logic s_reset,s_load;
   logic sclk;// = 1'b0;   
   
 
   logic [15:0]  r_SSEG;// = 16'h0000;
     
   logic [31:0] IOBUS_out,IOBUS_in,IOBUS_addr;
   logic IOBUS_wr;
   
   //assign s_interrupt = btn_int;
   
                   
OTTER_MCU  my_otter(
     .RST         (s_reset),
     .intr        (s_interrupt),
     .clk         (sclk),
     .iobus_in    (IOBUS_in),
     .iobus_out   (IOBUS_out), 
     .iobus_addr  (IOBUS_addr), 
     .iobus_wr    (IOBUS_wr)   );                   
                   


   
   // Declare Debouncer ///////////////////////////////////////////
     DBounce #(.n(5)) my_dbounce(
       .clk    (sclk),
       .sig_in (BTNL),
       .DB_out (btn_int)   );
       
       
   // Declare One Shot ////////////////////////////////////////////
     one_shot_bdir  #(.n(3)) my_oneshot (
       .clk           (sclk),
       .sig_in        (btn_int),
       .pos_pulse_out (s_interrupt), 
       .neg_pulse_out ()                    ); 
   
   
      
   clk_div clkDIv(CLK, sclk);
  
   assign s_reset = BTNC;
   
     // Connect Board peripherals (Memory Mapped IO devices) to IOBUS /////////////////////////////////////////
    always_ff @ (posedge sclk)
    begin
     
        if(IOBUS_wr)
            case(IOBUS_addr)
                LEDS_AD:    LEDS <= IOBUS_out;                  //-  connect correct peripherals to MCU output
                SSEG_AD:    CATHODES <= IOBUS_out[15:0];
                ANODES_AD:  ANODES <= IOBUS_out[3:0];
             
            endcase
          
    end
   
    always_comb
    begin
        IOBUS_in=32'b0;
        case(IOBUS_addr)
            SWITCHES_AD: IOBUS_in[15:0] = SWITCHES;
          
            default: IOBUS_in=32'b0;
        endcase
    end
   endmodule
