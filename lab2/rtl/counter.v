`timescale 1ns / 1ps


module counter(
  input          clk100_i,
  input          rstn_i,
  input   [9:0]  sw_i,
  input   [1:0]  key_i,
  output  [9:0]  ledr_o,
  output  [6:0]  hex1_o,
  output  [6:0]  hex0_o
);
  reg  [6:0]  hex0;
  reg  [6:0]  hex1;
  
  reg  [9:0]  data;
  reg  [7:0]  count;
  reg  [2:0]  sync;
  wire        push_b0;
  wire        push_b1;
  
  assign ledr_o = data;
  assign hex0_o = hex0;
  assign hex1_o = hex1;
  
  always @( posedge clk100_i ) begin
    sync[0] <= !key_i[0];
    sync[1] <= sync[0];
    sync[2] <= sync[1];
  end
  
  assign push_b1 = key_i[1];
  assign push_b0 = ~sync[2] & sync[1];
  
  
  always @( posedge clk100_i or negedge push_b1 ) begin
    if( !push_b1 ) begin
      data  <=  10'b0;
      count <=  8'b0;
    end
    else if( push_b0 ) begin
      data  <=  sw_i;
      count <=  count + 1;
    end
  end
  
  always @ (*) begin
    case (count[3:0])
      4'h0:     hex0 = 7'b1000000;
	  4'h1:     hex0 = 7'b1111001;
	  4'h2:     hex0 = 7'b0100100;
	  4'h3:     hex0 = 7'b0110000;
	  4'h4:     hex0 = 7'b0011001;
	  4'h5:     hex0 = 7'b0010010;
	  4'h6:     hex0 = 7'b0000010;
	  4'h7:     hex0 = 7'b1111000;
	  4'h8:     hex0 = 7'b0000000;
	  4'h9:     hex0 = 7'b0010000;
	  4'ha:     hex0 = 7'b0001000;
	  4'hb:     hex0 = 7'b0000011;
	  4'hc:     hex0 = 7'b1000110;
	  4'hd:     hex0 = 7'b0100001;
	  4'he:     hex0 = 7'b0000110;
	  4'hf:     hex0 = 7'b0001110; 
	  default:  hex0 = 7'b1111111;
    endcase
  end

  always @ (*) begin
    case (count[7:4])
      4'h0:     hex1 = 7'b1000000;
	  4'h1:     hex1 = 7'b1111001;
	  4'h2:     hex1 = 7'b0100100;
	  4'h3:     hex1 = 7'b0110000;
	  4'h4:     hex1 = 7'b0011001;
	  4'h5:     hex1 = 7'b0010010;
	  4'h6:     hex1 = 7'b0000010;
	  4'h7:     hex1 = 7'b1111000;
	  4'h8:     hex1 = 7'b0000000;
	  4'h9:     hex1 = 7'b0010000;
	  4'ha:     hex1 = 7'b0001000;
	  4'hb:     hex1 = 7'b0000011;
	  4'hc:     hex1 = 7'b1000110;
	  4'hd:     hex1 = 7'b0100001;
	  4'he:     hex1 = 7'b0000110;
	  4'hf:     hex1 = 7'b0001110; 
	  default:  hex1 = 7'b1111111;
    endcase
  end

endmodule 