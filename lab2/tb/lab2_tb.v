`timescale 1ns / 1ps

module main_tb(
    );
    
localparam CLK_FREQ = 50;
localparam CLK_SEMIPERIOD = 1000 / CLK_FREQ /2;
    
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
    

 
initial begin
  forever begin
    #(4*CLK_SEMIPERIOD);
    data_i = $random();
  end
end

initial begin
   key[0] = 1'b1;
   forever begin
    #(5*CLK_SEMIPERIOD);
    key[0] = ~key[0];
  end
end

initial begin
key[1] = 1'b1;
#(10*CLK_SEMIPERIOD);
key[1] = ~key[1];
#(10*CLK_SEMIPERIOD);
key[1] = ~key[1];
#(10*CLK_SEMIPERIOD);
key[1] = ~key[1];



end
endmodule
