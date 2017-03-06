// file: controlUnit.v
// author: @omar_nawawy

`timescale 1ns/1ns

module controlUnit();
    
    input [31:0] instr;
    input clk;
    input rst;
    
    output reg [4:0] reg_signals; // regsel, regEN, rs1, rs2
    output reg [5:0] mem_signals; // IFen, fetchEN, bytesel, memWrite
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
            decode1_R  = 5'd1,
            decode1_I  = 5'd3,
            decode2  = 5'd4,
            RB_alu  = 5'd5,
            AUIPC_alu  = 5'd6,
            I_alu  = 5'd7,
            RIA_WB  = 5'd8,
            LD_WB  = 5'd9,
            J_WB  = 5'd10,
            LD_MEM  = 5'd11,
            S_MEM  = 5'd12,
            PCplus4  = 5'd13,
            B_PC  = 5'd14,
            J_PC  = 5'd15;
    
    always@(posedge clk)
    begin
        state = nextstate;
    end
    
    
    always@(state or instr)
    begin
        case(state)
            fetch: 
                begin
                    mem_signals = 6'b11xxx0; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'bxx0;   // wbSEl, wbEN
                    reg_signals = 5'bxx000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'bxxx0;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b00xxxxxx0;  // srca, srcb, aluctrl, aluEN
                    if(opcode == )
                        nextstate = decode1_I;
                    else
                        nextstate = decode1_R;
                    
                end
            decode1_R:
                begin
                    mem_signals = 6'b00xxx0; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'bxx0;   // wbSEl, wbEN
                    reg_signals = 5'b00010;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'bxxx0;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'bxxxxxxxx0;  // srca, srcb, aluctrl, aluEN
                    if (opcode == )
                        nextstate = AUIPC_alu;
                    else
                        nextstate = decode2;
                end
            decode1_I:
                begin
                    mem_signals = 6'b00xxx0; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'bxx0;   // wbSEl, wbEN
                    reg_signals = 5'b10010;  // regsel, regEN, rs1, rs2
                    imm_signals[3:1] = ;
                    imm_signals[0] = 1'b1;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'bxxxxxxxx0;  // srca, srcb, aluctrl, aluEN
                
                
                end
            
        endcase
    end

endmodule
