module npc(pc, imm, imm16, zero, npc_sel, gpr_in, npc, pc_4, bltzal_sel);
  input [31:0] pc;
  input [25:0] imm;
  input [15:0] imm16;
  input zero, bltzal_sel;
  
  // 00 - pc + 4
  // 01 - j / jal
  // 10 - jr
  // 11 - beq / bltzal
  input [1:0] npc_sel;
  
  // gpr_in is for jr
  input [31:0] gpr_in;
  output [31:0] npc, pc_4;
  
  assign pc_4 = pc + 4;
  
  assign npc = npc_sel == 2'b11 ? (zero || bltzal_sel) ? pc + {{14{imm16[15]}}, imm16, 2'b00}: pc_4:
         npc_sel == 2'b01 ? { pc[31:28], imm, 2'b00}:
         npc_sel == 2'b10 ? gpr_in :
         npc_sel == 2'b00 ? pc_4 : 32'h0000_3000;
         
endmodule
