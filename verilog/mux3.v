// file: mux3.v
// author: @omar_nawawy

`timescale 1ns/1ns

module mux3(x0, x1, x2, y, sel);
	input [31 : 0]x0, x1, x2;
	input [1 : 0] sel;
	output reg [31 : 0]y;

	always @(*) begin
		case(sel)
		2'b00:
			y = x0;
		2'b01:
			y = x1;
		2'b10:
			y = x2;
		endcase
	end
endmodule