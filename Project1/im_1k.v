module im_1k(addr, dout);
  input [9:0] addr;    // address bus
  output[31:0] dout;  // 32-bit memory out
  reg [7:0] im[1023:0];
  assign dout = {im[addr], im[addr+1], im[addr+2], im[addr+3]};
endmodule