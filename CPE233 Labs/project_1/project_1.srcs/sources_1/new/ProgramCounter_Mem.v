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


module ProgramCounter_Mem(
    input rst,
    input PCWrite,
    input [1:0] pcSource,
    input CLK,
    output [31:0] ir
    );
    
    wire [31:0] addr;
    
    ProgramCounter pc   (
        .rst        (rst),
        .PCWrite    (PCWrite),
        .pcSource   (pcSource),
        .CLK        (CLK),
        .jalr       (32'h00004444),
        .branch     (32'h00008888),
        .jal        (32'h0000CCCC),
        .address    (addr)
        );
    
    ram_single_port #(.n(4),.m(10)) mem (
        .data_in (n),  // m spec
        .addr (addr), // n spec 
        .we  (1),
        .clk (CLK),
        .data_out (ir)
        );
endmodule
