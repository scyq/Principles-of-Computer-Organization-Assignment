module controller (clk, rst, op, fun, RegDst, ALUSrc, MemToReg, MemWr, RegWr, nPC_sel, ExtOp, ALUCtr, overflow);
  input clk, rst;
  input [5:0] op, fun;
  output ALUSrc, MemWr, RegWr, overflow;
  output [2:0] ALUCtr;
  output [1:0] RegDst, ExtOp, MemToReg;
  output [1:0] nPC_sel;
  
  
  wire addi = op == 6'b001000;
  wire addiu = op == 6'b001001;
  wire slt = (op == 6'b0 && fun == 6'b101010);
  wire jal = op == 6'b000011;
  wire jr = (op == 6'b0 && fun == 6'b001000);
  wire addu = (op == 6'b0 && fun == 6'b100001);
  wire subu = (op == 6'b0 && fun == 6'b100011);
  wire ori = op == 6'b001101;
  wire lw = op == 6'b100011;
  wire sw = op == 6'b101011;
  wire beq = op == 6'b000100;
  wire lui = op == 6'b001111;
  wire j = op == 6'b000010;
  
  // 00 - rt
  // 01 - rd
  // 10 - $31
  // 11 - overflow $30
  assign RegDst = (addu || subu || slt) ? 2'b01:
                  jal ? 2'b10 : 
                  overflow ? 2'b11 : 2'b00;
  
  // 0 - gpr_busB
  // 1 - imm16
  assign ALUSrc = addi || addiu || lw || sw || lui || ori;
  
  // 00 - pc + 4
  // 01 - j / jal
  // 10 - jr
  // 11 - beq
  assign nPC_sel = beq ? 2'b11:
                   (j || jal) ? 2'b01:
                   jr ? 2'b10 : 2'b00;
  
  // 000 - addu / addiu / lw_addr / sw_addr
  // 001 - subu
  // 010 - ori
  // 011 - addi
  // 100 - slt
  // 101 - lui  
  assign ALUCtr = (addu || addiu || lw || sw) ? 3'b000:
                  subu ? 3'b001:
                  ori ? 3'b010:
                  addi ? 3'b011:
                  slt ? 3'b100:
                  lui ? 3'b101 : 3'b000;
  
  // 00 - from alu
  // 01 - from mem
  // 10 - pc_4
  assign MemToReg = lw ? 2'b01:
                    jal ? 2'b10 : 2'b00;
  assign MemWr = sw;
  
  // 00 - zero ext
  // 01 - sign ext
  // 10 - lui
  assign ExtOp = ori ? 2'b00:
                 (addi || addiu || beq || lw || sw) ? 2'b01:
                 lui ? 2'b10 : 2'b00;
  
  assign RegWr = addu || addi || addiu || subu || ori || lw || lui || slt || jal;
  
  
endmodule
  
  
  
  
  
