// file: controlUnit.v
// author: @omar_nawawy

`timescale 1ns/1ns

module controlUnit(instr_tmp,clk,rst,reg_signals,mem_signals,alu_signals,imm_signals,pc_signals,wb_signals,zerosign, lui);
    
    input [31:0] instr_tmp;
    input clk;
    input rst;
    
    output reg [4:0] reg_signals; // regsel, regEN, rs1, rs2
    output reg [5:0] mem_signals; // IFen, fetchEN, bytesel, memWrite
    output reg [8:0] alu_signals; // srca, srcb, aluctrl, aluEN
    output reg [3:0] imm_signals; // immsel, immEN
    output reg [2:0] pc_signals;  // branch, pcEN, JalEN
    output reg [2:0] wb_signals;  // wbSEl, wbEN
    output reg zerosign, lui;

    // temp buffer for instruction
    reg [31 : 0] instr;
    always @ (posedge clk) begin
        if (state == fetch || state == waitt)
            instr <= instr_tmp;
        else
            instr <= instr;
    end
    wire [6:0] opcode;
    assign opcode = instr[6:0];
    wire [2:0] func3;
    assign func3 = instr[14:12];
    wire [6:0] func7;
    assign func7 = instr[31:25];
    
    
    reg [4:0] state, nextstate;
    
    localparam            // stages for the control unit
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
            J_PC  = 5'd15,
            waitt = 5'd16,
	    stop = 5'd17,
            
            // alu control
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
    
    always@(posedge clk)
    begin
        if(rst) begin
            state <= waitt;
            // $display("reseting");
            end
        else
            state <= nextstate;
    end
    
    
    always@(state or instr)
    begin
        lui = 1'b0;
        case(state)
            fetch: 
                begin
                    mem_signals = 6'b110000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;
                    
                    // $monitor("fetch op %d %t, %b", opcode, $time, instr);
                    if(opcode == 7'b0010011 || opcode == 7'b0100011 || opcode == 7'b0000011 || opcode == 7'b1101111 || opcode == 7'b1100111)
                    begin // i-type, stores, load 
                        // $display("over here opcode %d %t", opcode, $time);
                        nextstate = decode1_I;
                    end
                    else begin
                        nextstate = decode1_R;
                        // $display("over there opcode %d %t", opcode, $time);
			
		    if (opcode == 7'b1110011)
				nextstate = stop;

                    end
                    
                end
            decode1_R:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00010;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;
                    
                    if(opcode == 7'b1100011 || opcode == 7'b0010111 || opcode == 7'b0110111)
                        imm_signals[0] = 1'b1;
                    else
                        imm_signals[0] = 1'b0;
                    
                    if (opcode == 7'b0010111 || opcode == 7'b1101111 || opcode == 7'b1100111)
                        nextstate = AUIPC_alu;
                    else
                        nextstate = decode2;
                        

                    case (opcode)
                    7'b1100011:
                        imm_signals[3:1] = 3'b010;
                    7'b0000011 ,
                    7'b0010011 :
                        imm_signals[3:1] = 3'b000;
                    7'b0110111 ,
                    7'b0010111 : begin
                        imm_signals[3:1] = 3'b100;
                        $display("here");
                        end
                    7'b1101111,
                    7'b1100111: 
                        imm_signals[3:1] = 3'b011;
                    7'b0100011:
                        imm_signals[3:1] = 3'b001;
                    default: 
                        imm_signals[3:1] = 3'b100;
                    endcase
                        
                end
            decode1_I:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    // reg_signals = 5'b10010;  // regsel, regEN, rs1, rs2
                    reg_signals = 5'b00010;  // regsel, regEN, rs1, rs2
                    imm_signals[0] = 1'b1;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;
                    
                    case (opcode)
                    7'b1100011:
                        imm_signals[3:1] = 3'b010;
                    7'b0000011 ,
                    7'b0010011 :
                        imm_signals[3:1] = 3'b000;
                    7'b0110111 ,
                    7'b0010111 : begin
                        imm_signals[3:1] = 3'b100;
                        // $display("here");
                        end
                    7'b1101111,
                    7'b1100111: 
                        imm_signals[3:1] = 3'b011;
                    7'b0100011:
                        imm_signals[3:1] = 3'b001;
                    default: 
                        imm_signals[3:1] = 3'b100;
                    endcase
                    
                    if(opcode == 7'b0100011)
                        nextstate = decode2;
                    else
                        nextstate = I_alu;
                end
                
            decode2:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b10001;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;
                    
                    if(opcode == 7'b0100011)
                        begin
                            nextstate = I_alu;
                            imm_signals[0] = 1'b1;
			    imm_signals[3:1] = 3'b001;
                        end
                    else
                        nextstate = RB_alu;
                end
            
            RB_alu:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals[0] = 1'b1;
                    alu_signals[8:7] = 2'b00;
                    zerosign = 1'b0;
                    
                    if(opcode == 7'b1100011)
                        nextstate = B_PC;
                    else
                        nextstate = RIA_WB;
                        
                    if((opcode == 7'b1100011) && (func3 == 3'b000))
                        alu_signals[6:1] = beq_;
                    else
                    if((opcode == 7'b1100011) && (func3 == 3'b001))
                        alu_signals[6:1] = bne_;
                    else
                    if((opcode == 7'b1100011) && (func3 == 3'b100))
                        alu_signals[6:1] = blt_;
                    else
                    if((opcode == 7'b1100011) && (func3 == 3'b101))
                        alu_signals[6:1] = bge_;
                    else
                    if((opcode == 7'b1100011) && (func3 == 3'b110))
                        alu_signals[6:1] = bltu_;
                    else
                    if((opcode == 7'b1100011) && (func3 == 3'b111))
                        alu_signals[6:1] = bgeu_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b000) && (func7 == 7'b0000000))
                        alu_signals[6:1] = add_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b000) && (func7 == 7'b0100000))
                        alu_signals[6:1] = sub_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b001) && (func7 == 7'b0000000))
                        alu_signals[6:1] = sll_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b010) && (func7 == 7'b0000000))
                        alu_signals[6:1] = slt_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b011) && (func7 == 7'b0000000))
                        alu_signals[6:1] = sltu_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b100) && (func7 == 7'b0000000))
                        alu_signals[6:1] = xor_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b101) && (func7 == 7'b0000000))
                        alu_signals[6:1] = srl_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b101) && (func7 == 7'b0100000))
                        alu_signals[6:1] = sra_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b110) && (func7 == 7'b0000000))
                        alu_signals[6:1] = or_;
                    else
                    if((opcode == 7'b0110011) && (func3 == 3'b111) && (func7 == 7'b0000000))
                        alu_signals[6:1] = and_;
                    else
                        alu_signals[6:1] = 6'b0;
                end
                
                
            I_alu:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals[0] = 1'b1;
                    alu_signals[8:7] = 2'b01;
                    zerosign = 1'b0;
                    
                     if(opcode == 7'b0000011)
                        alu_signals[6:1] = add_;
                    else
                     if(opcode == 7'b0100011)
                        alu_signals[6:1] = add_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b000))
                        alu_signals[6:1] = add_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b010))
                        alu_signals[6:1] = slt_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b011))
                        alu_signals[6:1] = sltu_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b100))
                        alu_signals[6:1] = xor_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b110))
                        alu_signals[6:1] = or_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b111))
                        alu_signals[6:1] = and_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b001))
                        alu_signals[6:1] = sll_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b101) && (func7 == 7'b0000000))
                        alu_signals[6:1] = srl_;
                    else
                     if((opcode == 7'b0010011) && (func3 == 3'b101) && (func7 == 7'b0100000))
                        alu_signals[6:1] = sra_;
                    else
                     if (opcode == 7'b1101111 || opcode == 7'b1100111)
                        alu_signals[6:1] = add_;
                    else
                        alu_signals[6:1] = 6'b0;
                
                    
                    if(opcode == 7'b1101111 || opcode == 7'b1100111)
                        nextstate = J_WB;
                    else
                    if(opcode == 7'b0100011)
                        nextstate = S_MEM;
                    else
                    if(opcode == 7'b0000011)
                        nextstate = LD_MEM;
                    else
                        nextstate = RIA_WB;
                end
                
            AUIPC_alu:    
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00010;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals[0] = 1'b1;
                    zerosign = 1'b0;
                    
                   if(opcode == 7'b0010111)
                        alu_signals[8:7] = 2'b11;
                    else
                    if(opcode == 7'b1101111)
                        alu_signals[8:7] = 2'b11;
                    else
                        alu_signals[8:7] = 2'b01;

                    alu_signals[6:1] = add_;
                    
                    nextstate = RIA_WB;
                end
            
            RIA_WB:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b010;   // wbSEl, wbEN
                    // reg_signals = 5'b00100;  // regsel, regEN, rs1, rs2
                    reg_signals = 5'b01100;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;
                    if(opcode == 7'b0110111)
                        lui = 1'b1;
                    else
                        lui = 1'b0;
                    nextstate = PCplus4;
                end
                
            LD_WB:
                begin
                    mem_signals[5:4] = 2'b00;
                    mem_signals[0] = 1'b0; 
                    wb_signals = 3'b100;   // wbSEl, wbEN
                    reg_signals = 5'b01100;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;
                    
                    case(func3)
                        3'b000:
                            mem_signals[3:1] = 3'b010;
                        3'b001:
                            mem_signals[3:1] = 3'b001;
                        3'b010:
                            mem_signals[3:1] = 3'b000;
                        3'b100:
                            mem_signals[3:1] = 3'b010;
                        3'b101:
                            mem_signals[3:1] = 3'b001;
                        default:
                            mem_signals[3:1] = 3'b000;
                    endcase
                    
                
                    nextstate = PCplus4;
                end
                
                
            J_WB:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b01100;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;
                    
                    nextstate = J_PC;
                end
                
            LD_MEM:
                begin
                    mem_signals[5:4] = 2'b00;
                    mem_signals[0] = 1'b0; 
                    
                    wb_signals = 3'b101;   // wbSEl, wbEN
                    reg_signals = 5'b00000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    
                    case(func3)
                        3'b000:
                            mem_signals[3:1] = 3'b010;
                        3'b001:
                            mem_signals[3:1] = 3'b001;
                        3'b010:
                            mem_signals[3:1] = 3'b000;
                        3'b100:
                            mem_signals[3:1] = 3'b010;
                        3'b101:
                            mem_signals[3:1] = 3'b001;
                        default:
                            mem_signals[3:1] = 3'b000;
                    endcase
                    
                    if (func3 == 3'b000 || func3 == 3'b001)
                        zerosign = 1'b0;
                    else
                        zerosign = 1'b1;
                    
                    nextstate = LD_WB;
                
                end
                
            S_MEM:
                begin 
                    mem_signals[5:4] = 2'b00;
                    mem_signals[0] = 1'b1; 
                    
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b000;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    
                    case(func3)
                        3'b000:
                            mem_signals[3:1] = 3'b010;
                        3'b001:
                            mem_signals[3:1] = 3'b001;
                        3'b010:
                            mem_signals[3:1] = 3'b000;
                        3'b100:
                            mem_signals[3:1] = 3'b010;
                        3'b101:
                            mem_signals[3:1] = 3'b001;
                        default:
                            mem_signals[3:1] = 3'b000;
                    endcase
                    
                    
                    zerosign = 1'b1;
                    
                    nextstate = PCplus4;
                
                
                end
                
            PCplus4:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b010;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;

                    nextstate = waitt;
                end
                
            B_PC:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b110;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;

                    nextstate = waitt;
                end
                
            J_PC:
                begin
                    mem_signals = 6'b000000; // IFen, fetchEN, bytesel, memWrite
                    wb_signals = 3'b000;   // wbSEl, wbEN
                    reg_signals = 5'b00000;  // regsel, regEN, rs1, rs2
                    imm_signals = 4'b0000;   // immsel, immEN
                    pc_signals = 3'b011;    // branch, pcEN, JalEN
                    alu_signals = 9'b000000000;  // srca, srcb, aluctrl, aluEN
                    zerosign = 1'b0;
                    
                    nextstate = waitt;
                end
            
            waitt:
                begin
                    reg_signals = 5'b0; 
                    mem_signals = 6'b0; 
                    alu_signals = 9'b0; 
                    imm_signals = 4'b0; 
                    pc_signals = 3'b0;  
                    wb_signals = 3'b0;  
                    
                    mem_signals[4] = 1'b1;
                    zerosign = 1'b0;
                    nextstate = fetch;
                end
            default:
                begin
                    reg_signals = 5'b0; 
                    mem_signals = 6'b0; 
                    alu_signals = 9'b0; 
                    imm_signals = 4'b0; 
                    pc_signals = 3'b0;  
                    wb_signals = 3'b0;  
                    nextstate = 5'b0;
                    zerosign = 1'b0;

                end
        endcase
        
        
    end

endmodule