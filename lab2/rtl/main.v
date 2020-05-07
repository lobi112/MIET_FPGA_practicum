`timescale 1ns / 1ps

module main(
  input [9:0] sw_i,
  input [1:0] key_i,
  input       clk_i,
  
  output [9:0] ledr_o,
  output reg [7:0] hex_on
);
wire [7:0] count;
wire [9:0] data;

assign ledr_o = data; 

counter U1(
  .clk_i       ( clk_i ),
  .en_i        ( key_i[0] ),
  .arst_i      ( key_i[1] ),
  .data_out    ( count )
);

register U2(
  .clk_i       ( clk_i ),
  .en_i        ( key_i[0] ),
  .arst_i      ( key_i[1] ),
  .data_i      ( sw_i[9:0] ),
  .data_out    ( data )
);

always @(posedge clk_i) begin
    hex_on <= 8'b1111_1110;
  case (count)
    4'h0 : hex_on = 7'b100_0000;
    4'h1 : hex_on = 7'b111_1001;
    4'h2 : hex_on = 7'b010_0100;
    4'h3 : hex_on = 7'b011_0000;
    4'h4 : hex_on = 7'b001_1001;
    4'h5 : hex_on = 7'b001_0010;
    4'h6 : hex_on = 7'b000_0010;
    4'h7 : hex_on = 7'b111_1000;
    4'h8 : hex_on = 7'b000_0000;
    4'h9 : hex_on = 7'b001_0000;
    4'ha : hex_on = 7'b000_1000;
    4'hb : hex_on = 7'b000_0011;
    4'hc : hex_on = 7'b100_0110;
    4'hd : hex_on = 7'b010_0001;
    4'he : hex_on = 7'b000_0110;
    4'hf : hex_on = 7'b000_1110;
  endcase
end

always @(negedge clk_i) begin
    hex_on <= 8'b1111_1101;
  case (count)
    4'h0 : hex_on = 7'b100_0000;
    4'h1 : hex_on = 7'b111_1001;
    4'h2 : hex_on = 7'b010_0100;
    4'h3 : hex_on = 7'b011_0000;
    4'h4 : hex_on = 7'b001_1001;
    4'h5 : hex_on = 7'b001_0010;
    4'h6 : hex_on = 7'b000_0010;
    4'h7 : hex_on = 7'b111_1000;
    4'h8 : hex_on = 7'b000_0000;
    4'h9 : hex_on = 7'b001_0000;
    4'ha : hex_on = 7'b000_1000;
    4'hb : hex_on = 7'b000_0011;
    4'hc : hex_on = 7'b100_0110;
    4'hd : hex_on = 7'b010_0001;
    4'he : hex_on = 7'b000_0110;
    4'hf : hex_on = 7'b000_1110;
  endcase
end

endmodule
