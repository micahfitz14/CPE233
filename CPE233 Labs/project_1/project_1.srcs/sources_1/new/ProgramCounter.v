`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2020 12:37:29 PM
// Design Name: 
// Module Name: ProgramCounter_Mem
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


module ProgramCounter(
    input rst,
    input PCWrite,
    input [1:0] pcSource,
    input CLK,
    input [31:0] jalr,
    input [31:0] branch,
    input [31:0] jal,
    output [31:0] address
    );
    
    wire [31:0] next_addr;
    wire [31:0] datain;
    
    mux_4t1_nb  #(.n(32)) my_4t1_mux  (
        .SEL   (pcSource), 
        .D0    (next_addr), 
        .D1    (32'h00004444), 
        .D2    (32'h00008888), 
        .D3    (32'h0000CCCC),
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
        .up    (1),
        .ld    (PCWrite), 
        .D     (datain), 
        .count (address), 
        .rco   ()   
        );    
endmodule
