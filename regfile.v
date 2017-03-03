    // file: Regfile.v
    // author: @amrheshamgalal
    
    `timescale 1ns/1ns
    
    module Regfile(clk,rst,register,writeEnable,writeData,readData); //single port registerfile module
    input [31:0] register,writeData;
    input writeEnable,clk,rst;
    output reg [31:0] readData; 
    
    reg [31:0] regMemory [31:0];                 //32 32-bit register memory
    
    
    always @(*)                                 //combinational logic to read registers
        if(register == {32{1'b0}})
            readData =  {32{1'b0}};
        else
            readData = regMemory[register];
        
    always@(posedge clk)            //sequential logic to write in registers
    
        if(!rst)
        
            if(writeEnable)                         //if we are writing
                    if(register != {32{1'b0}})
                        regMemory[register] <= writeData;
                    else
                        regMemory[register] <= {32{1'b0}};
            else
                regMemory[0] <= {32{1'b0}};
        else
            readData <= {32{1'b0}};

    endmodule
