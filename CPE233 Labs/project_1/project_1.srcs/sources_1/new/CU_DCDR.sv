`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineers: Micah Fitzgerald and Ryan Madden
// 
// Create Date: 01/29/2019 04:56:13 PM
// Module Name: CU_Decoder
// Project Name: lab 5
// Description: Control Decoder for RISC-V OTTER
// // 
// CU_DCDR my_cu_dcdr(
//   .br_eq     (), 
//   .br_lt     (), 
//   .br_ltu    (),
//   .opcode    (),    //-  ir[6:0]
//   .func7     (),    //-  ir[31:25]
//   .func3     (),    //-  ir[14:12] 
//   .alu_fun   (),
//   .pcSource  (),
//   .alu_srcA  (),
//   .alu_srcB  (), 
//   .rf_wr_sel ()   );
//
// 
// Revision:
// Revision 1.00 - File Created (02-01-2020) - from Paul, Joseph, & Celina
//          1.01 - (02-08-2020) - removed unneeded else's; fixed assignments
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CU_DCDR(
    input br_eq, 
	input br_lt, 
	input br_ltu,
    input [6:0] opcode,   //-  ir[6:0]
	input [6:0] func7,    //-  ir[31:25]
    input [2:0] func3,    //-  ir[14:12] 
    output logic [3:0] alu_fun,
    output logic [1:0] pcSource,
    output logic alu_srcA,
    output logic [1:0] alu_srcB, 
	output logic [1:0] rf_wr_sel   );
    
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
    opcode_t OPCODE; //- define variable of new opcode type
    
    assign OPCODE = opcode_t'(opcode); //- Cast input enum 

    //- datatype for func3Symbols tied to values
    typedef enum logic [2:0] {
        //BRANCH labels
        BEQ = 3'b000,
        BNE = 3'b001,
        BLT = 3'b100,
        BGE = 3'b101,
        BLTU = 3'b110,
        BGEU = 3'b111
    } func3_t;    
    func3_t FUNC3; //- define variable of new opcode type
    
    assign FUNC3 = func3_t'(func3); //- Cast input enum 
       
    always_comb
    begin 
        //- schedule all values to avoid latch
		pcSource = 2'b00;  alu_srcB = 2'b00; rf_wr_sel = 2'b00; alu_srcA = 1'b0; alu_fun = 4'b0000;
		
		case(OPCODE)
			LUI:
			begin
				alu_fun = 4'b1001; // isntr: lui
				alu_srcA = 1'b1; 
				rf_wr_sel = 2'b11; 
				pcSource = 2'b00; 
			end
			
			AUIPC:
			begin
			     alu_fun = 4'b0000; // instr: auipc
			     alu_srcA = 1'b1;
			     alu_srcB = 2'b11;
			     rf_wr_sel = 2'b11;
			     pcSource = 2'b00;
			end	
			
			JAL:
			begin
				pcSource = 2'b11; // isntr: jal
				rf_wr_sel = 2'b00; 
			end
			
			JALR: // isntr: jalr
			begin
                alu_fun = 4'b0000; 
                alu_srcA = 1'd0; 
                alu_srcB = 2'b01; 
                rf_wr_sel = 2'b00;
                pcSource = 2'b01; 
            end
			
			LOAD: 
			begin
                alu_fun = 4'b0000; 
                alu_srcA = 1'd0; 
                alu_srcB = 2'd1; 
                rf_wr_sel = 2'd2;
                pcSource = 2'b00;
			end
			
			BRANCH:
			begin
			    case(FUNC3)
                     3'b000:    // instr: BEQ
                     begin
                        if (br_eq == 1)
                            pcSource = 2'b11;
                        else
                            pcSource = 2'b00;
                     end
                     
                     3'b001:    // instr: BNE
                     begin
                        if (br_eq == 0)
                            pcSource = 2'b10;
                        else
                            pcSource = 2'b00;
                     end
                     
                     3'b100:    // instr: BLT
                     begin
                        if (br_lt == 1 && br_eq == 0)
                            pcSource = 2'b10;
                        else
                            pcSource = 2'b00;
                     end
                     
                     3'b101:    // instr: BGE
                     begin
                        if (br_lt == 0 && br_eq == 0)
                            pcSource = 2'b10;
                        else
                            pcSource = 2'b00;
                     end
                     
                     3'b110:    // instr: BLTU
                     begin
                        if (br_ltu && br_eq == 0)
                            pcSource = 2'b10;
                        else
                            pcSource = 2'b00;
                     end
                     
                     3'b111:    // instr: BGEU
                     begin
                        if (br_ltu && br_eq == 0)
                            pcSource = 2'b10;
                        else
                            pcSource = 2'b00;
                     end
                     
                     default:
                     begin
                        if (br_eq)
                            pcSource = 2'b10;
                        else
                            pcSource = 2'b00;
                     end
			     endcase
			end
			
			STORE:
			begin
                alu_fun = 4'b0000; 
                alu_srcA = 1'd0; 
                alu_srcB = 2'd2;
                pcSource = 2'b00; 
			end
			
			OP_IMM:
			begin
				case(FUNC3)
					3'b000: // instr: ADDI
					begin
						alu_fun = 4'b0000;
						alu_srcA = 1'd0; 
						alu_srcB = 2'd1;
						rf_wr_sel = 2'd3; 
					end
					
                    3'b010: // instr: SLTI
                    begin
                        alu_fun = 4'b0010;
                        alu_srcA = 1'd0; 
                        alu_srcB = 2'd1;
                        rf_wr_sel = 2'd3; 
                    end
                    
                    3'b011: // instr: SLTIU
                    begin
                        alu_fun = 4'b0011;
                        alu_srcA = 1'd0; 
                        alu_srcB = 2'd1;
                        rf_wr_sel = 2'd3;
                    end
                    
                    3'b100: // instr: ORI
                    begin
                        alu_fun = 4'b0110;
                        alu_srcA = 1'd0; 
                        alu_srcB = 2'd1;
                        rf_wr_sel = 2'd3;
                    end
                    
                    3'b110: // instr: XORI
                    begin
                        alu_fun = 4'b0100;
                        alu_srcA = 1'd0; 
                        alu_srcB = 2'd1;
                        rf_wr_sel = 2'd3;
                    end
                    
                    3'b111: // instr: ANDI
                    begin
                        alu_fun = 4'b0111;
                        alu_srcA = 1'd0; 
                        alu_srcB = 2'd1;
                        rf_wr_sel = 2'd3;
                    end
                    
                    3'b001: // instr: SLLI
                    begin
                        alu_fun = 4'b0001;
                        alu_srcA = 1'd0; 
                        alu_srcB = 2'd1;
                        rf_wr_sel = 2'd3;
                    end
                    
                    3'b101:
                    if(func7 == 7'b0000000) // instr: SLRI
                        begin
                            alu_fun = 4'b0101;
                            alu_srcA = 1'd0; 
                            alu_srcB = 2'd1;
                            rf_wr_sel = 2'd3;
                        end
                    else                    // instr: SRAI
                        begin
                            alu_fun = 4'b1101;
                            alu_srcA = 1'd0; 
                            alu_srcB = 2'd1;
                            rf_wr_sel = 2'd3;
                        end

					default: //catch all
					begin
						pcSource = 2'd0; 
						alu_fun = 4'b0000;
						alu_srcA = 1'd0; 
						alu_srcB = 2'd0; 
						rf_wr_sel = 2'd0; 
					end
				endcase
			 end
			
			 OP_RG3:
             begin
			     alu_srcA = 1'd0;
			     alu_srcB = 2'd0;
			     pcSource = 2'b00;
			     rf_wr_sel = 2'b11;
			     case(FUNC3)
			         3'b000:
			         begin
			             if(func7 == 7'b0000000) // ADD
			                 alu_fun = 4'b0000;
			             else
			                 alu_fun = 4'b1000; // SUB
			         end
			         
			         3'b001: // SLL
			             alu_fun = 4'b0001;
			         
			         3'b010: // SLT
			             alu_fun = 4'b0010;
			         
			         3'b011: // SLTU
			             alu_fun = 4'b0011; 
			       
			         3'b100: // XOR     
			             alu_fun = 4'b0100;
			         
			         3'b101:
			         begin
                         if(func7 == 7'b0000000) // SRL
                             alu_fun = 4'b0101;
                         else                    // SRA
                             alu_fun = 4'b1101;
			         end
			         
			         3'b110: // OR
			             alu_fun = 4'b0110;
			         
			         3'b111: // AND
			             alu_fun = 4'b0111;
			         
			         default:
			             alu_fun = 4'b0000;
                 endcase    
             end
			 

			 default:
             begin
				 pcSource = 2'd0; 
				 alu_srcB = 2'd0; 
				 rf_wr_sel = 2'd0; 
				 alu_srcA = 1'd0; 
		         alu_fun = 4'b0000;
			 end
        endcase
    end
endmodule