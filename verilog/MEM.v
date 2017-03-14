// file: MEM.v
// author: @kareefardi

`timescale 1ns/1ns

module MEM (
// mem module used to model inst and data memory in a single unit
    input [31:0] address, dataIn,
    input clk,
    input rst,
    input wEn,
    output [31:0] memOut
);

reg [31 : 0] ram [31 : 0];
integer i;

initial begin
    ram[0] = 32'b00000000001000000000010100010011; // addi a0, zero, 2
    ram[1] = 32'h00150593; //93 05 15 00
    // ram[2] = 32'h00B50633; //33 06 B5 00 
  //  $monitor("mmmmmmm %d", ram[0]);
end
//sequential logic to model writing to memory
always @(posedge clk)
        if (wEn)
            ram[address] <= dataIn;
            
//combinational logic to read from memory
assign memOut = ram[address];

endmodule