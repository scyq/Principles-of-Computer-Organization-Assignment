module mips(clk, rst);
  input           clk ;   // clock
  input           rst ;   // reset

  wire [31:0] npc, pc, pc_4;
  wire [31:0] instruction;
  wire ALUSrc, MemWr, RegWr;
  wire [1:0] RegDst, nPC_sel, ExtOp, MemToReg;
  wire [2:0] ALUCtr;
  wire [31:0] busA, gpr_busB, busW, alu_busB;
  wire [4:0] rW;
  wire [31:0] aluOut;
  wire zero, overflow;
  wire [31:0] memOut;
  wire [31:0] extOut;
  
  pc path_pc (clk, rst, npc, pc);
  im_1k path_im (pc[9:0], instruction);
  controller path_ctr (clk, rst, instruction[31:26], instruction[5:0], RegDst, ALUSrc, MemToReg, MemWr, RegWr, nPC_sel, ExtOp, ALUCtr, overflow);
  gpr path_gpr (instruction[25:21], instruction[20:16], busA, gpr_busB, rW, busW, RegWr, clk, rst, RegDst);
  alu path_alu (busA, alu_busB, ALUCtr, aluOut, zero, overflow);
  dm_1k path_dm (aluOut[9:0], gpr_busB, MemWr, clk, memOut);
  npc path_npc (pc, instruction[25:0], instruction[15:0], zero, nPC_sel, busA, npc, pc_4);
  ext path_ext (instruction[15:0], ExtOp, extOut);
  
  // 0 - busB
  // 1 - imm16
  assign alu_busB = ALUSrc ? extOut: gpr_busB;
  
  // 00 - rt
  // 01 - rd
  // 10 - $31
  // 11 - overflow
  assign rW = (RegDst == 2'b00) ? instruction[20:16]:
              (RegDst == 2'b01) ? instruction[15:11]: 
              (RegDst == 2'b10) ? 5'b11111 : 5'b11110;
              
  // 00 - from alu
  // 01 - from mem
  // 10 - pc_4
  assign busW = (MemToReg == 2'b00) ? aluOut:
                (MemToReg == 2'b01) ? memOut : pc_4; 
    
  
  
  
endmodule