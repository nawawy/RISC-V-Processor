// file: alu_tb.v
// author: @kareefardi
// Testbench for alu

`timescale 1ns/1ns

module alu_tb;
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
            slt_  = 6'd4,
            srl_  = 6'd5,
            sra_  = 6'd6,
            and_  = 6'd7,
            or_   = 6'd8,
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
        op[0] = "add";
        op[1] = "sub";
        op[2] = "xor";
        op[3] = "sll";
        op[4] = "slt";
        op[5] = "srl";
        op[6] = "sra";
        op[7] = "and";
        op[8] = "or";
        op[9] = "beq";
        op[10] = "bne";
        op[11] = "blt";
        op[12] = "bge";
        op[13] = "sltu";
        op[14] = "bltu";
        op[15] = "bgeu";
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
        for (i = 0; i < 7; i = i + 1) begin
            aluCtrl = i;
            #1;
            aluMdl(a, b, aluCtrl, r);
            #1;
            $display("%d, %s, %d, got: %d, exp: %d", a, op[i], b, aluOut, r); 
        end
    end

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
            z = $signed(x) < $signed(y);
        srl_:
            z = x >> y;
        sra_:
            z = x <<< y;
        and_:
            z = x & y;
        or_:
            z = x | y;
        default:
            z = 32'hDEADBEAF;
        endcase
    endtask
endmodule