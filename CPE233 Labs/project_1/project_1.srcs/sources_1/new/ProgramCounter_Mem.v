`timescale 1ns / 1ps
///////////////////////////////////////////////////////
// 
// Create Date: 01/15/2020 12:37:29 PM
// Module Name: ProgramCounter_Mem
// Project Name: lab 2
// Description: This is a model which uses the program 
// counter module and connects it to the memory for the 
// RISC-V otter. 
///////////////////////////////////////////////////////


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
    
    OTTER_mem_byte OTTER_MEMORY (
         .MEM_ADDR1 (addr),
         .MEM_ADDR2 (0),
         .MEM_CLK (CLK),
         .MEM_DIN2 (0),
         .MEM_WRITE2 (0),
         .MEM_READ1 (1),
         .MEM_READ2 (0),
         .IO_IN (0),
         .MEM_SIZE (2),
         .MEM_SIGN (0),
         .ERR (),
         .MEM_DOUT1 (ir),
         .MEM_DOUT2 (),
         .IO_WR () );
        
endmodule
