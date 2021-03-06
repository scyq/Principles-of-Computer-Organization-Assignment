module test;
  reg clk, reset;
  mips test_mips(clk,reset);
  
  initial
  begin
    clk = 1;
    reset = 0;    
    #2 reset = 1;
    #2 reset = 0;  
    $readmemh("p2-modi.txt",test_mips.im_path.im);
  end 

  always
    #30 clk = ~clk;
    
endmodule