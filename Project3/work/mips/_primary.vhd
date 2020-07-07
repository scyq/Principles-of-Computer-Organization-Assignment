library verilog;
use verilog.vl_types.all;
entity mips is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pr_addr         : out    vl_logic_vector(31 downto 0);
        pr_rd           : in     vl_logic_vector(31 downto 0);
        wdin            : out    vl_logic_vector(31 downto 0);
        wecpu           : out    vl_logic;
        cp0_rd          : in     vl_logic_vector(31 downto 0);
        cp0_addr        : out    vl_logic_vector(4 downto 0);
        cp0_we          : out    vl_logic;
        exlset          : out    vl_logic;
        exlclr          : out    vl_logic;
        \pc_\           : out    vl_logic_vector(31 downto 0);
        epc             : in     vl_logic_vector(31 downto 0);
        int_req_sel     : in     vl_logic
    );
end mips;
