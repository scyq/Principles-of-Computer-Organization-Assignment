module machine(clk, rst, in);
  input clk, rst;
  input [31:0] in;  // for dev_in input
  
  wire [31:0] pr_addr, pr_rd, wdin, cp0_out, pc_, epc, bridge_out;
  wire [31:0] rd1, rd2, rd3;
  wire [5:0] hw_int;
  wire [4:0] cp0_addr;
  wire [1:0] out_addr;
  wire out_we, timer_we, wecpu, cp0_we, exlset, exlclr, int_req, int_req_sel;
  
  mips cpu_(clk, rst, pr_addr, pr_rd, wdin, wecpu, cp0_out, cp0_addr, cp0_we, exlset, exlclr, pc_, epc, int_req_sel);
  Bridge bridge_(pr_addr, wdin, pr_rd, bridge_out, wecpu, out_we, timer_we, {5'b0, int_req}, hw_int, out_addr, rd1, rd2, rd3);
  timer timer_(clk, rst, out_addr, timer_we, wdin, rd3, int_req);
  dev_in dev_in_(in, rd1);
  dev_out dev_out_(clk, bridge_out, out_addr[0], out_we, rd2);
  cp0 cp0_(clk, rst, wdin, cp0_out, cp0_addr, cp0_we, exlset, exlclr, pc_, epc, hw_int, int_req_sel);
  
endmodule
