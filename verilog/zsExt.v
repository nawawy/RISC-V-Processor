// file: zsExt.v
// author: @omar_nawawy

`timescale 1ns/1ns

module zsExt(x, y, op);
	parameter size = 16;
	input [size - 1 : 0] x;
	input op;
	output [31 : 0]y;

	assign y = (op == 1) ? {{(32-size){x[size - 1]}}, x[size - 1 : 0]} : {{(32 -  size){1'b0}}, x};
endmodule