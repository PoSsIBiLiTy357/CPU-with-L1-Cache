import rv32i_types::*;

module mdr_decoder
(
    input [2:0]sel,
    input rv32i_word mdrreg_out,
	 input rv32i_word mem_address,
    output rv32i_word o
);



always_comb
begin

    case (sel)
        0:  begin
					case(mem_address[1:0])
						0:	o = {{24{mdrreg_out[7]}},mdrreg_out[7:0]};
						1:	o = {{24{mdrreg_out[7+8]}},mdrreg_out[7+8:0+8]};
						2:	o = {{24{mdrreg_out[7+16]}},mdrreg_out[7+16:0+16]};
						3: o = {{24{mdrreg_out[7+24]}},mdrreg_out[7+24:0+24]};
					endcase
				end
				
        1:  begin
					case(mem_address[1:0])
						0:	o = {{16{mdrreg_out[15]}},mdrreg_out[15:0]};
						1:	o = {{16{mdrreg_out[15]}},mdrreg_out[15:0]};
						2:	o = {{16{mdrreg_out[15+16]}},mdrreg_out[15+16:0+16]};
						3: o = {{16{mdrreg_out[15+16]}},mdrreg_out[15+16:0+16]};
					endcase
				end				
				
        2:  o = mdrreg_out;

        3:  begin
					case(mem_address[1:0])
						0:	o = {24'b0,mdrreg_out[7:0]};
						1:	o = {24'b0,mdrreg_out[7+8:0+8]};
						2:	o = {24'b0,mdrreg_out[7+16:0+16]};
						3: o = {24'b0,mdrreg_out[7+24:0+24]};
					endcase
				end					
				
        4:  begin
					case(mem_address[1:0])
						0:	o = {16'b0,mdrreg_out[15:0]};
						1:	o = {16'b0,mdrreg_out[15:0]};
						2:	o = {16'b0,mdrreg_out[15+16:0+16]};
						3: o = {16'b0,mdrreg_out[15+16:0+16]};
					endcase
				end				
				
		default:o = mdrreg_out;
				


    endcase
end

endmodule : mdr_decoder