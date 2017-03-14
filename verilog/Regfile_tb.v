// file: Regfile_tb.v
// author: @amrheshamgalal
// Testbench for Regfile

`timescale 1ns/1ns

module Regfile_tb;

	//Inputs
	reg [31: 0] register;
	reg [31: 0] writeData;
	reg writeEnable;
	reg clk;
	reg rst;


	//Outputs
	wire [31: 0] readData;


	//Instantiation of Unit Under Test
	Regfile uut (
		.register(register),
		.writeData(writeData),
		.writeEnable(writeEnable),
		.clk(clk),
		.rst(rst),
		.readData(readData)
	);


		initial begin
	//Inputs initialization
		register = 0;
		writeData = 0;
		writeEnable = 0;
		clk = 0;
		rst = 1;


	//Wait for the reset
		#40
		rst = 0;
		#40
		writeEnable = 1;
		register = 12;
		writeData = 6;
		#40 //time 120
		register = 10;
		writeData = 5;
		#21 //time 141
		writeEnable = 0;
		
		#10 //time 151
		register = 12;
		 
		#1 //time 152
		if(readData == 6)$display("Read and written from register 12 successfully");
		#50
		register = 10;
		#1 
		if(readData == 5)$display("Read and written from register 10 successfully");

	end
    always #20 clk = !clk;
endmodule