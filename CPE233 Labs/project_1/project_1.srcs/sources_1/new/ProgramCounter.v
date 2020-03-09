`timescale 1ns / 1ps
//////////////////////////////////////////////////////////// 
// Create Date: 01/15/2020 12:37:29 PM
// Module Name: ProgramCounter_Mem
// Project Name: lab 2
// Description: This is a program counter module which has 
// four controllable inputs and outputs a address which
// normally increments by 4 to access the next memory location. 

///////////////////////////////////////////////////////////

module ProgramCounter(
    input rst,
    input PCWrite,
    input [2:0] pcSource,
    input CLK,
    input [31:0] jalr, branch, jal, mtvec, mepc,
    output [31:0] address,
    output [31:0] next_addr
    );
    
    wire [31:0] datain;
    
    //instantation of input MUX
    mux_8t1_nb  #(.n(32)) my_8t1_mux  (
        .SEL   (pcSource), 
        .D0    (next_addr), 
        .D1    (jalr), 
        .D2    (branch), 
        .D3    (jal),
        .D4    (mtvec),
        .D5    (mepc),
        .D6    (1'b0),
        .D7    (1'b0),
        .D_OUT (datain)
        ); 
        
        
    rca_nb #(.n(32)) MY_RCA (
        .a (address), 
        .b (3'b100), 
        .cin (0), 
        .sum (next_addr), 
        .co ()
        );  
    
    cntr_up_clr_nb #(.n(32)) MY_CNTR (
        .clk   (CLK), 
        .clr   (rst), 
        .up    (0),
        .ld    (PCWrite), 
        .D     (datain), 
        .count (address), 
        .rco   ()   
        );    
endmodule
