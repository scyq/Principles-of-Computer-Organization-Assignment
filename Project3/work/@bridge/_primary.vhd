library verilog;
use verilog.vl_types.all;
entity Bridge is
    port(
        pr_addr         : in     vl_logic_vector(31 downto 0);
        pr_wd           : in     vl_logic_vector(31 downto 0);
        pr_rd           : out    vl_logic_vector(31 downto 0);
        bridge_out      : out    vl_logic_vector(31 downto 0);
        we_cpu          : in     vl_logic;
        out_dev_we      : out    vl_logic;
        timer_we        : out    vl_logic;
        hw_intr_in      : in     vl_logic_vector(7 downto 2);
        hw_intr_out     : out    vl_logic_vector(7 downto 2);
        dev_addr        : out    vl_logic_vector(1 downto 0);
        rd1             : in     vl_logic_vector(31 downto 0);
        rd2             : in     vl_logic_vector(31 downto 0);
        rd3             : in     vl_logic_vector(31 downto 0)
    );
end Bridge;
