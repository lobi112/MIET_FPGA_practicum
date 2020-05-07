`timescale 1ns / 1ps

module counter
(
  input        clk_i,       
  input        buttom_i,        
  input        arst_i,
  output [7:0] data_out  
);

reg [7:0] data;

always @(posedge clk_i or negedge arst_i) begin
  if (arst_i) 
    data <= 10'b0;
  else if (buttom_i && 1) 
    data <= data + 1;
end

assign data_out = data;

endmodule

