`timescale 1ns / 1ps

module counter_tb(
    );
    localparam CLK_FREQ_MHZ = 50;
    localparam CLK_SEMIPERIOD = (1000/CLK_FREQ_MHZ)/2;
    
  reg          clk100_i;
  reg   [9:0]  sw_i;
  reg   [1:0]  key_i;
  wire  [9:0]  ledr_o;
  wire  [6:0]  hex0_o;
  wire  [6:0]  hex1_o;
  
  counter DUT (
    .clk100_i ( clk100_i ),
    .sw_i     ( sw_i     ),
    .key_i    ( key_i    ),
    .ledr_o   ( ledr_o   ),
    .hex0_o   ( hex0_o   ),
    .hex1_o   ( hex1_o   )
  );
  
  initial begin
    clk100_i = 1'b1;
    forever begin
      #CLK_SEMIPERIOD clk100_i = ~clk100_i;
    end
  end

  initial begin
    sw_i = 10'b0;
    repeat(40) 
    begin
      #(8*CLK_SEMIPERIOD);
      sw_i = $random();
    end
  end
  
  initial begin
    key_i [1] = 1'b0;
    #(2*CLK_SEMIPERIOD)
    key_i [1] = 1'b1;
    #(2*CLK_SEMIPERIOD)
    key_i [1] = 1'b0;
    forever begin
      #(22*CLK_SEMIPERIOD);
      key_i[1] = ~key_i[1];
      #(3*CLK_SEMIPERIOD)
      key_i[1] = ~key_i[1];
    end
  end
  
  initial begin
    key_i [0] = 1'b0;
    forever begin
      #(7*CLK_SEMIPERIOD);
      key_i[0] = ~key_i[0];
    end
  end
 
endmodule
