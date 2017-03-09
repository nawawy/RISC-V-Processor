module mem (
// mem module used to model inst and data memory in a single unit
    input [31:0] address, dataIn,
    input clk,
    input rst,
    input wEn,
    output reg [31:0] memOut
);

reg [31 : 0] ram [31 : 0];
integer i;

//sequential logic to model writing to memory
always @(posedge clk)
        if (wEn)
            ram[address] <= dataIn;
            
//combinational logic to read from memory 
always @(*)
    memOut = ram[address];
endmodule