module counter(
  input             clk_i,
  input             arst_i,
  input      [9:0]  sw_i,     
  input      [1:0]  key_i,    //0- центр. кнопка, 1-кнопка вниз
    
  output     [9:0]  ledr_o,   
  output reg [6:0]  hex_o,    
  output reg [7:0]  hex_on    
);
  reg  [7:0] count;
  reg  [9:0] data;

  assign ledr_o = sw_i;
  
  
always @ ( posedge clk_i or posedge key_i[1]  ) begin
  if( arst_i )
    data <= 10'b0;
  else if( key_i[0])
    data <= sw_i;
    count <= count +1;
end

endmodule