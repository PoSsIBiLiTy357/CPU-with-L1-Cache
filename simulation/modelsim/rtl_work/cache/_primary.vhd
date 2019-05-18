library verilog;
use verilog.vl_types.all;
entity cache is
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
        mem_read        : in     vl_logic;
        mem_write       : in     vl_logic;
        mem_resp        : out    vl_logic;
        mem_address     : in     vl_logic_vector(31 downto 0);
        mem_rdata       : out    vl_logic_vector(31 downto 0);
        mem_wdata       : in     vl_logic_vector(31 downto 0);
        mem_byte_enable : in     vl_logic_vector(3 downto 0);
        pmem_address    : out    vl_logic_vector(31 downto 0);
        pmem_rdata      : in     vl_logic_vector(255 downto 0);
        pmem_wdata      : out    vl_logic_vector(255 downto 0);
        pmem_resp       : in     vl_logic;
        pmem_read       : out    vl_logic;
        pmem_write      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of s_offset : constant is 1;
    attribute mti_svvh_generic_type of s_index : constant is 1;
    attribute mti_svvh_generic_type of s_tag : constant is 3;
    attribute mti_svvh_generic_type of s_mask : constant is 3;
    attribute mti_svvh_generic_type of s_line : constant is 3;
    attribute mti_svvh_generic_type of num_sets : constant is 3;
end cache;
