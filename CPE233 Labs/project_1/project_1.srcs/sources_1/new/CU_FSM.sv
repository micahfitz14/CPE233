`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////
// Engineers: Micah Fitzgerald and Ryan Madden
// 
// Create Date: 01/07/2020 09:12:54 PM
// Module Name: top_level
// Project Name: lab 5
// Description: Control Unit for lab 5 with 8 instructions supported
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
//          1.01 - (02-08-2020) switched states to enum type
//          1.02 - added CSR support
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
    output logic rst,
    output logic csr_WE,
    output logic int_taken  );

    typedef  enum logic [2:0] {
        st_FET,
        st_EX,
        st_WB,
        st_INTR
        }  state_type; 
    state_type  NS,PS; 
    
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
        OP_RG3 = 7'b0110011, 
        SYS    = 7'b1110011
        } opcode_t;
    opcode_t OPCODE;    //- symbolic names for instruction opcodes
    
    assign OPCODE = opcode_t'(opcode); //- Cast input as enum 
    assign rst = RST; 
    //- state register (PS)
    always @ (posedge clk)  
        if (RST == 1)
        PS <= st_FET; 
        else 
        PS <= NS;
        
    always_comb
        begin              
            //- schedule all output to avoid latch
            pcWrite = 1'b0;    regWrite = 1'b0;      
            memWE2 = 1'b0;     memRDEN1 = 1'b0;    memRDEN2 = 1'b0;
            csr_WE = 1'b0;     int_taken = 1'b0;
        
        case (PS)
            st_FET: //waiting state  
            begin
                memRDEN1 = 1'b1;                    
                NS = st_EX; 
            end
            
            st_EX: //decode + execute
            begin
                pcWrite = 1'b1;
                case (OPCODE)
                    LUI: 
                    begin
                        regWrite = 1'b1;    
                        NS = st_FET;
                    end
                    
                    AUIPC:
                    begin 
                        regWrite = 1'b1;
                        NS = st_FET;
                    end 
                    
                    JAL: 
                    begin
                        regWrite = 1'b1; 
                        NS = st_FET;
                    end
                    
                    JALR:
                    begin
                        regWrite = 1'b1;
                        NS = st_FET;
                    end
                    
                    BRANCH: 
                    begin
                        NS = st_FET;
                    end   
                         
                    LOAD: 
                    begin
                        regWrite = 1'b0;
                        memRDEN2 = 1'b1;
                        NS = st_WB;
                    end
                    
                    STORE: 
                    begin
                        regWrite = 1'b0;
                        memWE2 = 1'b1;
                        NS = st_FET;
                    end
                    
                    OP_IMM: 
                    begin 
                        regWrite = 1'b1;	
                        NS = st_FET;
                    end
                    
                    OP_RG3:
                    begin
                        regWrite = 1'b1;
                        NS = st_FET;
                    end

                    SYS:
                    begin
                        csr_WE = 1'b1;          // write enable for CSR
                        NS = st_FET;            // happens if its writing mtvec
                    end
                    
                    default:  
                    begin 
                    NS = st_FET;
                    end
                    
                endcase
                
                if(intr == 1'b1 && NS != st_WB)    // enter interrupt state if inter is enabled and its not entering a 
                    begin
                        NS = st_INTR;           
                    end
            end
            
            st_WB:
            begin
                regWrite = 1'b1; 
                memRDEN2 = 1'b0;   
                if(intr == 1'b1)         
                    NS = st_INTR;    
                else
                    NS = st_FET;
            end
            
            st_INTR:
            begin
                pcWrite = 1'b1;
                int_taken = 1'b1; // tell CSR module that its in interrupt state
                csr_WE = 1'b1;    // write enable for mepc input
                NS = st_FET;   
            end
            
            default:
                NS = st_FET;           
                       
        endcase //- case statement for FSM states
    end
endmodule