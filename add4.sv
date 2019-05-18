import rv32i_types::*;

module add4
(
	input rv32i_word a,
	output rv32i_word f
);

always_comb
	begin 
		f = a+4;
	end

endmodule : add4