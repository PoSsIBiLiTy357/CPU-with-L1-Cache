//import rv32i_types::*;
module cache_control (
	input clk,
	input data0_check,
	input data1_check,
	input hit,
	output logic tags1_read,
	output logic tags1_load,
	output logic tags2_read,
	output logic tags2_load,
	output logic valid0_read,
	output logic valid0_load,
	output logic valid1_read,
	output logic valid1_load,
	output logic lru_read,
	output logic lru_load,
	output logic lru_sel,
	input lru_out,
	output logic data1_read,
	output logic data2_read,
	output logic data0_mux_sel,
	output logic data1_mux_sel,
	output logic [1:0] read_data_sel,
	output logic [1:0]write_en0_sel,
	output logic [1:0]write_en1_sel,
	output logic [1:0]pmem_address_mux_sel,
//////////////////////////////////
	input mem_read,mem_write,
	output logic mem_resp,
	input pmem_resp,
	output logic pmem_read,pmem_write,
	output logic dirty_in,
	input dirty1_out,
	input dirty2_out,
	output logic dirty1_load,
	output logic dirty2_load,
	output logic dirty1_read,
	output logic dirty2_read,
	output logic pmem_wdata_mux_sel
);

enum int unsigned{
read_reg,
hit_process,
refill
}state,next_states;

always_comb
begin: state_actions
	tags1_read = 0;
	tags1_load = 0;
	tags2_read = 0;
	tags2_load = 0;
	valid0_read = 0;
	valid0_load = 0;
	valid1_read = 0;
	valid1_load = 0;
	lru_read = 0;
	lru_load = 0;
	lru_sel = 0;
	read_data_sel =0;
	write_en0_sel =0;
	write_en1_sel =0;
	mem_resp =0;
	pmem_read =0;
	data1_read =0;
	data2_read =0;
	data0_mux_sel =0;
	data1_mux_sel =0;
	pmem_write =0;
	pmem_address_mux_sel=2;
	dirty_in=0;
	dirty1_load=0;
  dirty2_load=0;
	dirty1_read=0;
	dirty2_read=0;
	pmem_wdata_mux_sel=0;

	case(state)
		read_reg: begin

				lru_read =1;
				valid0_read =1;
				valid1_read =1;
				tags1_read =1;
				tags2_read =1;
				data1_read =1;
				data2_read =1;
				dirty1_read =1;
				dirty2_read =1;

		end

		hit_process: begin

			if(data0_check ==1) begin
				if (mem_read ==1) begin
					read_data_sel =0;
					lru_load =1;
					lru_sel =1;
					valid0_load =1;
					mem_resp =1;
				end
				else begin
					write_en0_sel =2;
					data0_mux_sel =1;
					dirty_in=1;
					dirty1_load=1;
					lru_load =1;
					lru_sel =1;
					mem_resp=1;
				end
			end

			if(data1_check ==1) begin
				if (mem_read ==1) begin
					read_data_sel =1;
					lru_load =1;
					lru_sel =0;
					valid1_load =1;
					mem_resp =1;
				end
				else begin
					write_en1_sel =2;
					data1_mux_sel=1;
					dirty_in=1;
					dirty2_load =1;
					lru_load =1;
					lru_sel =0;
					mem_resp=1;
				end
			end

			if(hit == 0 && lru_out ==0) begin

				if (dirty1_out ==1) begin
					pmem_write =1;
					pmem_wdata_mux_sel =0;
					pmem_address_mux_sel=0;

				end
				else begin
						pmem_read =1;
						pmem_address_mux_sel =2;
						lru_load =1;
						lru_sel =1;
						tags1_load = 1;
						valid0_load =1;
						read_data_sel = 2;
						write_en0_sel =1;
					  end
			end

			if(hit ==0 && lru_out ==1) begin

				if(dirty2_out ==1) begin
					pmem_write =1;
					pmem_wdata_mux_sel =1;
					pmem_address_mux_sel=1;
				end
				else begin
						pmem_read =1;
						pmem_address_mux_sel =2;
						lru_load =1;
						lru_sel =0;
						tags2_load =1;
						valid1_load =1;
						read_data_sel = 2;
						write_en1_sel =1;
					  end
			end
		end

		refill: begin

			if (lru_out ==0)begin
				if (dirty1_out ==0)begin

				end
				if (dirty1_out ==1)begin
					pmem_read =1;
					pmem_address_mux_sel =2;
					lru_load =1;
					lru_sel =1;
					tags1_load =1;
					valid0_load =1;
					read_data_sel = 2;
					write_en0_sel =1;
					dirty_in =0;
					dirty1_load =1;
				end
			end
			else begin

				if(dirty2_out ==1) begin
					pmem_read =1;
					pmem_address_mux_sel =2;
					lru_load =1;
					lru_sel =0;
					tags2_load =1;
					valid1_load =1;
					read_data_sel = 2;
					write_en1_sel =1;
					dirty_in =0;
					dirty2_load =1;
				end
			end

		end
		default:;
	endcase
end

always_comb
begin: next_state_logic
	next_states =state;
	case(state)
		read_reg: if(mem_read|mem_write) next_states = hit_process;
		hit_process:  begin

										if( hit) next_states = read_reg;
										 else if ((hit == 0 && lru_out ==0 && dirty1_out ==1)||(hit ==0 && lru_out ==1 && dirty2_out ==1))begin
														if (pmem_resp)next_states =refill;
												end
										 else if ((hit == 0 && lru_out ==0 && dirty1_out ==0)||(hit ==0 && lru_out ==1 && dirty2_out ==0))begin
														if(pmem_resp)next_states = read_reg;
												end
										 else next_states = refill;
									end
						
		refill: if(pmem_resp) next_states = read_reg;
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_states;
end


endmodule : cache_control
