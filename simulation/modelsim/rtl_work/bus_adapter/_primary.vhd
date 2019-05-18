library verilog;
use verilog.vl_types.all;
entity bus_adapter is
    port(
        mem_wdata256    : out    vl_logic_vector(255 downto 0);
        mem_rdata256    : in     vl_logic_vector(255 downto 0);
        mem_wdata       : in     vl_logic_vector(31 downto 0);
        mem_rdata       : out    vl_logic_vector(31 downto 0);
        mem_byte_enable : in     vl_logic_vector(3 downto 0);
        mem_byte_enable256: out    vl_logic_vector(31 downto 0);
        address         : in     vl_logic_vector(31 downto 0)
    );
end bus_adapter;
