library verilog;
use verilog.vl_types.all;
entity cache_datapath is
    generic(
        s_offset        : integer := 5;
        s_index         : integer := 3;
        s_tag           : vl_notype;
        s_mask          : vl_notype;
        s_line          : vl_notype;
        num_sets        : vl_notype
    );
    port(
        clk             : in     vl_logic;
        mem_address     : in     vl_logic_vector(31 downto 0);
        mem_rdata       : out    vl_logic_vector(31 downto 0);
        mem_wdata       : in     vl_logic_vector(31 downto 0);
        mem_byte_enable : in     vl_logic_vector(3 downto 0);
        pmem_address    : out    vl_logic_vector(31 downto 0);
        pmem_rdata      : in     vl_logic_vector(255 downto 0);
        pmem_wdata      : out    vl_logic_vector(255 downto 0);
        data0_check     : out    vl_logic;
        data1_check     : out    vl_logic;
        hit             : out    vl_logic;
        tags1_read      : in     vl_logic;
        tags1_load      : in     vl_logic;
        tags2_read      : in     vl_logic;
        tags2_load      : in     vl_logic;
        valid0_read     : in     vl_logic;
        valid0_load     : in     vl_logic;
        valid1_read     : in     vl_logic;
        valid1_load     : in     vl_logic;
        lru_read        : in     vl_logic;
        lru_load        : in     vl_logic;
        lru_sel         : in     vl_logic;
        lru_out         : out    vl_logic;
        data1_read      : in     vl_logic;
        data2_read      : in     vl_logic;
        data0_mux_sel   : in     vl_logic;
        data1_mux_sel   : in     vl_logic;
        read_data_sel   : in     vl_logic_vector(1 downto 0);
        write_en0_sel   : in     vl_logic_vector(1 downto 0);
        write_en1_sel   : in     vl_logic_vector(1 downto 0);
        pmem_address_mux_sel: in     vl_logic_vector(1 downto 0);
        dirty_in        : in     vl_logic;
        dirty1_out      : out    vl_logic;
        dirty2_out      : out    vl_logic;
        dirty1_load     : in     vl_logic;
        dirty1_read     : in     vl_logic;
        dirty2_load     : in     vl_logic;
        dirty2_read     : in     vl_logic;
        pmem_wdata_mux_sel: in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of s_offset : constant is 1;
    attribute mti_svvh_generic_type of s_index : constant is 1;
    attribute mti_svvh_generic_type of s_tag : constant is 3;
    attribute mti_svvh_generic_type of s_mask : constant is 3;
    attribute mti_svvh_generic_type of s_line : constant is 3;
    attribute mti_svvh_generic_type of num_sets : constant is 3;
end cache_datapath;