// file: imm_handler.v
// author: @omar_nawawy

`timescale 1ns/1ns

module imm_handler(
    input [31:0] instr,
    input [2:0] ctrl, //control signals to choos immediate type
    
    output reg [31:0] imm_out
);


always@(*)
begin 
    case(ctrl)
        3'b000:          // i-imm
            begin
                imm_out[0] = instr[20];
                imm_out[4:1] = instr[24:21];
                imm_out[10:5] = instr[30:25];
                imm_out[31:11] = {20{instr[31]}};
                // $display("IIMM");
            end
            
            
        3'b001:          // s-imm
            begin
                imm_out[0] = instr[7];
                imm_out[4:1] = instr[11:8];
                imm_out[10:5] = instr[30:25];
                imm_out[31:11] = {20{instr[31]}};
                // $display("SIMM");
            end
                
            
        3'b010:        // b-imm
            begin
                imm_out[0] = 1'b0;
                imm_out[4:1] = instr[11:8];
                imm_out[10:5] = instr[30:25];
                imm_out[11] = instr[7];
                imm_out[31:12] = {19{instr[31]}};
                // $display("BIMM");
            end
        
        3'b011:        // j-imm
            begin
                imm_out[0] = 1'b0;
                imm_out[4:1] = instr[24:21];
                imm_out[10:5] = instr[30:25];
                imm_out[11] = instr[20];
                imm_out[19:12] = instr[19:12];
                imm_out[31:20] = {19{instr[31]}};
                // $display("JIMM");
            end   
            
        3'b100:        // U-imm
            begin
                imm_out[11:0] = 11'd0;
                imm_out[19:12] = instr[19:12];
                imm_out[31:20] = instr[31 : 20];
                // $display("UIMM");
            end  
        
        default:
            imm_out = 32'bx;
    
    endcase


end


endmodule