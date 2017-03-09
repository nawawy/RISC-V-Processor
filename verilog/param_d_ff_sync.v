// file: param_d_ff_async.v
// author: @kareefardi

`timescale 1ns/1ns

module param_d_ff_sync(d, clk, rst, q, en);
    parameter n = 2;
    input [n - 1 : 0] d;
	input clk;
	input rst;
    input en;
	output reg [n - 1 : 0] q;

	always @(posedge clk) begin
		if (rst) begin
            q <= {n{1'b0}};
		end
		else begin
            if (en)
                q  <= d;
            else
                q <= q;
		end
	end
endmodule