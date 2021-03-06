module timer(clk, rst, addr, we, data_in, data_out, irq);
  input clk, rst, we;
  input [3:2] addr;
  input [31:0] data_in;
  
  output reg [31:0] data_out;
  output irq;
  
  // addr
  // 00 - ctrl
  // 01 - preset
  // 10 - count, count is read only, can not write
  reg [31:0] ctrl, preset, count;        
  
  assign irq = (count==0) && (ctrl[3] && (ctrl[2:1] == 2'b00) && ctrl[0]) ? 1 : 0;       // if irq and no intr shield
  
  always @(addr)
  begin
    case (addr)
      2'b00 : data_out = ctrl;
      2'b01 : data_out = preset;
      2'b10 : data_out = count;
    endcase
  end
  
  always @(posedge we)
  begin
    case (addr)
      2'b00 : ctrl <= data_in;
      2'b01 : begin preset <= data_in;
                    count <= data_in;
              end
    endcase
  end
  
  always @(posedge clk or posedge rst)
  begin
    if (rst)
      begin
        ctrl <= 0;
        preset <= 0;
        count <= 0;
      end
    if (ctrl[0]) begin
      if (count != 0) count <= count - 1;
      else if (ctrl[2:1] == 2'b01) count <= preset;
      else ctrl[0] <= 0;
    end
      
  end
  
endmodule