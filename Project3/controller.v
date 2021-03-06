module controller(clk , rst, opcode, funct, rs, zero, overflow, pc_wr, npc_sel, ir_wr, gpr_wr, dm_wr, ALUCtr, reg_dst, reg_from_sel, b_sel, 
                  ext_op, word_byte_sel, int_req, exlset, exlclr, cp0_we);
  input clk, rst, zero, overflow, int_req;
  input [5:0] opcode, funct;
  input [4:0] rs;
  output pc_wr, ir_wr, gpr_wr, dm_wr, b_sel, word_byte_sel;
  output [1:0] reg_dst, ext_op, reg_from_sel;
  output [2:0] npc_sel, ALUCtr;
  output exlset, exlclr, cp0_we;
  
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
  wire eret = (opcode == 6'b010000 && funct == 6'b011000);
  wire mfc0 = (opcode == 6'b010000 && rs == 5'b0);
  wire mtc0 = (opcode == 6'b010000 && rs == 5'b00100);
  
  /*
  fsm
  s0: fetch the instruction
  s1: decode
  s2: ALU calculate addr lw || sw || lb || sb
  s3: read from dm
  s4: write back from dm
  s5: write into dm
  s6: ALU calculate numbers addu || addiu || addi || subu || ori || lui
  s7: write back from ALU
  s8: calculate beq addr
  s9: calculate j addr
  s10: interrupt
  s11: mfc0 write back
  s12: mtc0 execute
  
  lw || lb : s0 -> s1 -> s2 -> s3 -> s4
  
  sw || sb : s0 -> s1 -> s2 -> s5
  
  addx || subu || ori || lui || slt : s0 -> s1 -> s6 -> s7
  
  beq : s0 -> s1 -> s8
  
  j || jal || jr || eret : s0 -> s1 -> s9
  
  mfc0 : s0 -> s1 -> s11
  
  mtc0 : s0 -> s1 -> s12
  
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
  parameter s10 = 4'b1010;
  parameter s11 = 4'b1011;
  parameter s12 = 4'b1100;
  
  assign cp0_we = (current_state == s12 && mtc0) || (current_state == s10);
  assign exlclr = ((current_state == s9) & eret) ? 1 : 0;
  assign exlset = (current_state == s10);
  
  assign pc_wr = (current_state == s0) ? 1: 
                 (current_state == s8) ? beq && zero:
                 (current_state == s9) ? ( j || jr || jal || eret):
                 (current_state == s10) ? 1 : 0;
                 
  // 000 - pc + 4
  // 001 - j / jal
  // 010 - jr
  // 011 - beq
  // 100 - eret
  // 101 - interrupt
  assign npc_sel = (current_state == s1 && beq) ? 3'b011:
                   (current_state == s8 && beq) ? 3'b011:
                   (current_state == s1 && (j || jal)) ? 3'b001:
                   (current_state == s9 && (j || jal)) ? 3'b001:
                   (current_state == s1 && jr) ? 3'b010:
                   (current_state == s9 && jr) ? 3'b010:
                   (current_state == s9 && eret) ? 3'b100:
                   (current_state == s10) ? 3'b101 : 3'b000;
                   
  assign ir_wr = current_state == s0 ? 1 : 0;
  
  assign gpr_wr = (current_state == s4) ? 1:
                  (current_state == s7) ? 1:
                  (current_state == s9) ? jal:
                  (current_state == s11)? mfc0 : 0;
  
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
                    (current_state == s11 && mfc0) ? 2'b00:
                    (current_state == s7 && addi && overflow) ? 2'b11 : 2'b00;
                    
  // 00 - from alu
  // 01 - from mem
  // 10 - pc_4 
  // 11 - cp0
  assign reg_from_sel = (current_state == s4 && (lw || lb)) ? 2'b01:
                        (current_state == s9 && jal) ? 2'b10 : 
                        (current_state == s11 && mfc0) ? 2'b11 : 2'b00;
  
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
        s1: case ({ mtc0, mfc0,(j || jal || jr || eret), beq, (addu || addi || addiu || subu || ori || lui || slt), (lw || sw || lb || sb)})
            6'b000001 : next_state = s2;
            6'b000010 : next_state = s6;
            6'b000100 : next_state = s8;
            6'b001000 : next_state = s9;
            6'b010000 : next_state = s11;
            6'b100000 : next_state = s12;
            default: next_state = s0;
          endcase
        s2: case ({(lw || lb), (sw || sb)})
            2'b01 : next_state = s5;
            2'b10 : next_state = s3;
            default: next_state = s0;
          endcase
        s3: next_state = (lw || lb) ? s4 : s0;
        s4: begin 
              if (int_req) next_state = s10;
              else next_state = s0; 
            end
        s5: begin 
              if (int_req) next_state = s10;
              else next_state = s0;
            end
        s6: next_state = (addu || addi || addiu || subu || ori || lui || slt) ? s7 : s0;
        s7: begin 
              if (int_req) next_state = s10;
              else next_state = s0;
            end
        s8: begin 
              if (int_req) next_state = s10;
              else next_state = s0;
            end
        s9: begin 
              if (int_req) next_state = s10;
              else next_state = s0;
            end
        s10: next_state = s0;
        s11: begin 
              if (int_req) next_state = s10;
              else next_state = s0;
             end
        s12: begin 
              if (int_req) next_state = s10;
              else next_state = s0;
             end
      endcase
                
  end    
  
endmodule
  
  
  
  
  
