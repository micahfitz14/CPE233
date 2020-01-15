`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: Ratner Engineering
// Engineer: James Ratner
// 
// Create Date: 01/03/2020 02:13:56 PM
// Design Name: 
// Module Name: generic single port ram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//
//   Usage (instantiation) example for 32x8 RAM  
//          (model defaults to 64x8 RAM)
//              n is address width
//              m is data width
//
//  ram_single_port #(.n(4),.m(8)) my_ram (
//      .data_in (my_a),  // m spec
//      .addr (my_a_min), // n spec 
//      .we  (my_we),
//      .clk (clk),
//      .data_out (my_data_out)
//      );  
// 
// Dependencies: 
// 
// Revision: 1.00 - (01-02-2020) created
//         
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ram_single_port (
	input wire [m-1:0] data_in,
	input wire [n-1:0] addr,
	input wire we, 
	input wire clk,
	output wire [m-1:0] data_out  );

    parameter n = 6;   // address bus width
	parameter m = 8;   // data bus width
	
	// Declare the memory variable
	reg [m-1:0] memory[2**n-1:0];
	
    // synchronous write
	always @ (posedge clk)
	begin
		if (we)
			memory[addr] <= data_in;
	end
  
    // asynchronous reads
	assign data_out = memory[addr];
	
endmodule

`default_nettype wire