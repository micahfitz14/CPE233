`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2020 12:10:30 PM
// Design Name: 
// Module Name: exp4_gen_units
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


module exp4_gen_units(
    input rst, PCWrite, pcSource, CLK,
    output reg [32:0] u_type_imm, s_type_imm 
    );
    
    
    ProgramCounter mypc (
        .rst        (rst),
        .PCWrite    (PCWrite),
        .pcSource   (pcSource),
        .CLK        (CLK),
        .jalr       (jalr),
        .branch     (branch),
        .jal        (jal),
        .address    (PC) );
    
    
    
    Memory OTTER_MEMORY (
        .MEM_CLK   (),
        .MEM_RDEN1 (), 
        .MEM_RDEN2 (), 
        .MEM_WE2  (),
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
