`timescale 1ns/1ns
`include "assignxtest.v"

module test_tb;
    reg x;
    reg clk;
    wire [3 : 0] y;

    test uut(
        .x  (x),
        .clk(clk),
        .y  (y)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        x = 0;
        #10;
        $monitor("%d", y);
    end
endmodule