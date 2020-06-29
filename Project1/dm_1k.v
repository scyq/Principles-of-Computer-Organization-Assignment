module dm_1k(addr, din, we, clk, dout);
  input [9:0] addr;     // address bus
  input [31:0] din;     // 32-bit input data
  input we;             // memory write enable
  input clk;            // clock
  output reg [31:0] dout;   // 32-bit memory output
  reg [7:0] dm[1023:0];
  
  always @(clk)
  begin 
    if (we)
      {dm[addr+3], dm[addr+2], dm[addr+1], dm[addr]} <= din;
    else
      dout <= {dm[addr+3], dm[addr+2], dm[addr+1], dm[addr]};
  end
endmodule
