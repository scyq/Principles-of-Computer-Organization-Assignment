library verilog;
use verilog.vl_types.all;
entity pc is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        npc             : in     vl_logic_vector(31 downto 0);
        pc_wr           : in     vl_logic;
        pc              : out    vl_logic_vector(31 downto 0)
    );
end pc;
