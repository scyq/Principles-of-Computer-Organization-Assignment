library verilog;
use verilog.vl_types.all;
entity dev_out is
    port(
        clk             : in     vl_logic;
        data_in         : in     vl_logic_vector(31 downto 0);
        addr            : in     vl_logic;
        we              : in     vl_logic;
        data_out        : out    vl_logic_vector(31 downto 0)
    );
end dev_out;
