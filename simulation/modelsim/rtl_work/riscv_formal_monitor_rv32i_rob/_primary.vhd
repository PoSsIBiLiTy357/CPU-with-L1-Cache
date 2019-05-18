library verilog;
use verilog.vl_types.all;
entity riscv_formal_monitor_rv32i_rob is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        i0_valid        : in     vl_logic;
        i0_order        : in     vl_logic_vector(63 downto 0);
        i0_data         : in     vl_logic_vector(176 downto 0);
        o0_valid        : out    vl_logic;
        o0_order        : out    vl_logic_vector(63 downto 0);
        o0_data         : out    vl_logic_vector(176 downto 0);
        errcode         : out    vl_logic_vector(15 downto 0)
    );
end riscv_formal_monitor_rv32i_rob;
