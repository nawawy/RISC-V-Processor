// file: mux2.v
// author: @omar_nawawy

`timescale 1ns/1ns

module mux2(x0, x1, y, sel);
	input [31 : 0]x0, x1;
	input  sel;
	output reg [31 : 0]y;

	always @(*) begin
		case(sel)
		1'b0:
			y = x0;
		1'b1:
			y = x1;
		endcase
	end
endmodule