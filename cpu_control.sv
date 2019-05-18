import rv32i_types::*; /* Import types defined in rv32i_types.sv */

module control
(
    /* Input and output port declarations */
	 input clk,
	/* Datapath controls */
	input rv32i_opcode opcode,
	output logic load_pc,
	output logic load_ir,
	output logic load_regfile,
	output logic alumux1_sel,
	output logic [2:0] alumux2_sel,
	output alu_ops aluop,
	/* et cetera */
	output logic load_mar,
	output logic load_mdr,
	output logic load_data_out,
	output logic [1:0]pcmux_sel,
	output logic [2:0] regfilemux_sel,
	output logic marmux_sel,
	output logic cmpmux_sel,
	/////////////////////mp1cp2
	output logic [2:0]mdrmux_sel,
	//output store_funct3_t mem_data_out_sel,
	output logic [1:0]mem_data_out_sel,

	input rv32i_reg rs1,
	input rv32i_reg rs2,
	input [2:0] funct3,
	input [6:0] funct7,
	input br_en,

	output branch_funct3_t cmpop,
	//////////////////mp2cp2
	input rv32i_word mem_address,

	/* Memory signals */
	input mem_resp,
	output logic mem_read,
	output logic mem_write,
	output rv32i_mem_wmask mem_byte_enable

);

/*
* The following ~54 lines of code have been added to help you drive the
* verification monitor. This is not required but we think it will help you
* with testing so we've tried to make it as easy as possible for you to get it
* up and running.
* */
logic trap;
logic [4:0] rs1_addr, rs2_addr;
logic [3:0] rmask, wmask;
branch_funct3_t branch_funct3;
store_funct3_t store_funct3;
load_funct3_t load_funct3;

assign branch_funct3 = branch_funct3_t'(funct3);
assign load_funct3 = load_funct3_t'(funct3);
assign store_funct3 = store_funct3_t'(funct3);

always_comb
begin : trap_check
    trap = 0;
    rmask = 0;
    wmask = 0;

    case (opcode)
        op_lui, op_auipc, op_imm,op_reg,op_jal,op_jalr:;

        op_br: begin
            case (branch_funct3)
                beq, bne, blt, bge, bltu, bgeu:;
                default: trap = 1;
            endcase
        end

        op_load: begin
            case (load_funct3)
                lw: rmask = 4'b1111;
					 //////////////////
					 lb: begin
								case(mem_address[1:0])
									0: rmask = 4'b0001;
									1:	rmask = 4'b0010;
									2: rmask = 4'b0100;
									3: rmask = 4'b1000;
								endcase
							end
					 lh:	begin
								case(mem_address[1])
									0: rmask = 4'b0011;
									1: rmask = 4'b1100;
								endcase
							end
					 lbu: begin
								case(mem_address[1:0])
									0: rmask = 4'b0001;
									1:	rmask = 4'b0010;
									2: rmask = 4'b0100;
									3: rmask = 4'b1000;
								endcase
							end
					 lhu: begin
								case(mem_address[1])
									0: rmask = 4'b0011;
									1: rmask = 4'b1100;
								endcase
							end

					 ////////////////
                default: trap = 1;
            endcase
        end

        op_store: begin
            case (store_funct3)
                sw: wmask = 4'b1111;
					 /////////////////////
					 sb: begin
						case(mem_address[1:0])
							0: wmask = 4'b0001;
							1: wmask = 4'b0010;
							2: wmask = 4'b0100;
							3: wmask = 4'b1000;
						endcase
					 end
					 sh: begin
						case(mem_address[1])
							0: wmask = 4'b0011;
							1: wmask = 4'b1100;
						endcase
					 end
					 /////////////////////
                default: trap = 1;
            endcase
        end

        default: trap = 1;
    endcase

end







enum int unsigned {
    /* List of states */
	fetch1,
	fetch2,
	fetch3,
	decode,
	s_auipc,
	////////////////mp0
	br,
	s_lui,
	s_imm,
	calc_addr,
	ldr1,
	ldr2,
	str1,
	str2,
	//////////////////mp2
	s_reg,
	s_jal,
	s_jalr
} state, next_states;

