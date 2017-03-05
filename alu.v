module alu(
    input [31 : 0] srca,
    input [31 : 0] srcb,
    input [5 : 0] aluCtrl,
    output reg [31 : 0] aluOut,
    output reg branch
);

reg [31 : 0] aluOut_tmp;
reg [31 : 0] aluOut_slt;
reg [31 : 0] aluOut_sltu;
reg [31 : 0] aluOut_blt;
reg [31 : 0] aluOut_bge;
wire [31 : 0] srcb_2cmp;

localparam  add_    = 6'd0,
            sub_    = 6'd1, 
            xor_    = 6'd2,
            sll_    = 6'd3,
            slt_    = 6'd4, 
            sltu_   = 6'd5, 
            srl_    = 6'd6,
            sra_    = 6'd7,
            and_    = 6'd8,
            or_     = 6'd9;

always @(*) begin
    case(aluCtrl)
    add_:
        aluOut_tmp = srca + srcb;
    xor_:
        aluOut_tmp = srca ^ srcb;
    sll_:
        aluOut_tmp = srca << srcb;
    srl_:
        aluOut_tmp = srca >> srcb;
    sra_:
        aluOut_tmp = srca >>> srcb;
    or_:
        aluOut_tmp = srca | srcb;
    and_:
        aluOut_tmp = srca & srcb;
    
    
end

endmodule
