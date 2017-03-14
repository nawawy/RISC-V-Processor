// file: CPU_tb.v
// author: @omar_nawawy
// Testbench for CPU

`timescale 1ns/1ns
`include "CPU.v"
module CPU_tb;

	//Inputs
	reg clk;
	reg rst;


	//Outputs

    always #10 clk = ~clk;
	//Instantiation of Unit Under Test
	CPU uut (
		.clk(clk),
		.rst(rst)
	);

	wire [31 : 0] reg_add;
	wire [31 : 0] rs1;
	wire [31 : 0] rs2;
	wire [31 : 0] alu_out;
	wire [31 : 0] pc_out;
	wire [31 : 0] mem_addr;
	wire [4 : 0] state;
	wire pc_en;
	wire pc_jal;
	wire pc_branch;

	assign reg_add = uut.r.register;
	assign rs1 = uut.r.readData;
	assign rs2 = uut.r.readData;
	assign alu_out = uut.alu_32.aluOut;
	assign pc_out = uut.pc_unit.pcOut;
	assign mem_addr = uut.mem_unit.address;
	assign state = uut.CU.state;
	assign pc_en = uut.pc_unit.pcEnable;
	assign pc_jal = uut.pc_unit.jalEnable;
	assign pc_branch = uut.pc_unit.shouldBranch;
	initial begin
	//Inputs initialization
		clk = 0;
		rst = 1;
	//Wait for the reset
		@(negedge clk);
		rst = 0;
		@(negedge clk);
		rst = 1;
		@(negedge clk);
		rst = 0;
	end
	
	initial begin
		forever begin
			@(posedge clk);
			// $display("time%t-,reg_add%d-,rs1%d-,rs2%d-,alu_out%d-,pc_out%d-,mem_addr%d,state%d",
			// 	$time,reg_add,rs1,rs2,alu_out,pc_out,mem_addr,state);
			#5;
			$display("state %d, pcout %d, pcen %d, pcjal %d, pcbranch %d",
					state, pc_out, pc_en, pc_jal, pc_branch);
			if ($time == 395)
				$finish;
		end
	end
	// initial begin
	//    // $monitor("state %d, regIn %d, rd %d, rs1 %d, rs2 %d ", 
	//    // uut.CU.state, uut.r.register, uut.rd, uut.rs1IN, uut.rs2IN);
	//    // $monitor("state %d, rs1 %d, rs2 %d, immOut %d, immBuffOut %d, immBuffEn %d, cuOP %b",
	//    // uut.CU.state, uut.rs1, uut.rs2, uut.immOut, uut.imm, uut.imm_buff.en, uut.CU.opcode);
	//    //$monitor ("regIn %d, memAddr %d, pc_out %d, memOut %d, cuState %d, cuOp %d, fetchEn %d time %t", 
	//    //uut.reg_adr, uut.mem_addr, uut.pc_unit.pc, uut.mem_out_tmp, uut.CU.state, uut.CU.opcode, uut.mem_signals[4], $time);
	//    forever begin
    // 	   @(posedge clk);
    // 	   //$display("aluOut %d, srca %d, rs1IN %d, regSel %d, reg_adr %d, reg_out %d, rs1en %d, cuState %d, time %t",
    // 	   //uut.alu_out, uut.srca, uut.rs1IN, uut.reg_signals[4:3], uut.reg_adr, uut.reg_out, uut.reg_signals[1], uut.CU.state, $time:"
    // 	   $display	("time: %t, srca %d, srcb %d, alu_out %d, wb_add %d, rd %d, naw %d, wb_en2 %d, regAddr %d, stage: %d opcode: %b,pc %d,pcen %d intsr %h,instrtmp %h, memadr:%d",
	// 		    	   $time, uut.srca, uut.srcb, uut.alu_out, uut.mem_addr, uut.rd, uut.reg_signals[4:3], 
	// 		    	   uut.r.writeEnable, uut.r.register, uut.CU.state, uut.CU.opcode, uut.pc_out, uut.pc_signals[1], uut.CU.instr, uut.CU.instr_tmp, uut.mem_addr);
    // 	   //$display("reg[10]: %d", uut.r.regMemory[10]);
    // 	  // $display("instr %d, cuInstr %d, time %t", uut.mem_out_tmp, uut.CU.instr_tmp, $time);
    // 	   if ($time == 390)
    // 	   	 $finish();
	//    end
	// end
endmodule