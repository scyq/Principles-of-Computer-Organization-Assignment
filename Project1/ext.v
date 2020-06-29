module ext(in, sign, out);
  input [15:0] in;
  input [1:0] sign;
  output [31:0] out;
  
  wire [31:0] zero_ext;
  wire [31:0] sign_ext;
  wire [31:0] lui_ext;
  
  parameter z = 16'b0;
  wire [15:0] s = {16{in[15]}};
  
  assign zero_ext = {z, in};
  assign sign_ext = {s, in};
  assign lui_ext = {in, z};
  
  // 00 - zero ext
  // 01 - sign ext
  // 10 - lui
  assign out = (sign == 2'b00) ? zero_ext:
         (sign == 2'b01) ? sign_ext:
         (sign == 2'b10) ? lui_ext : 0;
endmodule