library verilog;
use verilog.vl_types.all;
entity \array\ is
    generic(
        s_index         : integer := 3;
        width           : integer := 1;
        num_sets        : vl_notype
    );
    port(
        clk             : in     vl_logic;
        read            : in     vl_logic;
        load            : in     vl_logic;
        index           : in     vl_logic_vector;
        datain          : in     vl_logic_vector;
        dataout         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of s_index : constant is 1;
    attribute mti_svvh_generic_type of width : constant is 1;
    attribute mti_svvh_generic_type of num_sets : constant is 3;
end \array\;
