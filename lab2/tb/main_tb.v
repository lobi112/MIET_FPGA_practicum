`timescale 1ns / 1ps

module lab2_tb(
    );
    
localparam CLK_FREQ_MHZ = 50;
localparam CLK_SEMIPERIOD = 1000 / CLK_FREQ_MHZ /2;
    
reg         clk;
reg  [9:0]  data_i;
reg  [1:0]  key;
wire [9:0]  ledr;
wire [7:0]  hex; 

main DUT(
  .clk_i ( clk ),
  .key_i ( key ),
  .sw_i   ( data_i ),
  .ledr_o ( ledr ),
  .hex_on ( hex )
);

//Clock gen
initial begin
  clk = 1'b1;
  forever begin
    #CLK_SEMIPERIOD clk = ~clk;
    end
end
    

 
  //Signals gen
  initial begin
    forever begin
      #(2*CLK_SEMIPERIOD);
      data_i = $random();
      end
end

//Key gen
initial begin
key[1] = 1'b1;
#(30*CLK_SEMIPERIOD);
key[1] = ~key[1];
#(30*CLK_SEMIPERIOD);
key[1] = ~key[1];
#(30*CLK_SEMIPERIOD);
key[1] = ~key[1];



end
endmodule
