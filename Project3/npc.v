module npc(pc, imm, imm16, zero, npc_sel, gpr_in, eret_addr, npc, pc_4);
  input [31:0] pc;
  input [25:0] imm;
  input [15:0] imm16;
  input zero;
  
  // 000 - pc + 4
  // 001 - j / jal
  // 010 - jr
  // 011 - beq
  // 100 - eret
  // 101 - interrupt
  input [2:0] npc_sel;
  
  // gpr_in is for jr or eret
  input [31:0] gpr_in;
  
  input [31:0] eret_addr;
  
  output [31:0] npc, pc_4;
  
  assign pc_4 = pc + 4;
  
  assign npc = npc_sel == 3'b000 ? pc_4 :
        (npc_sel == 3'b011 && zero) ? pc + {{14{imm16[15]}}, imm16, 2'b00}:
         npc_sel == 3'b001 ? { pc[31:28], imm, 2'b00}:
         npc_sel == 3'b010 ? gpr_in :
         npc_sel == 3'b100 ? eret_addr:
         npc_sel == 3'b101 ? 32'h0000_4180: 32'h0000_3000;
         
endmodule
