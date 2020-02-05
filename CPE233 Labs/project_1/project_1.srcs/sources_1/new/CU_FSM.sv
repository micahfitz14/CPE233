`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Ratner Surf Designs
// Engineer: James Ratner
// 
// Create Date: 01/07/2020 09:12:54 PM
// Design Name: 
// Module Name: top_level
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Control Unit Template/Starter File for RISC-V OTTER
//
//    //- instantiation template 
//    module CU_FSM(
//        .intr     (),
//        .clk      (),
//        .RST      (),
//        .opcode   (),   // ir[6:0]
//        .pcWrite  (),
//        .regWrite (),
//        .memWE2   (),
//        .memRDEN1 (),
//        .memRDEN2 (),
//        .rst      ()   );
//   
// Dependencies: 
// 
// Revision:
// Revision 1.00 - File Created - 02-01-2020 (from other people's files)
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CU_FSM(
    input intr,
    input clk,
    input RST,
    input [6:0] opcode,     // ir[6:0]
    output logic pcWrite,
    output logic regWrite,
    output logic memWE2,
    output logic memRDEN1,
    output logic memRDEN2,
    output logic rst
  );
    
    reg [1:0] NS, PS;
    
    //- State register bit assignments
    parameter [1:0] st_irFetch = 2'b00, st_DCDR = 2'b01, st_writeBack = 2'b10;
  
    //- datatypes for RISC-V opcode types
    typedef enum logic [6:0] {
        LUI    = 7'b0110111,
        AUIPC  = 7'b0010111,
        JAL    = 7'b1101111,
        JALR   = 7'b1100111,
        BRANCH = 7'b1100011,
        LOAD   = 7'b0000011,
        STORE  = 7'b0100011,
        OP_IMM = 7'b0010011,
        OP_RG3 = 7'b0110011
    } opcode_t;
	opcode_t OPCODE;    //- symbolic names for instruction opcodes
     
	assign OPCODE = opcode_t'(opcode); //- Cast input as enum 
	 
	 
	//- state register (PS)
	always_ff @ (posedge clk)  
    begin
        if(RST == 1)
        begin
            PS = st_irFetch;
            rst = 1;
        end 
        else
            rst = 0; 
            PS = NS;
    end
       
    always_comb
    begin              
        //- schedule all output to avoid latch
        pcWrite = 0;    regWrite = 0;      
		memWE2 = 0;     memRDEN1 = 0;    memRDEN2 = 0;
                   
        case (PS)
            st_irFetch: //waiting state  
            begin
                pcWrite = 0;
                regWrite = 0;
                memWE2 = 0;
                memRDEN1 = 1;
                memRDEN2 = 0;
                   
                NS = st_DCDR; 
            end
              
            st_DCDR: //decode + execute
            begin
                pcWrite = 1;
				case (OPCODE)
				    LOAD: 
                       begin
                          regWrite = 0;
                          memRDEN2 = 1;
                          NS = st_writeBack;
                       end
                    
					STORE: 
                       begin
                          NS = st_irFetch;
                       end
                    
					BRANCH: 
                       begin
                          NS = st_irFetch;
                       end
					
					LUI: 
					   begin
					      NS = st_irFetch;
					   end
					  
					OP_IMM: 
					   begin 
					      NS = st_irFetch;
					   end
					
	                JAL: 
					   begin
					      NS = st_irFetch;
					   end
					 
                    default:  
					   begin 
					      NS = st_irFetch;
					   end
					
                endcase
            end
               
            st_writeBack:
            begin
               regWrite = 1; 
               NS = st_irFetch;
            end
 
            default: NS = st_irFetch;
           
        endcase //- case statement for FSM states
    end
           
endmodule