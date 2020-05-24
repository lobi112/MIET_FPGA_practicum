`timescale 1ns / 1ps


module decoder(
  input       [3:0] counter_i,
  output reg  [3:0] hex_o
);
  
  always @( * ) begin
    case ( hex_o )      
      4'd0    : hex_o = 7'b100_0000;
      4'd1    : hex_o = 7'b111_1001;
      4'd2    : hex_o = 7'b010_0100;
      4'd3    : hex_o = 7'b011_0000;
      4'd4    : hex_o = 7'b001_1001;
      4'd5    : hex_o = 7'b001_0010;
      4'd6    : hex_o = 7'b000_0010;
      4'd7    : hex_o = 7'b111_1000;
      4'd8    : hex_o = 7'b000_0000;
      4'd9    : hex_o = 7'b001_0000;
      default : hex_o = 7'b111_1111;
    endcase    
  end
    
endmodule
