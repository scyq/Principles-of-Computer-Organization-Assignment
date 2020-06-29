library verilog;
use verilog.vl_types.all;
entity npc is
    port(
        pc              : in     vl_logic_vector(31 downto 0);
        imm             : in     vl_logic_vector(25 downto 0);
        imm16           : in     vl_logic_vector(15 downto 0);
        zero            : in     vl_logic;
        npc_sel         : in     vl_logic_vector(1 downto 0);
        gpr_in          : in     vl_logic_vector(31 downto 0);
        npc             : out    vl_logic_vector(31 downto 0);
        pc_4            : out    vl_logic_vector(31 downto 0)
    );
end npc;
