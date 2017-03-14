    // file: PC.v
    // author: @amrheshamgalal
    
    `timescale 1ns/1ns
    
    module PC(clk,rst,Bimm,branch,ALUout,pcOut,pcEnable,jalEnable, pcplus4);
    
    input clk,rst;
    input jalEnable;
    // input inputAddr;              //this wire is either pc+4 or JAL/JALR target address
    input pcEnable;              // control signal, 1 in the pc stage, else equals 0
    input branch;               //branch control signal
    input [31:0] ALUout;       //ALUout[31]
    input [31:0] Bimm;        //immediate encoded in B type      
    reg [31:0] pc;           //the pc register
    output [31:0] pcOut;
    output [31 : 0] pcplus4;
    wire shouldBranch;
    assign shouldBranch = branch & ALUout[31]; //This wire is to indicate whether the branching condition is true or not
    assign pcOut = pc;
    assign pcplus4 = pc + 4;
    always@(posedge clk) //The pc stage is sequential because we need reset(which is synchornous)
        
        if(!rst)
            if(pcEnable)
                    if(jalEnable)
                        pc <= pc + ALUout;  //In jal, the address is calculated by adding pc to aluout
                    else
                        if(shouldBranch)
                            pc <= pc + Bimm; //In branch, the address is calculated by adding pc to B-encoded immediate
                        else
                            pc <= pcplus4;   //normal instructions
            else
                pc <= pc;   //pc Enable isn't 1 so we don't change pc 
        else
            pc <= {32{1'b0}};   //reseting pc to 0 at the start of the program
        
       
    endmodule