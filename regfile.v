    // file: regfile.v
    // author: @amrheshamgalal
    
    `timescale 1ns/1ns
    
    module regfile(register,writeEnable,writeData,readData);
    input [31:0] register,writeData;
    input writeEnable;
    output reg [31:0] readData;
    
    reg [31:0] regMemory [31:0];
    always@(register or writeEnable)
    begin
    
    if(writeEnable) //if we are writing
        begin 
        readData <= {32{1'bx}};
        if(register != {32{1'b0}})
        regMemory[register] <= writeData;
        else
        regMemory[register] <= {32{1'b0}}; end
    else //if we are reading
    begin
        if(register !== {32{1'bx}})
            if(register == {32{1'b0}})
             readData <=  {32{1'b0}};
            else
             readData <= regMemory[register];
    end
    
    
    
    end
    endmodule
