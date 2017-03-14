// file: ALU.v
// author: @kareefardi

`timescale 1ns/1ns

module ALU(
    //////////////////////////////////////////////////////////////
    // the following module models an alu which takes two operands
    // and sets the output according ot operation passed to it
    /////////////////////////////////////////////////////////////
    input [31 : 0] srca,
    input [31 : 0] srcb,
    input [5 : 0] aluCtrl,
    output reg [31 : 0] aluOut
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

reg [31 : 0] aluOut_tmp;
reg c;
wire [31 : 0]  srcb_2cmp;
wire [31 : 0] branch;
wire   
    cmp_2,
    z,
    v,
    lt,
    ge;
assign cmp_2 = (aluCtrl == sub_) 
             | (aluCtrl == beq_) | (aluCtrl == bne_)
             | (aluCtrl == blt_) | (aluCtrl == bge_)
             | (aluCtrl == bltu_) | (aluCtrl == bgeu_)
             | (aluCtrl == sltu_);
assign srcb_2cmp = (cmp_2 == 1'b1) ? (~srcb + 1) : srcb;
assign z = ~(|aluOut_tmp);
assign v = c ^ srcb_2cmp[31] ^ srca[31] ^ aluOut_tmp[31];
//////////////////////////////////////////////////////////
// flags are used for comparison operations...source:
// http://static.righto.com/images/ARM1/condition_bits.png
//////////////////////////////////////////////////////////
assign lt = (aluOut_tmp[31] != v) ? 1'b1 : 1'b0;
assign ge = ((c == 1) | (z == 0)) ? 1'b1 : 1'b0;
assign branch = {1'b1, {31{1'b0}}};

always @(*)
    case(aluCtrl)
    add_,
    sub_,
    beq_,
    bne_,
    bge_,
    blt_,
    slt_,
    bltu_,
    bgeu_,
    sltu_:
        {c, aluOut_tmp} = srca + srcb_2cmp;
    xor_:
        begin
            aluOut_tmp = srca ^ srcb;
            c = 1'b0;
        end
    sll_:
        begin
            aluOut_tmp = srca << srcb;
            c = 1'b0;
        end
    srl_:
        begin
            aluOut_tmp = srca >> srcb;
            c = 1'b0;
        end
    sra_:
        begin
            aluOut_tmp = srca >>> srcb;
            c = 1'b0;
        end
    or_:
        begin
            aluOut_tmp = srca | srcb;
            c = 1'b0;
        end
    and_:
        begin
            aluOut_tmp = srca & srcb;
            c = 1'b0;
        end
    default:
        begin
            aluOut_tmp = 32'd0;
            c = 1'b0;
        end
    endcase

// always block to evaluate comparisons

always @(*)
    case(aluCtrl)
    beq_:
        aluOut = (z == 1'b1) ? branch : 1'b0;
    bne_:
        aluOut = (z == 1'b0) ? branch : 1'b0;
    blt_:
        aluOut = (lt == 1'b1) ? branch : 1'b0;
    bge_:
        aluOut = (lt == 1'b0) ? branch : 1'b0;
    bltu_:
        aluOut = (ge == 1'b0) ? branch : 1'b0;
    bgeu_:
        aluOut = (ge == 1'b1) ? branch : 1'b0;
    sltu_:
        aluOut = (ge == 1'b0) ? {{31{1'b0}}, 1'b1} : 1'b0;
    slt_:
        aluOut = (lt == 1'b1) ? {{31{1'b0}}, 1'b1} : 1'b0;
    default:
        aluOut = aluOut_tmp;
endcase
initial begin
    //$monitor("twossss %d", srcb_2cmp);
end
endmodule