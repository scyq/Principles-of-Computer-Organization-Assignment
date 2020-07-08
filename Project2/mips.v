module mips(clk, rst);
  input clk;
  input rst;
  
  
  wire [31:0] pc, npc, pc_4, instruction, busA, busB, busW, busA_reg, busB_reg, alu_b, alu_result, alu_out, dm_w, mem_out, dm_out, ext_out;
  wire [25:0] imm26;
  wire [15:0] imm16;
  wire [5:0] opcode, funct;
  wire [4:0] rs, rt, rd, rw;
  wire [2:0] ALUCtr;
  wire [1:0] npc_sel, reg_dst, reg_from_sel, ext_op;
  wire pc_wr, ir_wr, gpr_wr, dm_wr, b_sel, word_byte_sel, zero, overflow;
  wire bltzal_sel;
  
  controller path_ctr(clk, rst, opcode, funct, zero, overflow, pc_wr, npc_sel, ir_wr, gpr_wr, dm_wr, ALUCtr, reg_dst, reg_from_sel, b_sel, ext_op, word_byte_sel, bltzal_sel);
  pc pc_path(clk, rst, npc, pc_wr, pc);
  im_1k im_path(pc[9:0], instruction);
  ir ir_path(clk, ir_wr, instruction, opcode, rs, rt, rd, funct, imm16, imm26);
  gpr gpr_path(clk, rst, rs, rt, rw, busA, busB, busW, gpr_wr, reg_dst);
  register_32 A_reg(clk, busA, busA_reg);
  register_32 B_reg(clk, busB, busB_reg);
  alu alu_path(busA_reg, alu_b, ALUCtr, alu_result, zero, overflow, bltzal_sel);
  register_32 alu_reg(clk, alu_result, alu_out);
  dm_1k dm_path(alu_out[9:0], dm_w, dm_wr, clk, mem_out);
  register_32 dm_reg(clk, mem_out, dm_out);
  npc npc_path(pc, imm26, imm16, zero, npc_sel, busA, npc, pc_4, bltzal_sel);
  ext ext_path(imm16, ext_op, ext_out);
  
  // for sb
  assign dm_w = word_byte_sel ? {mem_out[31:8], busB_reg[7:0]} : busB_reg;
  
  // 00 - rt
  // 01 - rd
  // 10 - $31
  // 11 - overflow
  assign rw = (reg_dst == 2'b00) ? rt:
              (reg_dst == 2'b01) ? rd: 
              (reg_dst == 2'b10) ? 5'b11111 : 5'b11110;
              
              
  // 00 - from alu
  // 01 - from mem
  // 10 - pc_4
  assign busW = (reg_from_sel == 2'b00) ? alu_out:
                (reg_from_sel == 2'b01 && !word_byte_sel) ? dm_out:
                (reg_from_sel == 2'b01 && word_byte_sel) ? {{24{dm_out[7]}}, dm_out[7:0]}: pc; 
  
  // 0 - busB
  // 1 - imm16
  assign alu_b = b_sel ? ext_out: busB_reg;
endmodule
  
