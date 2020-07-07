module test;
  reg clk, reset;
  reg[31:0] in;
  machine winwinwin(clk ,reset, in);
  
  initial
  begin
    in = 32'h5;
    clk = 1;
    reset = 0;    
    #2 reset = 1;
    #2 reset = 0;  
    $readmemh("main.txt",winwinwin.cpu_.im_path.im, 'h1000);
    $readmemh("subr.txt",winwinwin.cpu_.im_path.im, 'h0180);
    
    
    #12000 in=32'h66;
  end 

  always
    #30 clk = ~clk;
    
endmodule