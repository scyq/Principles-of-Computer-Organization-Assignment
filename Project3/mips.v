module mips(clk, rst, pr_addr, pr_rd, wdin, wecpu, cp0_rd, cp0_addr, cp0_we, exlset, exlclr, pc_, epc, int_req_sel);
  input clk;
  input rst;
  input int_req_sel;
  input [31:0] pr_rd, epc, cp0_rd;
  output [31:0] wdin, pr_addr;
  output wecpu, cp0_we, exlset, exlclr;
  output [4:0] cp0_addr;
  output [31:0] pc_;
    
  wire [31:0] pc, npc, pc_4, instruction, busA, busB, busW, busA_reg, busB_reg, alu_b, alu_result, alu_out, dm_w, mem_out, dm_out, ext_out;
  wire [25:0] imm26;
  wire [15:0] imm16;
  wire [5:0] opcode, funct;
  wire [4:0] rs, rt, rd, rw;
  wire [2:0] npc_sel, ALUCtr; 
  wire [1:0] reg_dst, reg_from_sel, ext_op;
  wire pc_wr, ir_wr, gpr_wr, dm_wr, b_sel, word_byte_sel, zero, overflow;

  // dm_or_devin is judge lw for dev in
  // 0 - from dm
  // 1 - from dev_in
  wire dm_or_devin;
  wire dm_range;
  
  
  assign wdin = busB;
    
  assign dm_range = (alu_out[13:0] < 32'h0000_2fff) ? 1 : 0;
  assign dm_or_devin = (opcode == 6'b100011 && ~dm_range);
  
  // wecpu is cpu to dev_out, by store instruction
  assign wecpu = (dm_wr && ~dm_range);
  
  assign pr_addr = alu_out;
  
  assign cp0_addr = rd;
  
  assign pc_ = pc;
  
  controller path_ctr(clk, rst, opcode, funct, rs, zero, overflow, pc_wr, npc_sel, ir_wr, gpr_wr, dm_wr, ALUCtr, reg_dst, reg_from_sel, b_sel, ext_op, 
                      word_byte_sel, int_req_sel, exlset, exlclr, cp0_we);
  pc pc_path(clk, rst, npc, pc_wr, pc);
  im_1k im_path(pc[12:0], instruction);
  ir ir_path(clk, ir_wr, instruction, opcode, rs, rt, rd, funct, imm16, imm26);
  gpr gpr_path(clk, rst, rs, rt, rw, busA, busB, busW, gpr_wr, reg_dst);
  register_32 A_reg(clk, busA, busA_reg);
  register_32 B_reg(clk, busB, busB_reg);
  alu alu_path(busA_reg, alu_b, ALUCtr, alu_result, zero, overflow);
  register_32 alu_reg(clk, alu_result, alu_out);
  dm_1k dm_path(alu_out[13:0], dm_w, dm_wr, clk, mem_out);
  register_32 dm_reg(clk, mem_out, dm_out);
  npc npc_path(pc, imm26, imm16, zero, npc_sel, busA, epc, npc, pc_4);
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
  // 11 - mfc0, cp0
  assign busW = (reg_from_sel == 2'b00) ? alu_out:
                (reg_from_sel == 2'b01 && !word_byte_sel && !dm_or_devin) ? dm_out:
                (reg_from_sel == 2'b01 && !word_byte_sel && dm_or_devin) ? pr_rd:
                (reg_from_sel == 2'b01 && word_byte_sel) ? {{24{dm_out[7]}}, dm_out[7:0]}:
                (reg_from_sel == 2'b11) ? cp0_rd : pc; 
  
  // 0 - busB
  // 1 - imm16
  assign alu_b = b_sel ? ext_out: busB_reg;


endmodule
  
