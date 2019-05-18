import rv32i_types::*;
module cpu
(
	input clk,
	
	input rv32i_word  mem_rdata,
	output logic mem_read,
	output logic mem_write,
	output rv32i_mem_wmask  mem_byte_enable ,
	output rv32i_word mem_address,
	output rv32i_word mem_wdata,
	input mem_resp 
	
	
);

/* Instantiate MP 0 top level blocks here */
	
logic [1:0]pcmux_sel;
logic load_pc;
logic load_ir;
logic load_regfile;
logic load_mar;
logic load_mdr;
logic load_data_out;
logic alumux1_sel;
logic [2:0] alumux2_sel;
logic [2:0] regfilemux_sel;
logic marmux_sel;
logic cmpmux_sel;

alu_ops aluop;  	 
branch_funct3_t  cmpop;
rv32i_opcode opcode;
logic  [2:0] funct3;
logic  [6:0] funct7;
logic br_en;
rv32i_reg rs1;
rv32i_reg rs2;
///////////////////////cp2
logic [2:0]mdrmux_sel;
//store_funct3_t mem_data_out_sel;
logic [1:0]mem_data_out_sel;
datapath datapath(
    .clk(clk),

    
    .pcmux_sel(pcmux_sel),
    .load_pc(load_pc),
	 .load_ir(load_ir),
	 .load_regfile(load_regfile),
	 .load_mar(load_mar),
	 .load_mdr(load_mdr),
	 .load_data_out(load_data_out),
	 .alumux1_sel(alumux1_sel),
	 .alumux2_sel(alumux2_sel),
	 .regfilemux_sel(regfilemux_sel),
	 .marmux_sel(marmux_sel),
	 .cmpmux_sel(cmpmux_sel),
	 .aluop(aluop),  
	 .cmpop(cmpop),
	 .mem_rdata(mem_rdata),
	 .mem_wdata(mem_wdata),
	 .opcode(opcode),
	 .funct3(funct3),
	 .funct7(funct7),
	 .br_en(br_en),
	.mdrmux_sel(mdrmux_sel),
	.mem_address(mem_address),
	.mem_data_out_sel(mem_data_out_sel),
	.*
	
);

control control(
   .clk(clk),
	.opcode(opcode),
	.load_pc(load_pc),
	.load_ir(load_ir),
	.load_regfile(load_regfile),
	.alumux1_sel(alumux1_sel),
	.alumux2_sel(alumux2_sel),
	.aluop(aluop),
	.load_mar(load_mar),
	.load_mdr(load_mdr),
	.load_data_out(load_data_out),
	.pcmux_sel(pcmux_sel),
	.regfilemux_sel(regfilemux_sel),
	.marmux_sel(marmux_sel),
	.cmpmux_sel(cmpmux_sel),	
	.rs1(rs1),
	.rs2(rs2),
	.funct3(funct3),
	.funct7(funct7),
	.br_en(br_en),
	.cmpop(cmpop),
	.mem_resp(mem_resp),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mdrmux_sel(mdrmux_sel),
	.mem_address(mem_address),
	.mem_data_out_sel(mem_data_out_sel)
);


endmodule : cpu
