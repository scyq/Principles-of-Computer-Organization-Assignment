module gpr(rA, rB, busA, busB, rW, busW, regWr, clk, rst, regDst);
  input [4:0] rA, rB, rW; 
  input [31:0] busW;
  input regWr, clk, rst;
  input [1:0] regDst;
  output [31:0] busA, busB;
  reg [31:0] regs[31:0];
  
  integer i;  // for counts
  always @(posedge clk or posedge rst)
  begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1)
        regs[i] = 0;
    end
    else begin
      if (regWr && regDst != 2'b11) begin    // not overflow condition
        if ( rW != 0 )
          regs[rW] <= busW;
      end
      else begin  // overflow
        regs[5'b11110][0] = 1;
      end
    end
  end
  
  assign busA = regs[rA];
  assign busB = regs[rB];

endmodule