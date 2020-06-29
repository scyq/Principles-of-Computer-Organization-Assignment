library verilog;
use verilog.vl_types.all;
entity gpr is
    port(
        rA              : in     vl_logic_vector(4 downto 0);
        rB              : in     vl_logic_vector(4 downto 0);
        busA            : out    vl_logic_vector(31 downto 0);
        busB            : out    vl_logic_vector(31 downto 0);
        rW              : in     vl_logic_vector(4 downto 0);
        busW            : in     vl_logic_vector(31 downto 0);
        regWr           : in     vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        regDst          : in     vl_logic_vector(1 downto 0)
    );
end gpr;
