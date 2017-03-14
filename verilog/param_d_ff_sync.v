// file: param_d_ff_sync.v
// author: @kareefardi

`timescale 1ns/1ns

module param_d_ff_sync(d, clk, rst, q, en);
    ////////////////////////////////////////////////////////
    // the following module is used to model sync n-flipflop
    // to be used for buffers
    ////////////////////////////////////////////////////////
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
		end
	end
endmodule