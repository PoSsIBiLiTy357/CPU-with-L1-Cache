library verilog;
use verilog.vl_types.all;
entity add4 is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        f               : out    vl_logic_vector(31 downto 0)
    );
end add4;
