// file: alu_tb.v
// author: @kareefardi
// Testbench for alu

`timescale 1ns/1ns
`include "alu.v"

module alu_tb;
    ///////////////////////////////////////////////////////////
    // The following module tests alu through comparing output
    // of the alu to behavioural model 
    ///////////////////////////////////////////////////////////
    reg [31 : 0] srca;
    reg [31 : 0] srcb;
    reg [5 : 0] aluCtrl;

    wire [31 : 0] aluOut;
    
    alu uut(
        .srca   (srca),
        .srcb   (srcb),
        .aluCtrl(aluCtrl),
        .aluOut (aluOut)
    );

    localparam  
        add_  = 6'd0,
        sub_  = 6'd1,
        xor_  = 6'd2,
        sll_  = 6'd3,
        srl_  = 6'd4,
        sra_  = 6'd5,
        and_  = 6'd6,
        or_   = 6'd7,
        slt_  = 6'd8,
        beq_  = 6'd9,
        bne_  = 6'd10,
        blt_  = 6'd11,
        bge_  = 6'd12,
        sltu_ = 6'd13,
        bltu_ = 6'd14,
        bgeu_ = 6'd15;

    integer a;
    integer b;
    reg [8 * 5 : 0]op[15  : 0];
    reg [31 : 0] r;
    integer i;
    event rst;
    event rst_done;
    initial begin 
        op[add_] = "add";
        op[sub_] = "sub";
        op[xor_] = "xor";
        op[sll_] = "sll";
        op[slt_] = "slt";
        op[srl_] = "srl";
        op[sra_] = "sra";
        op[and_] = "and";
        op[or_] = "or";
        op[beq_] = "beq";
        op[bne_] = "bne";
        op[blt_] = "blt";
        op[bge_] = "bge";
        op[sltu_] = "sltu";
        op[bltu_] = "bltu";
        op[bgeu_] = "bgeu";
    end
    
    initial begin
        @rst;
        a = 0;
        b = 0;
        aluCtrl = 0;
        srca = 0;
        srcb = 0;
        #10->rst_done;
    end

    initial begin
        #10->rst;
        @rst_done;
        a = 21; 
        srca = 21;
        b = 10;
        srcb = 10;
        // general test
        for (i = 0; i < 16; i = i + 1) begin
            aluCtrl = i;
            #1;
            aluMdl(a, b, aluCtrl, r);
            #1;
            if(aluOut != r)
                $display("%d, %s, %d, got: %h, exp: %h", a, op[i], b, aluOut, r); 
        end
        // corner case for unsigned comparistions
        a = {1'b1, {31{1'b0}}};
        srca = {1'b1, {31{1'b0}}};
        b = 1;
        srcb = 1;
        #1;
        for (i = 8; i < 16; i = i + 1) begin
            aluCtrl = i;
            #1;
            aluMdl(a, b, aluCtrl, r);
            #1;
            if (aluOut != r)
                    $display("%h %s %h, got: %h, exp: %h", a, op[i], b, aluOut, r);
        end
    end

    /////////////////////////
    // behavioural alu model
    /////////////////////////
    task aluMdl;
        input [31 : 0] x;
        input [31 : 0] y;
        input [5  : 0] op;
        output reg [31 : 0] z;
        case(op)
        add_:
            z = x + y;
        sub_:
            z = x - y;
        xor_:
            z = x ^ y;
        sll_:
            z = x << y;
        slt_:
            z = ($signed(x) < $signed(y)) ? 1 : 0;
        srl_:
            z = x >> y;
        sra_:
            z = x >>> y;
        and_:
            z = x & y;
        or_:
            z = x | y;
        beq_:
            z = (x == y) ? {1'b1, {31{1'b0}}} : 0;
        bne_:
            z = (x == y) ? 0 : {1'b1, {31{1'b0}}};
        blt_:
            z = ($signed(x) < $signed(y)) ?  {1'b1, {31{1'b0}}} : 0;
        bge_:
            z = ($signed(x) < $signed(y)) ? 0 : {1'b1, {31{1'b0}}};
        bltu_:
            z = (x < y) ? {1'b1, {31{1'b0}}} : 0;
        bgeu_:
            z = (x < y) ? 0 : {1'b1, {31{1'b0}}};
        sltu_:
            z = (x < y) ? 1 : 0;
        default:
            z = 32'hDEADBEAF;
        endcase
    endtask
endmodule