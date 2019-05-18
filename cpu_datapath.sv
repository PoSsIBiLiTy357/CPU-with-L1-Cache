import rv32i_types::*;

module datapath
(
    input clk,

    /* control signals */
    input [1:0]pcmux_sel,
    input load_pc,
	 input load_ir,
	 input load_regfile,
	 input load_mar,
	 input load_mdr,
	 input load_data_out,
	 input alumux1_sel,
	 input [2:0] alumux2_sel,
	 input [2:0] regfilemux_sel,
	 input marmux_sel,
	 input cmpmux_sel,
	 input alu_ops aluop,  
	 
    /* declare more ports here */
	 	//// mp2cp2
	 input  [2:0]mdrmux_sel,
	 input [1:0]mem_data_out_sel,
	 
	 input branch_funct3_t  cmpop,
	 
	 input rv32i_word  mem_rdata,
	 output rv32i_word  mem_wdata,
	 output rv32i_opcode opcode,
	 output [2:0] funct3,
	 output [6:0] funct7,
	 
	 output br_en,
	 output rv32i_word  mem_address,
	 output rv32i_reg rs1,rs2
);

/* declare internal signals */
rv32i_word pcmux_out;
rv32i_word pc_out;
rv32i_word alu_out;
rv32i_word pc_plus4_out;
rv32i_reg rd ;
rv32i_word rs2_out, i_imm, cmpmux_out;
rv32i_word  rs1_out;
rv32i_word  u_imm,b_imm,s_imm ,j_imm;
rv32i_word  alumux1_out, alumux2_out ;
rv32i_word  regfilemux_out ;
rv32i_word  marmux_out;
//rv32i_word  pc_plus4_out;
rv32i_word  mdrreg_out;
//rv32i_word mem_wdata_input;
//rv32i_word  mem_wdata,mem_rdata ;
rv32i_word mdr_mux_out;
rv32i_word ext_out;
/*
 * PC
 */
 
add4 add4
(
	 .a(pc_out),
	 .f(pc_plus4_out)
);
 
 
 
mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus4_out),
    .b(alu_out),
	 .c({alu_out[31:1],1'b0}),
	 .d(0),
    .f(pcmux_out)
);

pc_register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

mux2 cmpmux
(
	 .sel(cmpmux_sel),
	 .a(rs2_out),
	 .b(/*pc_out*/i_imm),
	 .f(cmpmux_out)
);

mux2 marmux
(
	 .sel(marmux_sel),
	 .a(pc_out),
	 .b(alu_out),
	 .f(marmux_out)
);

register mar
(
	.clk,
	.load(load_mar),
	.in(marmux_out),
	.out(mem_address)
);

ir IR
(
	 .clk,
    .load(load_ir),
    .in(mdr_mux_out),
    .funct3,
    .funct7,
    .opcode,
    .i_imm,
    .s_imm,
    .b_imm,
    .u_imm,
    .j_imm,
    .rs1,
    .rs2,
    .rd
);

regfile regfile
(	
    .clk,
    .load(load_regfile),
    .in(regfilemux_out),
    .src_a(rs1),
	 .src_b(rs2), 
	 .dest(rd),
    .reg_a(rs1_out),
	 .reg_b(rs2_out)
);

mux2 alumux1
(
	 .sel(alumux1_sel),
	 .a(rs1_out),
	 .b(pc_out),
	 .f(alumux1_out)
);

mux8 alumux2
(
	.sel(alumux2_sel),
	.a(i_imm),
	.b(u_imm),
	.c(b_imm),
	.d(s_imm),
	.e(rs2_out),
	.f(j_imm),
	.g(0),
	.o(alumux2_out)
);

alu alu
(
    .aluop,
    .a(alumux1_out),
	 .b(alumux2_out),
    .f(alu_out)
);


register	mem_data_out
(
    .clk,
    .load(load_data_out),
    .in(ext_out),
    .out(mem_wdata)
);

mux4 mem_data_out_mux
(
	.sel(mem_data_out_sel),
	.a({4{rs2_out[7:0]}}),
	.b({2{rs2_out[15:0]}}),
	.c(rs2_out),
	.d(0),
	.f(ext_out)
);

mdr_decoder mdr_decoder
(
	
	.sel(mdrmux_sel),
	//.a({{24{mdrreg_out[7]}},mdrreg_out[7:0]}),
	//.b({{16{mdrreg_out[15]}},mdrreg_out[15:0]}),
	.mdrreg_out(mdrreg_out),
	.mem_address(mem_address),
	//.d({24'b0,mdrreg_out[7:0]}),
	//.e({16'b0,mdrreg_out[15:0]}),
	//.f(0),
	//.g(0),
	.o(mdr_mux_out)
	
);




register mdr
(
	.clk,
	.load(load_mdr),
	.in(mem_rdata),
	.out(mdrreg_out)
);

mux8 regfilemux
(
	.sel(regfilemux_sel),
	.a(alu_out),
	.b({31'h0,br_en}),
	.c(u_imm),
	.d(mdr_mux_out),
	.e(pc_plus4_out),
	.f(0),
	.g(0),
	.o(regfilemux_out)
);


cmp cmp
(
	.a(rs1_out),
	.b(cmpmux_out),
	.cmpop(cmpop),
	.f(br_en)
);


/////////pc plus 4
endmodule : datapath
