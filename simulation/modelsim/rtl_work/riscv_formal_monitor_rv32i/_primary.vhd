library verilog;
use verilog.vl_types.all;
entity riscv_formal_monitor_rv32i is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        rvfi_valid      : in     vl_logic_vector(0 downto 0);
        rvfi_order      : in     vl_logic_vector(63 downto 0);
        rvfi_insn       : in     vl_logic_vector(31 downto 0);
        rvfi_trap       : in     vl_logic_vector(0 downto 0);
        rvfi_halt       : in     vl_logic_vector(0 downto 0);
        rvfi_intr       : in     vl_logic_vector(0 downto 0);
        rvfi_rs1_addr   : in     vl_logic_vector(4 downto 0);
        rvfi_rs2_addr   : in     vl_logic_vector(4 downto 0);
        rvfi_rs1_rdata  : in     vl_logic_vector(31 downto 0);
        rvfi_rs2_rdata  : in     vl_logic_vector(31 downto 0);
        rvfi_rd_addr    : in     vl_logic_vector(4 downto 0);
        rvfi_rd_wdata   : in     vl_logic_vector(31 downto 0);
        rvfi_pc_rdata   : in     vl_logic_vector(31 downto 0);
        rvfi_pc_wdata   : in     vl_logic_vector(31 downto 0);
        rvfi_mem_addr   : in     vl_logic_vector(31 downto 0);
        rvfi_mem_rmask  : in     vl_logic_vector(3 downto 0);
        rvfi_mem_wmask  : in     vl_logic_vector(3 downto 0);
        rvfi_mem_rdata  : in     vl_logic_vector(31 downto 0);
        rvfi_mem_wdata  : in     vl_logic_vector(31 downto 0);
        errcode         : out    vl_logic_vector(15 downto 0)
    );
end riscv_formal_monitor_rv32i;
