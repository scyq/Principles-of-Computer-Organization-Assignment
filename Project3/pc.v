module pc(clk, rst, npc, pc_wr, pc);
  input clk, rst, pc_wr;      
  input [31:0] npc;
  output [31:0] pc;
  
  reg [31:0] pc_temp;     // pc_temp is a temporary register
  
  assign pc = pc_temp;    // pc is output port
  
  always @(posedge clk or posedge rst)
  begin
    if (rst)
      pc_temp = 32'h 0000_3000;
    else if (pc_wr)
      pc_temp = npc;
    else
      pc_temp = pc_temp;
  end

endmodule
  