// file: memkkk_tb.v
// author: @kareefardi
// Testbench for memkkk

`timescale 1ns/1ns

module memkkk_tb;

	//Inputs
	reg [31: 0] address;
    reg [31 : 0] dataIn;
    reg clk;
    reg rst;
    reg wEn;

	//Outputs
    wire [31 : 0] memOut;

	//Instantiation of Unit Under Test
	memkkk uut (
		.address(address),
        .clk(clk),
        .dataIn(dataIn),
        .wEn(wEn),
        .rst(rst),
        .memOut(memOut)
	);
    ///////////////////////////////////////////////////////////////////////
    // the following iterates over the entire memory writes the address #
    // to the location pointed by that address then check if it is correct
    ///////////////////////////////////////////////////////////////////////
    integer i;
    reg flag;
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        dataIn = 0;
        address = 0;
        flag = 0;
        i = 0;
        @(posedge clk);
        wEn = 1;
        for (i = 0; i < 32; i = i + 1) begin
            @(negedge clk);
            dataIn = i;
            address = i;
        end
        @(negedge clk);
        wEn = 0;
        for (i = 0; i < 32; i = i + 1) begin
            @(posedge clk);
            address = i;
            @(negedge clk);
            if (memOut != i) begin
               $display("Error at address %d, found %d, expected %d");
               flag = 1;
            end
        end
        #10;
        if (flag == 0)
            $display("Memory Test passed");
    end
    // initial begin
    //     $monitor("memOut: %d", memOut);
    // end
endmodule