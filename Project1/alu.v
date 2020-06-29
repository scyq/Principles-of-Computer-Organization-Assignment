module alu(a, b, aluCtr, result, zero, overflow);
  input [31:0] a, b;
  input [2:0] aluCtr;
  output [31:0] result;
  output zero;
  output overflow;
  
  wire [32:0] addR = a + b;  // check addi overflow, 33 bits
  wire [31:0] subR = a - b;
  
  // 000 - addu / addiu / lw_addr / sw_addr
  // 001 - subu
  // 010 - ori
  // 011 - addi
  // 100 - slt
  // 101 - lui
  
  assign overflow = (aluCtr == 3'b011) ? ((addR[32] == addR[31]) ? 0 : 1) : 0;
  assign result = 
    (aluCtr == 3'b000) ? addR[31:0]:
    (aluCtr == 3'b001) ? subR:
    (aluCtr == 3'b010) ? a | b:
    (aluCtr == 3'b011 && overflow == 0) ? addR[31:0]:
    (aluCtr == 3'b100) ? (subR[31] == 1)? 1:0:
    (aluCtr == 3'b101) ? b : 0;
  assign zero = subR == 0 ? 1 : 0;
  
endmodule