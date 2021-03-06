module alu(a, b, ALUCtr, result, zero, overflow, bltzal_sel);
  input [31:0] a, b;
  input [2:0] ALUCtr;
  output [31:0] result;
  output zero;
  output overflow;
  output bltzal_sel;
  
  wire [32:0] addR = {a[31], a} + {b[31], b};  // check addi overflow, 33 bits
  wire [31:0] subR = a - b;
  
  
  // 000 - addu / addiu / lw_addr / sw_addr / lb_addr / sb_addr
  // 001 - subu
  // 010 - ori
  // 011 - addi
  // 100 - slt
  // 101 - lui
  
  assign overflow = (addR[32] == addR[31]) ? 0 : 1;
  assign result = 
    (ALUCtr == 3'b000) ? addR[31:0]:
    (ALUCtr == 3'b001) ? subR:
    (ALUCtr == 3'b010) ? a | b:
    (ALUCtr == 3'b011 && overflow == 0) ? addR[31:0]:
    (ALUCtr == 3'b100) ? (subR[31] == 1)? 1:0:
    (ALUCtr == 3'b101) ? b : 0;
  assign zero = subR == 0 ? 1 : 0;
  assign bltzal_sel = a[31] == 1;
  
endmodule
