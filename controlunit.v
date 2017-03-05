// file: controlUnit.v
// author: @omar_nawawy

`timescale 1ns/1ns

module controlUnit();
    
    input [31:0] instr;
    input clk;
    
    output reg [4:0] reg_signals; // regsel, regEN, rs1, rs2
    output reg [3:0] mem_signals; // fetchEN, bytesel, memWrite
    output reg [8:0] alu_signals; // srca, srcb, aluctrl, aluEN
    output reg [3:0] imm_signals; // immsel, immEN
    output reg [2:0] pc_signals;  // branch, pcEN, JalEN
    output reg [2:0] wb_signals;  // wbSEl, wbEN


    wire [6:0] opcode;
    assign opcode = instr[6:0];
    wire [2:0] func3;
    assign func3 = instr[14:12];
    wire [6:0] func7;
    assign func7 = instr[31:25];
    
    
    reg [4:0] state = 0, nextstate;
    
    localparam  
            fetch  = 5'd0,
            decode1  = 5'd1,
            decode2  = 5'd2,
            alu  = 5'd3,
            pc  = 5'd4,
            memWrite  = 5'd5,
            memRead  = 5'd6;

    
    always@(posedge clk)
    begin
        state = nextstate;
    end
    
    
    always@(state, instr)
    begin
        case(state)
            fetch: 
                begin
                
                
                end
            decode1:
                begin
                
                
                end
    
    
    
    
    
    
    end

endmodule
