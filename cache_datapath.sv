import rv32i_types::*;

module cache_datapath #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
	input clk,
	////////////////////////////from cpu
	input rv32i_word mem_address,
	output rv32i_word mem_rdata,
	input rv32i_word mem_wdata,
	input [3:0]mem_byte_enable,

	///////////////////////////from memmory
	output rv32i_word pmem_address,
	input logic [255:0] pmem_rdata,
	output logic [255:0] pmem_wdata,
	//////////////////////////cache control
	output logic data0_check,
	output logic data1_check,
	output logic hit,
	input tags1_read,
	input tags1_load,
	input tags2_read,
	input tags2_load,
	input valid0_read,
	input valid0_load,
	input valid1_read,
	input valid1_load,
	input lru_read,
	input lru_load,
	input lru_sel,
	output logic lru_out,
	input data1_read,
	input data2_read,
	input data0_mux_sel,
	input data1_mux_sel,
	input [1:0] read_data_sel,
	input [1:0]write_en0_sel,
	input [1:0]write_en1_sel,
  input [1:0]pmem_address_mux_sel,
  input dirty_in,
  output logic dirty1_out,
  output logic dirty2_out,
  input dirty1_load,
  input dirty1_read,
  input dirty2_load,
  input dirty2_read,
  input pmem_wdata_mux_sel
);


/////internal signal
logic [23:0]tags1_out;
logic [23:0]tags2_out;
logic valid0_out;
logic valid1_out;
logic cmp0_out;
logic cmp1_out;
logic [31:0] mem_byte_enable256;
logic [255:0] data1_mux_out;
logic [255:0] data2_mux_out;
logic [255:0] data1_out;
logic [255:0] data2_out;
logic [255:0] bus_mux_out;
logic [31:0] write_en0;
logic [31:0] write_en1;
logic [255:0] cpu_wdata;
assign data0_check = cmp0_out & valid0_out;
assign data1_check = cmp1_out & valid1_out;
assign hit = data0_check | data1_check;


array #(.width(24)) tag[2]
(
    clk,
	  {tags1_read,tags2_read},
    {tags1_load,tags2_load},
    mem_address[7:5],
    mem_address[31:8],
    {tags1_out,tags2_out}
);


array  dirty[2]
(
    clk,
	  {dirty1_read,dirty2_read},
    {dirty1_load,dirty2_load},
    mem_address[7:5],
    dirty_in,
    {dirty1_out,dirty2_out}
);

array valid0
(
    .clk,
	 .read(valid0_read),
    .load(valid0_load),
    .index(mem_address[7:5]),
    .datain(1'b1),
    .dataout(valid0_out)
);

array valid1
(
    .clk,
	 .read(valid1_read),

    .load(valid1_load),
    .index(mem_address[7:5]),
    .datain(1'b1),
    .dataout(valid1_out)
);

array lru
(
    .clk,
	 .read(lru_read),
    .load(lru_load),
    .index(mem_address[7:5]),
    .datain(lru_sel),
    .dataout(lru_out)
);

cmp #(.width(24))cmp0
(
	.a({8'b0,mem_address[31:8]}),
	.b({8'b0,tags1_out}),
	.cmpop(beq),
	.f(cmp0_out)
);

cmp #(.width(24))cmp1
(
	.a({8'b0,mem_address[31:8]}),
	.b({8'b0,tags2_out}),
	.cmpop(beq),
	.f(cmp1_out)
);

data_array line[2]
(
	 clk,{data1_read,data2_read},
	 {write_en0,write_en1},mem_address[7:5],{data1_mux_out,data2_mux_out},{data1_out,data2_out}

);



bus_adapter bus_adapter
(
    .mem_wdata256(cpu_wdata),
    .mem_rdata256(bus_mux_out),
    .mem_wdata,
    .mem_rdata,
    .mem_byte_enable,
    .mem_byte_enable256(mem_byte_enable256),
    .address(mem_address)
);


mux4 #(.width(256))bus_mux
(
	.sel(read_data_sel),
	.a(data1_out),
	.b(data2_out),
	.c(pmem_rdata),
	.d(256'b0),
	.f(bus_mux_out)
);

mux2 #(.width(256))data0_mux
(
	.sel(data0_mux_sel),
	.a(pmem_rdata),
	.b(cpu_wdata),
	.f(data1_mux_out)
);

mux2 #(.width(256))data1_mux
(

	.sel(data1_mux_sel),
	.a(pmem_rdata),
	.b(cpu_wdata),
	.f(data2_mux_out)
);

mux4 write_en0_mux(
	.sel(write_en0_sel),
	.a(0),
	.b({32{1'b1}}),
	.c(mem_byte_enable256),
	.d(0),
	.f(write_en0)
);

mux4 write_en1_mux(
	.sel(write_en1_sel),
	.a(0),
	.b({32{1'b1}}),
	.c(mem_byte_enable256),
	.d(0),
	.f(write_en1)
);

mux4 pmem_address_mux(
  .sel(pmem_address_mux_sel),
  .a({tags1_out,mem_address[7:5],5'b00000}),
  .b({tags2_out,mem_address[7:5],5'b00000}),
  .c(mem_address),
  .d(0),
  .f(pmem_address)
);

mux2 #(.width(256))pmem_wdata_mux(
  .sel(pmem_wdata_mux_sel),
  .a(data1_out),
  .b(data2_out),
  .f(pmem_wdata)
);

endmodule : cache_datapath
