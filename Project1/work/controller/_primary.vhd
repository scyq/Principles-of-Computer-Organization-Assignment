library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        op              : in     vl_logic_vector(5 downto 0);
        fun             : in     vl_logic_vector(5 downto 0);
        RegDst          : out    vl_logic_vector(1 downto 0);
        ALUSrc          : out    vl_logic;
        MemToReg        : out    vl_logic_vector(1 downto 0);
        MemWr           : out    vl_logic;
        RegWr           : out    vl_logic;
        nPC_sel         : out    vl_logic_vector(1 downto 0);
        ExtOp           : out    vl_logic_vector(1 downto 0);
        ALUCtr          : out    vl_logic_vector(2 downto 0);
        overflow        : out    vl_logic
    );
end controller;
