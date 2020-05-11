`timescale 1ns / 1ps


module tb_counter(
    );
    
localparam CLK_FREQ = 50;
localparam CLK_SEMIPERIOD = 1000 / CLK_FREQ /2;
    
reg         clk100_i;
reg  [9:0]  sw_i;
wire [1:0]  key;
wire [9:0]  ledr_o;
wire [7:0]  hex; 

main DUT(
  .clk100_i ( clk100_i ),
  .key_i    ( key ),
  .sw_i     ( sw_i ),
  .ledr_o   ( ledr_o ),
  .hex_on   ( hex )
);

//Clock gen
initial begin
  clk100_i = 1'b1;
  forever begin
    #CLK_SEMIPERIOD clk100_i = ~clk100_i;
  end
end
    

 
initial begin
  forever begin
    #(4*CLK_SEMIPERIOD);
    sw_i = $random();
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
