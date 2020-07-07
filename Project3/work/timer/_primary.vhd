library verilog;
use verilog.vl_types.all;
entity timer is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        addr            : in     vl_logic_vector(3 downto 2);
        we              : in     vl_logic;
        data_in         : in     vl_logic_vector(31 downto 0);
        data_out        : out    vl_logic_vector(31 downto 0);
        irq             : out    vl_logic
    );
end timer;
