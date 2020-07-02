module controller(clk , rst, opcode, funct, zero, overflow, pc_wr, npc_sel, ir_wr, gpr_wr, dm_wr, ALUCtr, reg_dst, reg_from_sel, b_sel, ext_op, word_byte_sel);
  input clk, rst, zero, overflow;
  input [5:0] opcode, funct;
  output pc_wr, ir_wr, gpr_wr, dm_wr, b_sel, word_byte_sel;
  output [1:0] npc_sel, reg_dst, ext_op, reg_from_sel;
  output [2:0] ALUCtr;
  
  reg [3:0] fsm, current_state, next_state;
  
  wire addi = opcode == 6'b001000;
  wire addiu = opcode == 6'b001001;
  wire slt = (opcode == 6'b0 && funct == 6'b101010);
  wire jal = opcode == 6'b000011;
  wire jr = (opcode == 6'b0 && funct == 6'b001000);
  wire addu = (opcode == 6'b0 && funct == 6'b100001);
  wire subu = (opcode == 6'b0 && funct == 6'b100011);
  wire ori = opcode == 6'b001101;
  wire lw = opcode == 6'b100011;
  wire sw = opcode == 6'b101011;
  wire beq = opcode == 6'b000100;
  wire lui = opcode == 6'b001111;
  wire j = opcode == 6'b000010;
  wire sb = opcode == 6'b101000;
  wire lb = opcode == 6'b100000;
  
  /*
  fsm
  s0: ??
  s1: ??
  s2: ALU???? lw || sw || lb || sb
  s3: ?DM??
  s4: ?DM???
  s5: ??DM
  s6: ALU???? addu || addiu || addi || subu || ori || lui
  s7: ?ALU??? 
  s8: ??BEQ?????
  s9: ??J?????
  
  lw || lb : s0 -> s1 -> s2 -> s3 -> s4
  
  sw || sb : s0 -> s1 -> s2 -> s5
  
  addx || subu || ori || lui || slt : s0 -> s1 -> s6 -> s7
  
  beq : s0 -> s1 -> s8
  
  j || jal || j : s0 -> s1 -> s9
  
  */  
  
  parameter s0 = 4'b0000;
  parameter s1 = 4'b0001;
  parameter s2 = 4'b0010;
  parameter s3 = 4'b0011;
  parameter s4 = 4'b0100;
  parameter s5 = 4'b0101;
  parameter s6 = 4'b0110;
  parameter s7 = 4'b0111;
  parameter s8 = 4'b1000;
  parameter s9 = 4'b1001;
  
  assign pc_wr = (current_state == s0) ? 1: 
                 (current_state == s8) ? beq && zero:
                 (current_state == s9) ? ( j || jr || jal) : 0;
                 
  // 00 - pc + 4
  // 01 - j / jal
  // 10 - jr
  // 11 - beq
  assign npc_sel = (current_state == s1 && beq) ? 2'b11:
                   (current_state == s8 && beq) ? 2'b11:
                   (current_state == s1 && (j || jal)) ? 2'b01:
                   (current_state == s9 && (j || jal)) ? 2'b01:
                   (current_state == s1 && jr) ? 2'b10:
                   (current_state == s9 && jr) ? 2'b10: 2'b00;
                   
  assign ir_wr = current_state == s0 ? 1 : 0;
  
  assign gpr_wr = (current_state == s4) ? 1:
                  (current_state == s7) ? 1:
                  (current_state == s9) ? jal : 0;
  
  assign dm_wr = current_state == s5 ? 1 : 0;
  
  // 000 - addu / addiu / lw_addr / sw_addr / lb_addr / sb_addr
  // 001 - subu
  // 010 - ori
  // 011 - addi
  // 100 - slt
  // 101 - lui
  assign ALUCtr = (current_state == s2 && (lw || sw || lb || sb)) ? 3'b000:
                  (current_state == s6 && (addu || addiu)) ? 3'b000:
                  (current_state == s6 && subu) ? 3'b001:
                  (current_state == s6 && ori) ? 3'b010:
                  (current_state == s6 && addi) ? 3'b011:
                  (current_state == s6 && slt) ? 3'b100:
                  (current_state == s6 && lui) ? 3'b101 : 3'b000;
  
  // 00 - rt
  // 01 - rd
  // 10 - $31
  // 11 - overflow $30
  assign reg_dst =  ((current_state == s1 || current_state == s2 || current_state == s7) && (addu || subu || slt)) ? 2'b01:
                    (current_state == s9 && jal) ? 2'b10:
                    (current_state == s7 && addi && overflow) ? 2'b11: 2'b00;
                    
  // 00 - from alu
  // 01 - from mem
  // 10 - pc_4 
  assign reg_from_sel = (current_state == s4 && (lw || lb)) ? 2'b01:
                        (current_state == s9 && jal) ? 2'b10 : 2'b00;
  
  // 0 - gpr_busB
  // 1 - imm16                      
  assign b_sel = addi || addiu || lw || sw || lui || ori || lb || sb;
  
  // 00 - zero ext
  // 01 - sign ext
  // 10 - lui
  assign ext_op = ori ? 2'b00:
                  (addi || addiu || beq || lw || sw) ? 2'b01:
                  lui ? 2'b10 : 2'b00;
  
  // 0 - word
  // 1 - byte                
  assign word_byte_sel = (current_state == s4 && lb) || (current_state == s5 && sb);
  
  always @(posedge clk or posedge rst)
  begin
    if (rst)
      current_state <= s0;
    else
      current_state <= next_state;
  end
  
  always @(*)
  begin
    if (rst)
      next_state = s0;
    else
      case (current_state)
        s0: next_state = s1;
        s1: case ({(j || jal || jr), beq, (addu || addi || addiu || subu || ori || lui || slt), (lw || sw || lb || sb)})
            4'b0001 : next_state = s2;
            4'b0010 : next_state = s6;
            4'b0100 : next_state = s8;
            4'b1000 : next_state = s9;
            default: next_state = s0;
          endcase
        s2: case ({(lw || lb), (sw || sb)})
            2'b01 : next_state = s5;
            2'b10 : next_state = s3;
            default: next_state = s0;
          endcase
        s3: next_state = (lw || lb) ? s4 : s0;
        s4: next_state = s0;
        s5: next_state = s0;
        s6: next_state = (addu || addi || addiu || subu || ori || lui || slt) ? s7 : s0;
        s7: next_state = s0;
        s8: next_state = s0;
        s9: next_state = s0;
      endcase
                
  end    
  
endmodule
  
  
  
  
  