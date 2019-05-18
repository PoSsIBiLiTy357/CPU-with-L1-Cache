library verilog;
use verilog.vl_types.all;
entity shadow_memory is
    port(
        clk             : in     vl_logic;
        valid           : in     vl_logic;
        wmask           : in     vl_logic_vector(3 downto 0);
        rmask           : in     vl_logic_vector(3 downto 0);
        addr            : in     vl_logic_vector(31 downto 0);
        wdata           : in     vl_logic_vector(31 downto 0);
        rdata           : in     vl_logic_vector(31 downto 0);
        pc_rdata        : in     vl_logic_vector(31 downto 0);
        insn            : in     vl_logic_vector(31 downto 0);
        error           : out    vl_logic
    );
end shadow_memory;
