library verilog;
use verilog.vl_types.all;
entity riscv_formal_monitor_rv32i_insn_sw is
    port(
        rvfi_valid      : in     vl_logic;
        rvfi_insn       : in     vl_logic_vector(31 downto 0);
        rvfi_pc_rdata   : in     vl_logic_vector(31 downto 0);
        rvfi_rs1_rdata  : in     vl_logic_vector(31 downto 0);
        rvfi_rs2_rdata  : in     vl_logic_vector(31 downto 0);
        rvfi_mem_rdata  : in     vl_logic_vector(31 downto 0);
        spec_valid      : out    vl_logic;
        spec_trap       : out    vl_logic;
        spec_rs1_addr   : out    vl_logic_vector(4 downto 0);
        spec_rs2_addr   : out    vl_logic_vector(4 downto 0);
        spec_rd_addr    : out    vl_logic_vector(4 downto 0);
        spec_rd_wdata   : out    vl_logic_vector(31 downto 0);
        spec_pc_wdata   : out    vl_logic_vector(31 downto 0);
        spec_mem_addr   : out    vl_logic_vector(31 downto 0);
        spec_mem_rmask  : out    vl_logic_vector(3 downto 0);
        spec_mem_wmask  : out    vl_logic_vector(3 downto 0);
        spec_mem_wdata  : out    vl_logic_vector(31 downto 0)
    );
end riscv_formal_monitor_rv32i_insn_sw;
