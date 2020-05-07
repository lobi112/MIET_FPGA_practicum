`timescale 1ns / 1ps

module register 
(
  input           clk_i,
  input           arst_i,
  input           buttom_i,
  input  [ 9:0 ] data_i,
  output [ 9:0 ] data_out
);

reg [9:0] data;

always @( posedge clk_i or posedge arst_i) begin
  if( arst_i )
  data <=   10'b0;
  else if( buttom_i) data <= data_i;
end

assign data_out = data;

endmodule