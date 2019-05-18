import rv32i_types::*;
module mp2
(
	input clk,
	
	output logic [255:0] pmem_wdata,
	input [255:0] pmem_rdata,
	output logic pmem_read,
	//output rv32i_mem_wmask mem_byte_enable,
	output rv32i_word pmem_address,
	output logic pmem_write,
	input pmem_resp
	
	
);

/* Instantiate MP 2 top level blocks here */
//internal
logic mem_read;
logic mem_write;
logic mem_resp;
logic [31:0] mem_address;
logic [31:0] mem_rdata;
logic [31:0] mem_wdata;
logic [3:0]mem_byte_enable;

cpu cpu
(
	.clk,
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_resp(mem_resp),
	.mem_address(mem_address),
	.mem_rdata(mem_rdata),
	.mem_wdata(mem_wdata),
	.mem_byte_enable(mem_byte_enable)
);

cache cache
(
	.clk,
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_resp(mem_resp),
	.mem_address(mem_address),
	.mem_rdata(mem_rdata),
	.mem_wdata(mem_wdata),
	.mem_byte_enable(mem_byte_enable),
	.pmem_wdata(pmem_wdata),
	.pmem_rdata(pmem_rdata),
	.pmem_read(pmem_read),
	.pmem_address(pmem_address),
	.pmem_write(pmem_write),
	.pmem_resp(pmem_resp)
);
endmodule : mp2
