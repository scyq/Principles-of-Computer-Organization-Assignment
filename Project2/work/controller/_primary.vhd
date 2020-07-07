library verilog;
use verilog.vl_types.all;
entity controller is
    generic(
        s0              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        s1              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        s2              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        s3              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        s4              : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        s5              : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        s6              : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        s7              : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1);
        s8              : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0);
        s9              : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        opcode          : in     vl_logic_vector(5 downto 0);
        funct           : in     vl_logic_vector(5 downto 0);
        zero            : in     vl_logic;
        overflow        : in     vl_logic;
        pc_wr           : out    vl_logic;
        npc_sel         : out    vl_logic_vector(1 downto 0);
        ir_wr           : out    vl_logic;
        gpr_wr          : out    vl_logic;
        dm_wr           : out    vl_logic;
        ALUCtr          : out    vl_logic_vector(2 downto 0);
        reg_dst         : out    vl_logic_vector(1 downto 0);
        reg_from_sel    : out    vl_logic_vector(1 downto 0);
        b_sel           : out    vl_logic;
        ext_op          : out    vl_logic_vector(1 downto 0);
        word_byte_sel   : out    vl_logic;
        bltzal_sel      : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of s0 : constant is 1;
    attribute mti_svvh_generic_type of s1 : constant is 1;
    attribute mti_svvh_generic_type of s2 : constant is 1;
    attribute mti_svvh_generic_type of s3 : constant is 1;
    attribute mti_svvh_generic_type of s4 : constant is 1;
    attribute mti_svvh_generic_type of s5 : constant is 1;
    attribute mti_svvh_generic_type of s6 : constant is 1;
    attribute mti_svvh_generic_type of s7 : constant is 1;
    attribute mti_svvh_generic_type of s8 : constant is 1;
    attribute mti_svvh_generic_type of s9 : constant is 1;
end controller;
