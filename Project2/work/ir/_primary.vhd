library verilog;
use verilog.vl_types.all;
entity ir is
    port(
        clk             : in     vl_logic;
        ir_wr           : in     vl_logic;
        ins_in          : in     vl_logic_vector(31 downto 0);
        opcode          : out    vl_logic_vector(5 downto 0);
        rs              : out    vl_logic_vector(4 downto 0);
        rt              : out    vl_logic_vector(4 downto 0);
        rd              : out    vl_logic_vector(4 downto 0);
        funct           : out    vl_logic_vector(5 downto 0);
        imm16           : out    vl_logic_vector(15 downto 0);
        imm26           : out    vl_logic_vector(25 downto 0)
    );
end ir;
