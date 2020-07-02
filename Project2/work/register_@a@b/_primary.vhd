library verilog;
use verilog.vl_types.all;
entity register_AB is
    port(
        clk             : in     vl_logic;
        from_gpr        : in     vl_logic_vector(31 downto 0);
        data_out        : out    vl_logic_vector(31 downto 0)
    );
end register_AB;
