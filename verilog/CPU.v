// file: CPU.v
// author: @omar_nawawy

`timescale 1ns/1ns

module CPU(clk,rst);
    
    input clk, rst;
    
    wire [31:0] instr;
    
    wire [4 : 0]rs1IN;
    assign rs1IN = instr[19 : 15];
    wire [4 : 0]rd;
    assign rd = instr[11 : 7];
    wire [4 : 0]rs2IN;
    assign rs2IN = instr[24 : 20];
    wire [31 : 0] reg_adr, reg_out, rs1, rs2, srca, srcb;
    wire [31 : 0] immOut, imm, alu_out;
    
    wire [4:0] reg_signals; // regsel, regEN, rs1, rs2
    wire [5:0] mem_signals; // IFen, fetchEN, bytesel, memWrite
    wire [8:0] alu_signals; // srca, srcb, aluctrl, aluEN
    wire [3:0] imm_signals; // immsel, immEN
    wire [2:0] pc_signals;  // branch, pcEN, JalEN
    wire [2:0] wb_signals;  // wbSEl, wbEN
    
    
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
    wire [31 : 0]data_wb_tmp;

    //controls
    wire [1 : 0] byteSel;
    wire [1 : 0] wbSel;
    wire aluEn;
    wire branch;
    wire pcEn;
    wire jalEn;
    wire fetchEn;
    wire wEn;
    wire zeroSigned, lui;
    wire wbEn;

    // assign pc_plus4;
    assign data_mem_in_32 = rs2;

    // output reg [4:0] reg_signals; // regsel, regEN, rs1, rs2
    // output reg [5:0] mem_signals; // IFen, fetchEN, bytesel, memWrite
    // output reg [8:0] alu_signals; // srca, srcb, aluctrl, aluEN
    // output reg [3:0] imm_signals; // immsel, immEN
    // output reg [2:0] pc_signals;  // branch, pcEN, JalEN
    // output reg [2:0] wb_signals;  // wbSEl, wbEN

    controlUnit CU ( .instr_tmp(mem_out_tmp), .clk(clk), .rst(rst), .reg_signals(reg_signals), 
        .mem_signals(mem_signals), .alu_signals(alu_signals) , .imm_signals(imm_signals),
        .pc_signals(pc_signals) , .wb_signals(wb_signals), .zerosign(zeroSigned), .lui(lui));
    // initial begin
    //     $monitor("%d, %t", mem_out_tmp, $time);
    // end
    param_d_ff_sync #(32) inst_buff (.d(mem_out), .clk(clk), .rst(rst), .q(instr), .en(mem_signals[5]));    //instruction buffer

    mux3 reg_mux (.x0({{(32 - 5){1'b0}}, rs1IN}), .x1({{(32 -5){1'b0}},rd}), .x2({{(32 -5){1'b0}},rs2IN}), .y(reg_adr), .sel(reg_signals[4:3]));
    
    Regfile r (.clk(clk), .rst(rst), .register(reg_adr), .writeEnable(reg_signals[2]), .writeData(data_wb), .readData(reg_out));
    
    param_d_ff_sync #(32) RS1_buff (.d(reg_out), .clk(clk), .rst(rst), .q(rs1), .en(reg_signals[1]));
    param_d_ff_sync #(32) RS2_buff (.d(reg_out), .clk(clk), .rst(rst), .q(rs2), .en(reg_signals[0]));
    
    mux2 srca_mux(.x0(rs1), .x1(pc_out) , .y(srca) , .sel(alu_signals[8]));
    mux2 srcb_mux(.x0(rs2), .x1(imm) , .y(srcb) , .sel(alu_signals[7]));

    
    imm_handler imm_unit(.instr(instr), .ctrl(imm_signals[3:1]), .imm_out(immOut));
    

    param_d_ff_sync #(32) imm_buff (.d(immOut), .clk(clk), .rst(rst), .q(imm), .en(imm_signals[0]));
    
    
    ALU alu_32(.srca(srca), .srcb(srcb), .aluCtrl(alu_signals[6:1]), .aluOut(alu_out));

    param_d_ff_sync #(32) ALU_buff (.d(alu_out), .clk(clk), .rst(rst), .q(alu_buff_out), .en(alu_signals[0]));
    
    PC pc_unit (.clk(clk) , .rst(rst), .Bimm(imm) , 
        .branch(pc_signals[2]) , .ALUout(alu_buff_out) , .pcOut(pc_out) , .pcEnable(pc_signals[1]) ,.jalEnable(pc_signals[0]), .pcplus4(pc_plus4));
    
    
    mux2 instr_mux (.x0(alu_buff_out), .x1(pc_out), .sel(mem_signals[4]), .y(mem_addr));
    
    // hello
    zsExt memImm_16 (.x(rs2[15 : 0]), .y(data_mem_in_16), .op(zeroSigned));
    zsExt #(8) memImm_8  (.x(rs2[7 : 0]), .y(data_mem_in_8), .op(zeroSigned));
    mux3 memIN_mux (.x0(data_mem_in_32), .x1(data_mem_in_16), .x2(data_mem_in_8), .y(data_mem_in), .sel(mem_signals[2:1]));
    
    //MEM mem_unit (.address(mem_addr), .dataIn(data_mem_in), .clk(clk), .rst(rst), .wEn(mem_signals[0]), .memOut(mem_out));
    MEM mem_unit (.address(mem_addr), .dataIn(data_mem_in), .clk(clk), .rst(rst), .wEn(mem_signals[0]), .memOut(mem_out_tmp));
    zsExt memOut_16(.x(mem_out_tmp[15 : 0]), .y(mem_out_16), .op(zeroSigned));
    zsExt #(8) memOut_8 (.x(mem_out_tmp[7 : 0]), .y(mem_out_8),  .op(zeroSigned));
    mux3  memOut_mux (.x0(mem_out_tmp), .x1(mem_out_16), .x2(mem_out_8), .y(mem_out), .sel(mem_signals[2:1])); 
    param_d_ff_sync #(32) wb_buff (.d(mem_out), .q(wbBuff_out), .clk(clk), .en(wb_signals[0]), .rst(rst));
    mux3 wb_mux (.x0(pc_plus4), .x1(alu_buff_out), .x2(wbBuff_out), .y(data_wb_tmp), .sel(wb_signals[2:1]));
    mux2 wb_mux_2(.x0 (data_wb_tmp), .x1(imm), .sel (lui), .y (data_wb));
    
endmodule