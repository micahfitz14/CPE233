`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2020 12:19:19 PM
// Design Name: 
// Module Name: OTTER_MCU
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


module OTTER_MCU(
    input clk, rst,
    input [31:0] iobus_in,
    input [1:0] intr,
    output [31:0] iobus_out, iobus_addr, iobus_wr
    );
    
    wire [31:0] addr, jalr, branch, jal, ir;
    wire [1:0] pcSource, alu_srcB, rf_wr_sel;
    wire PCWrite, pc_rst, regWrite, memWE2, memRDEN1, memRDEN2, alu_srcA;
    
    ProgramCounter pc   (
            .rst        (pc_rst),
            .PCWrite    (PCWrite),
            .pcSource   (pcSource),
            .CLK        (clk),
            .jalr       (jalr),
            .branch     (branch),
            .jal        (jal),
            .address    (addr)
            );
            
  Memory OTTER_MEMORY (
                .MEM_CLK   (),
                .MEM_RDEN1 (), 
                .MEM_RDEN2 (), 
                .MEM_WE2,  (),
                .MEM_ADDR1 (),
                .MEM_ADDR2 (),
                .MEM_WD    (),  
                .MEM_SIZE  (),
                .MEM_SIGN  (),
                .IO_IN     (),
                .IO_WR     (),
                .MEM_DOUT1 (),
                .MEM_DOUT2 ()  ); 
endmodule
