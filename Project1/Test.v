module Test;
  reg clk, reset;
  mips test_mips(clk,reset);
  
  initial
  begin
    clk = 1;
    reset = 0;    
    #5 reset = 1;
    #5 reset = 0;  
    $readmemh("code.txt",test_mips.path_im.im);
  end 

  always
    #30 clk = ~clk;
    
endmodule