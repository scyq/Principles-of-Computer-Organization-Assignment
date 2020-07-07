library verilog;
use verilog.vl_types.all;
entity dev_in is
    port(
        data_in         : in     vl_logic_vector(31 downto 0);
        data_out        : out    vl_logic_vector(31 downto 0)
    );
end dev_in;
