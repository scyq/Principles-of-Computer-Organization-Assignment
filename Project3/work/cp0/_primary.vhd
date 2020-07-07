library verilog;
use verilog.vl_types.all;
entity cp0 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_in         : in     vl_logic_vector(31 downto 0);
        data_out        : out    vl_logic_vector(31 downto 0);
        reg_addr        : in     vl_logic_vector(4 downto 0);
        we              : in     vl_logic;
        exlset          : in     vl_logic;
        exlclr          : in     vl_logic;
        pc_in           : in     vl_logic_vector(31 downto 0);
        epc_out         : out    vl_logic_vector(31 downto 0);
        hw_int          : in     vl_logic_vector(7 downto 2);
        int_req_sel     : out    vl_logic
    );
end cp0;
