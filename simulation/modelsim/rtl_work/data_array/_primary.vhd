library verilog;
use verilog.vl_types.all;
entity data_array is
    generic(
        s_offset        : integer := 5;
        s_index         : integer := 3;
        s_mask          : vl_notype;
        s_line          : vl_notype;
        num_sets        : vl_notype
    );
    port(
        clk             : in     vl_logic;
        read            : in     vl_logic;
        write_en        : in     vl_logic_vector;
        index           : in     vl_logic_vector;
        datain          : in     vl_logic_vector;
        dataout         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of s_offset : constant is 1;
    attribute mti_svvh_generic_type of s_index : constant is 1;
    attribute mti_svvh_generic_type of s_mask : constant is 3;
    attribute mti_svvh_generic_type of s_line : constant is 3;
    attribute mti_svvh_generic_type of num_sets : constant is 3;
end data_array;
