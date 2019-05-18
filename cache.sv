import rv32i_types::*;
module cache #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
	input clk,

	input mem_read,mem_write,
	output logic mem_resp,
	input [31:0]mem_address,
	output rv32i_word mem_rdata,
	input rv32i_word mem_wdata,
	input [3:0]mem_byte_enable,

	output rv32i_word pmem_address,
	input logic [255:0] pmem_rdata,
	output logic [255:0] pmem_wdata,
	input pmem_resp,
	output logic pmem_read,pmem_write
);

///internal
	logic data0_check;
	logic data1_check;
	logic hit;
	logic tags1_read;
	logic tags1_load;
	logic tags2_read;
	logic tags2_load;
	logic valid0_read;
	logic valid0_load;
	logic valid1_read;
	logic valid1_load;
	logic lru_read;
	logic lru_load;
	logic lru_sel;
	logic lru_out;
	logic data1_read;
	logic data2_read;
	logic data0_mux_sel;
	logic data1_mux_sel;
	logic [1:0] read_data_sel;
	//logic pmem_adress_out_load;
	logic [1:0]write_en0_sel;
	logic [1:0]write_en1_sel;
	logic [1:0]pmem_address_mux_sel;
  logic dirty_in;
  logic dirty1_out;
  logic dirty2_out;
  logic dirty1_load;
  logic dirty2_load;
  logic dirty1_read;
  logic dirty2_read;
  logic pmem_wdata_mux_sel;

cache_datapath datapath(
	.clk,
	////////////////////////////from cpu
	.mem_address(mem_address),
	.mem_rdata(mem_rdata),
	.mem_wdata(mem_wdata),
	.mem_byte_enable(mem_byte_enable),

	///////////////////////////from memmory
	.pmem_address(pmem_address),
	.pmem_rdata(pmem_rdata),
	.pmem_wdata(pmem_wdata),
	//////////////////////////cache control
	.data0_check(data0_check),
	.data1_check(data1_check),
	.hit(hit),
	.tags1_read,
	.tags1_load,
	.tags2_read,
	.tags2_load,
	.valid0_read,
	.valid0_load,
	.valid1_read,
	.valid1_load,
	.lru_read,
	.lru_load,
	.lru_sel,
	.lru_out,
	.data1_read,
	.data2_read,
	.data0_mux_sel,
	.data1_mux_sel,
	.read_data_sel,
	//.pmem_adress_out_load,
	.write_en0_sel,
	.write_en1_sel,
  .pmem_address_mux_sel,
  .dirty_in,
  .dirty1_out,
  .dirty2_out,
  .dirty1_load,
  .dirty2_load,
  .dirty1_read,
  .dirty2_read,
  .pmem_wdata_mux_sel,
	.*
);

cache_control control(

	.*
);
endmodule : cache
