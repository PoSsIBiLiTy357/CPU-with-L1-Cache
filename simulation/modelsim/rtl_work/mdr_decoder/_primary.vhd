library verilog;
use verilog.vl_types.all;
entity mdr_decoder is
    port(
        sel             : in     vl_logic_vector(2 downto 0);
        mdrreg_out      : in     vl_logic_vector(31 downto 0);
        mem_address     : in     vl_logic_vector(31 downto 0);
        o               : out    vl_logic_vector(31 downto 0)
    );
end mdr_decoder;
