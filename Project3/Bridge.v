module Bridge(pr_addr, pr_wd, pr_rd, bridge_out, we_cpu, out_dev_we, timer_we, hw_intr_in, hw_intr_out, dev_addr, rd1, rd2, rd3);
  input [31:0] pr_addr;           // dev address
  input [31:0] pr_wd;             // cpu wants to write
  input [31:0] rd1, rd2, rd3;     // from three different dev
  input [7:2] hw_intr_in;
  input we_cpu;
  
  output [31:0] pr_rd;            // dev to cpu
  output [31:0] bridge_out;       // cpu to out dev
  output [7:2] hw_intr_out;
  output [1:0] dev_addr;          // to choose inside register of dev
  output out_dev_we, timer_we;    // depends on we_cpu
  
  wire hit_in, hit_out, hit_timer;
  
  assign hit_in = (pr_addr[31:4] == 28'h0000_7f2);
  assign hit_out = (pr_addr[31:4] == 28'h0000_7f1);
  assign hit_timer = (pr_addr[31:4] == 28'h0000_7f0);
  
  assign out_dev_we = hit_out && we_cpu;
  assign timer_we = hit_timer && we_cpu;
  
  assign hw_intr_out = hw_intr_in;
  assign bridge_out = pr_wd;
  
  assign dev_addr = pr_addr[3:2];
  assign pr_rd = hit_in ? rd1:
                 hit_out ? rd2:
                 hit_timer ? rd3: pr_rd;
  
endmodule
