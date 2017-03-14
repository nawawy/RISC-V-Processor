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
                begin
                regMemory[0] <= {32{1'b0}};       //just to prevent latches
                //  regMemory[10] = 32'b00000000000000000000000000000100;
                //  regMemory[11] = 32'b00000000000000000000000000000100;
                end
        else
            regMemory[0] <= {32{1'b0}};
            
    initial 
    begin
        $monitor("reg10: %d , reg11: %d, reg12: %d, time: %t", regMemory[10], regMemory[11], regMemory[12], $time);
        
        
    end

    endmodule