module register_32(clk, data_in, data_out);
  input clk;
  input [31:0] data_in;
  output [31:0] data_out;
  
  reg [31:0] temp_reg;
  
  assign data_out = temp_reg;
  
  always @ (posedge clk)
  begin
    temp_reg <= data_in;
  end

endmodule