always_comb
begin : state_actions
	 /* Default output assignments */
    /* Actions for each state */
	 /* Default assignments */
	load_pc = 1'b0;
	load_ir = 1'b0;
	load_regfile = 1'b0;
	alumux1_sel = 1'b0;
	alumux2_sel = 3'b000;

	//in many cases, aluop will be the same as funct3, so just typecast
	//it
	aluop = alu_ops'(funct3);
	mem_read = 1'b0;
	mem_write = 1'b0;
	mem_byte_enable = 4'b1111;
	pcmux_sel = 0;
	/* et cetera (see Appendix E) */
	load_mar = 1'b0;
	load_mdr = 1'b0;
	load_data_out = 1'b0;
	cmpop = branch_funct3_t'(funct3);
	regfilemux_sel= 3'b000;
	marmux_sel = 1'b0;
	cmpmux_sel = 1'b0;
	rs1_addr = 5'b0;
	rs2_addr = 5'b0;
	//////////////////////mp2
	mdrmux_sel = 3'b010;
	mem_data_out_sel = 2'b10;
	case(state)
		fetch1: begin
			/* MAR <= PC */
			load_mar = 1;
		end

		fetch2: begin
			/* Read memory */
			mem_read = 1;
			load_mdr = 1;
		end

		fetch3: begin
			/* Load IR */
			load_ir = 1;
		end

		decode: /* Do nothing */;
		s_lui: begin
			load_regfile =1;
			load_pc = 1;
			regfilemux_sel =2;
			rs1_addr =rs1;
		end
		s_auipc: begin
			/* DR <= PC + u_imm */
			load_regfile = 1;
			//PC is the first input to the ALU
			alumux1_sel = 1;
			//the u-type immediate is the second input to the ALU
			alumux2_sel = 1;
			//in the case of auipc, funct3 is some random bits so we
			//must explicitly set the aluop
			aluop = alu_add;
			/* PC <= PC + 4 */
			load_pc = 1;
		end

		s_imm: begin

			case(funct3)
				3'b010: begin
					load_regfile =1;
					load_pc =1;
					cmpop =blt;
					regfilemux_sel =1;
					cmpmux_sel =1;
					rs1_addr = rs1;
				end

				3'b011: begin
					load_regfile =1;
					load_pc =1;
					cmpop =bltu;
					regfilemux_sel =1;
					cmpmux_sel =1;
					rs1_addr = rs1;
				end

				3'b101: begin
					if (funct7 == 7'b0100000)
						begin
							load_regfile =1;
							load_pc =1;
							aluop = alu_sra;
							rs1_addr = rs1;
						end
					else
						begin
							load_regfile =1;
							load_pc =1;
							aluop=alu_ops'(funct3);
							rs1_addr = rs1;
						end
				end
				default: begin
							load_regfile =1;
							load_pc =1;
							aluop=alu_ops'(funct3);
							rs1_addr = rs1;
				end
				endcase
		end



		calc_addr: begin ///////////////////////////////////////////
			aluop = alu_add;
			load_mar =1;
			marmux_sel =1;
			if (opcode == op_store)
				begin
					alumux2_sel =3;
					load_data_out =1;
					case(store_funct3)
						sb: mem_data_out_sel = 0;
						sh: mem_data_out_sel = 1;
						sw: mem_data_out_sel = 2;
						default: mem_data_out_sel = 2;
					endcase
				end
		end

		br: begin
			pcmux_sel = br_en;
			load_pc =1;
			alumux1_sel =1;
			alumux2_sel =2;
			aluop = alu_add;

			///////////////
			rs1_addr = rs1;
			rs2_addr =rs2;
		end

		ldr1: begin
			load_mdr =1;
			mem_read =1;

		end

		ldr2: begin

			case(load_funct3)
					lb: mdrmux_sel=0;
					lh: mdrmux_sel=1;
					lw: mdrmux_sel=2;
					lbu:mdrmux_sel=3;
					lhu:mdrmux_sel=4;
					default:;
			endcase
			regfilemux_sel =3;
			load_regfile =1;
			load_pc =1;
			rs1_addr = rs1;

			////////// cp2
			//mdr_sel = funct3;


		end

		str1: begin
			mem_write =1;
			//load_data_out =1;
			case(store_funct3)

					sb:	begin
						case(mem_address[1:0])
							0: mem_byte_enable = 4'b0001;
							1: mem_byte_enable = 4'b0010;
							2: mem_byte_enable = 4'b0100;
							3: mem_byte_enable = 4'b1000;
						endcase
					end

					sh:	begin
						case(mem_address[1:0])
							0: mem_byte_enable = 4'b0011;
							1: mem_byte_enable = 4'b0011;
							2: mem_byte_enable = 4'b1100;
							3: mem_byte_enable = 4'b1100;
						endcase
					end

					sw:	begin
						mem_byte_enable = 4'b1111;

					end
					default: begin
						mem_byte_enable = 4'b1111;
					end
			endcase

		end

		str2: begin

			load_pc =1;
			rs1_addr =rs1;
			rs2_addr =rs2;
		end

		s_reg: begin
			case(arith_funct3_t'(funct3))
				slt : begin
					load_regfile =1;
					load_pc =1;
					cmpop =blt;
					regfilemux_sel =1;
					//alumux2_sel =4;
					rs1_addr =rs1;
					rs2_addr =rs2;
					//cmpmux_sel = 0;
					//aluop = alu_ops'(funct3);
				end

				sltu:	begin
					load_regfile =1;
					load_pc =1;
					cmpop = bltu;
					regfilemux_sel =1;
					//cmpmux_sel = 0;
					rs1_addr = rs1;
					rs2_addr = rs2;
				end
				sr:	begin
					if (funct7 ==7'b0100000)
						begin
							load_regfile =1;
							load_pc=1;
							aluop = alu_sra;
							alumux2_sel =4;
							rs1_addr = rs1;
							rs2_addr = rs2;
						end
					else
						begin
							load_regfile =1;
							load_pc =1;
							aluop =alu_ops'(funct3);
							alumux2_sel =4;
							rs1_addr = rs1;
							rs2_addr =rs2;
						end
				end
				default: begin
					load_regfile =1;
					load_pc =1;
					if (funct7 ==7'b0100000) aluop = alu_sub;
					else aluop =alu_ops'(funct3);
					alumux2_sel =4;
					rs1_addr = rs1;
					rs2_addr =rs2;
				end
			endcase
		end

		s_jal: begin
			load_regfile =1;
			load_pc =1;
			alumux2_sel = 5;
			rs1_addr = rs1;
			alumux1_sel = 1;
			pcmux_sel = 1;
			regfilemux_sel = 4;
			aluop = alu_add;
		end

		s_jalr: begin
			load_regfile =1;
			regfilemux_sel =4;
			load_pc =1;
			alumux1_sel = 0;
			alumux2_sel =0;
			aluop = alu_ops'(funct3);
			pcmux_sel = 2;
			rs1_addr = rs1;
		end
		default: /* Do nothing */;
	endcase
end


always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	 next_states = state;
	 case(state)
		fetch1: next_states = fetch2;
		fetch2: if (mem_resp) next_states= fetch3;
		fetch3: next_states = decode;
		decode: begin
			case(opcode)
				op_auipc: next_states = s_auipc;
				op_br: next_states = br;
				op_imm: next_states = s_imm;
				op_lui: next_states = s_lui;
				op_load: next_states  = calc_addr;
				op_store: next_states  = calc_addr;
				/////mp2
				op_reg: next_states = s_reg;
				op_jal: next_states = s_jal;
				op_jalr: next_states = s_jalr;
				default: $display("Unknown␣opcode");
			endcase
		end
		calc_addr: begin
			if (opcode == op_load) next_states = ldr1;
			else next_states = str1;
		end
		ldr1: if (mem_resp) next_states = ldr2;
		str1: if (mem_resp) next_states = str2;
		default: next_states = fetch1;
	 endcase

end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_states;
end

endmodule : control
