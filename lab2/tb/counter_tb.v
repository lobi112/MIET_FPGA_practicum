`timescale 1ns / 1ps

module counter_tb(
    );
    
  localparam CLK_FREQ_MHG   = 50;
  localparam CLK_SEMIPERIOD = (1000 / CLK_FREQ_MHG) / 2;
  
  localparam RST_ON  = 1'b1;
  localparam RST_OFF = 1'b0;


  wire  [9:0]  data  = 10'b0;
  wire  [7:0]  count = 8'b0;
  reg  [9:0]  sw_i    = 10'b0;
  reg         clk_i;
  wire [1:0]  key_i;

  
  assign key_i [1] = 0;
  assign key_i [0] = 0;
   
counter DUT
(  
  .clk_i  ( clk_i ),
  .sw_i   ( sw_i ),
  .data   ( data ),
  .count  ( count ),
  .key_i  ( key_i )    
 );
 
   //CLock gen
   initial begin
     clk_i = 1'b1;
     forever begin
       #CLK_SEMIPERIOD clk_i = ~clk_i;
     end
   end
  
   //RST gen
   initial begin
     key_i[0] = 1'b0;
     key_i[1] = 1'b1;
     key_i[1] = RST_OFF;
     #(6*CLK_SEMIPERIOD);
     key_i[0] = RST_ON;
     #(30*CLK_SEMIPERIOD);
     key_i[1] = RST_OFF;
     #(30*CLK_SEMIPERIOD);
     key_i[0] = RST_ON;
   end
   
   //Sugnale gen
   initial begin
     forever begin
       #(4*CLK_SEMIPERIOD) sw_i = $random();
     end
     forever begin
       #(5*CLK_SEMIPERIOD) key_i[0] = ~key_i[0];
     end
   end
   
endmodule
