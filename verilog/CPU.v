// file: CPU.v
// author: @omar_nawawy

`timescale 1ns/1ns

module CPU;
    
    input clk, rst;
    
    wire [31 : 0] data_mem_in_32;
    wire [31 : 0] data_mem_in_16;
    wire [31 : 0] data_mem_in_8;
    wire [31 : 0] data_mem_in;
    wire [31 : 0] mem_out_tmp;
    wire [31 : 0] mem_out_16;
    wire [31 : 0] mem_out_8;
    wire [31 : 0] mem_out;
    wire [31 : 0] wbBuff_out;
    wire [31 : 0] pc_plus4;
    wire [31 : 0] data_wb;
    wire [31 : 0] mem_addr;
    wire [31 : 0] alu_buff_out;
    wire [31 : 0] pc_out;

    wire [1 : 0] byteSel;
    wire [1 : 0] wbSel;
    wire aluEn;
    wire branch;
    wire pcEn;
    wire jalEn;
    wire fetchEn;
    wire wEn;
    wire zeroSigned;
    wire wbEn;
    assign pc_plus4 = pc_out + 4;
    param_d_ff_sync inst_buff (.d(), .clk(clk), .rst(rst), .q(), .en());
    
    wire [4 : 0]rs1;
    assign rs1 = instr[19 : 15];
    wire [4 : 0]rd;
    assign rd = instr[11 : 7];
    wire [4 : 0]rs2;
    assign rs2 = instr[24 : 20];
    wire [31 : 0]reg_adr;
    
    mux3 reg_mux (.x0(rs1), .x1(rd), .x2(rs2) .y(reg_adr), .sel());
    
    regfile r ( .clk(clk), .rst(rst), .register(reg_adr), .writeEnable(), .writeData(), .readData());
    
    param_d_ff_sync RS1_buff (.d(), .clk(clk), .rst(rst), .q(), .en());
    param_d_ff_sync RS2_buff (.d(), .clk(clk), .rst(rst), .q(), .en());
    
    imm_handler imm_unit(.instr(), .ctrl(), . imm_out());
    
    
    
    param_d_ff_sync imm_buff (.d(), .clk(clk), .rst(rst), .q(), .en());
    
    
    ALU alu_32 ( .srca(), .srcb(), .aluCtrl(), .aluOut());
    
    param_d_ff_sync ALU_buff (.d(), .clk(clk), .rst(rst), .q(alu_buff_out), .en(aluEn));
    
    PC pc_unit (.clk(clk) , .rst(rst) , .inputAddr(alu_buff_out), .Bimm() , 
        .branch(branch & alu_buff_out[31]) , .ALUout(alu_buff_out) , .pcOut(pc_out) , .pcEnable(pcEn) ,.jalEnable(jalEn));
    
    // adder
    mux2 (.x0(alu_buff_out), .x1(pc_out), .sel(fetchEn), .y(mem_addr));
    //module zsExt(x, y, op); op = 1 signed

    zsExt memImm_16 (.x(), .y(data_mem_in_16), .op(zeroSigned));
    zsExt memImm_8  (.x(), .y(data_mem_in_8), .op(zeroSigned));
    mux3 (.x0(data_mem_in_32), .x1(data_mem_in_16), .x2(data_mem_in_8), .y(data_mem_in), .sel(byteSel));
    
    MEM mem_unit (.address(mem_addr), dataIN.(data_mem_in), .clk(clk), .rst(rst), .wEn(wEn), .memOut(mem_out));
    zsExt memOut_16(.x(mem_out_tmp[15 : 0]), .y(mem_out_16), .op(zeroSigned));
    zsExt memOut_8 (.x(mem_out_tmp[7 : 0]), .y(mem_out_8),  .op(zeroSigned));
    mux3 (.x0(mem_out_tmp), .x1(mem_out_16), .x2(mem_out_8), .y(mem_out), .sel(byteSel)); 
    param_d_ff_sync wb_buff (.d(mem_out), .q(wbBuff_out), .clk(clk). en(wbEn), .rst(rst));
    mux3 (.x0(pc_plus4), .x1(alu_buff_out), .x2(wbBuff_out), .y(data_wb), .sel(byteSel));
    
    
    
    
    
endmodule