module gpr(clk, rst, ra, rb, rw, busA, busB, busW, Reg_Wr, Reg_Dst);
  input clk, rst, Reg_Wr;
  input [4:0] ra, rb, rw;
  input [31:0] busW;
  input [1:0] Reg_Dst;
  output [31:0] busA, busB;
  
  reg [31:0] regs[31:0];
  integer i;
  
  assign busA = regs[ra];
  assign busB = regs[rb];
  
  always @(posedge clk or posedge rst)
  begin
    if (rst)
      begin
        for (i=0; i<32; i=i+1)
          regs[i] = 32'b0;
      end
      
    if (Reg_Wr && Reg_Dst != 2'b11) begin   // not overflow condition
      if (rw != 0)
        regs[rw] <= busW;
    end
    else if (Reg_Wr && Reg_Dst == 2'b11) begin  // overflow condition
      regs[5'b11110][0] = 1;
    end
  end

endmodule