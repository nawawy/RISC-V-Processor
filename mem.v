module mem (
// mem module used to model inst and data memory in a single unit
    input [31:0] address, dataIn,
    input clk,
    input rst,
    input wEn,
    output [31:0] memout
);

reg [31 : 0] ram [31 : 0];

/*
//initial block to read instruction from memory
initial begin
    $readmemh("instr.dat", ram);
end
*/
//sequential logic to model writing to memory

always @(posedge clk)
    if (rst)
        //reset all values stored in memory?
        ram[1] <= {32{1'b0}};
    else 
        if (wEn)
            ram[address] <= dataIn;

//combinational logic to read from memory 
assign memout = ram[address];

endmodule