library verilog;
use verilog.vl_types.all;
entity machine is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        \in\            : in     vl_logic_vector(31 downto 0)
    );
end machine;
