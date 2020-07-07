module ir(clk, ir_wr, ins_in, opcode, rs, rt, rd, funct, imm16, imm26);
  input clk, ir_wr;
  input [31:0] ins_in;
  
  output [4:0] rs, rt, rd;
  output [5:0] opcode, funct;
  output [15:0] imm16;
  output [25:0] imm26;
  
  reg [31:0] data32;
  
  assign rs = data32[25:21];
  assign rt = data32[20:16];
  assign rd = data32[15:11];
  assign opcode = data32[31:26];
  assign funct = data32[5:0];
  assign imm16 = data32[15:0];
  assign imm26 = data32[25:0];
  
  always @(clk)
  begin
    if (ir_wr)
      data32 <= ins_in;
    else
      data32 <= data32; 
  end
  
endmodule