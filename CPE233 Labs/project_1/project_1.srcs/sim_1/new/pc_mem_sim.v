`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2020 09:25:35 PM
// Design Name: 
// Module Name: pc_mem_sim
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


module pc_mem_sim(

    );
    
    reg CLK;
    reg [1:0] pcSource = 0;
    reg PCWrite = 1;
    reg rst;
    wire [31:0] ir;
    
    ProgramCounter_Mem pcsim (.CLK(CLK), .pcSource(pcSource), .PCWrite(PCWrite), .rst(rst), .ir(ir));
    initial
    begin
    rst = 0;
    #5;
    rst = 1;
    #5
    rst = 0;
    end   
    
    
    always
    begin
    CLK = 1;
    #5
    CLK = 0;
    #5;
    end
    

    
    always
    begin
    #80
    pcSource = pcSource+1;
    end
    
endmodule
