`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2020 11:17:32 AM
// Design Name: 
// Module Name: fibonacci_seq_gen
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


module fibonacci_seq_gen(
    input BTN,
    output [3:0] disp_en,
    output [7:0] ssegs,
    output [3:0] led,
    input clk
    );
    wire [9:0] muxconnect, n, n1, n2;
    wire sloclock;
    wire clr;
    wire ld;
    wire ctrl;
    wire [3:0] cnt;
    wire we;
    wire [9:0] data_out;
    wire rco;
    
    assign led = cnt;
    
    clk_2n_div_test #(25) myclock (
        .clockin  (clk),
        .clockout (sloclock), 
        .fclk_only(0)
    );
    
    reg_nb #(10) MY_REG (
        .data_in  (n), 
        .ld       (ld), 
        .clk      (sloclock), 
        .clr      (clr), 
        .data_out (n1)
    ); 
    
    reg_nb #(10) MY_REG2 (
        .data_in  (n1), 
        .ld       (ld), 
        .clk      (sloclock), 
        .clr      (clr), 
        .data_out (n2)
    ); 
    
    rca_nb #(.n(10)) MY_RCA (
        .a (n1), 
        .b (muxconnect), 
        .cin (0), 
        .sum (n), 
        .co ()
    );     
    
    mux_2t1_nb  #(.n(10)) my_2t1_mux  (
        .SEL   (ctrl), 
        .D0    (1), 
        .D1    (n2), 
        .D_OUT (muxconnect) 
    );    
    
    ram_single_port #(.n(4),.m(10)) my_ram (
        .data_in (n),  // m spec
        .addr (cnt), // n spec 
        .we  (we),
        .clk (sloclock),
        .data_out (data_out)
    ); 
    
    cntr_up_clr_nb #(.n(4)) MY_CNTR (
        .clk   (sloclock), 
        .clr   (clr), 
        .up    (1), 
        .ld    (0), 
        .D     (0), 
        .count (cnt), 
        .rco   (rco)   
    );              
                                   
    univ_sseg my_univ_sseg (
        .cnt1 (data_out), 
        .cnt2 (2'b00), 
        .valid (1), 
        .dp_en (0), 
        .dp_sel (2'b00), 
        .mod_sel (2'b10), 
        .sign (0), 
        .clk (clk), 
        .ssegs (ssegs), 
        .disp_en (disp_en)    
    ); 
    
    fibonacci_fsm ff (
        .btn(BTN),
        .rco(rco),
        .clk(sloclock),
        .we(we),
        .ctrl(ctrl),
        .ld(ld),
        .clr(clr)  
    );

endmodule
