#include "ISA.h"

ISA::ISA() {
	srand(time(NULL));
	this->pc = 0;
	for (int i = 0; i < 32; i++)
		regs[i].full = false;

	regs[0].full = true;
	regs[0].data = 0;
	memset(mem, false, sizeof(mem));

	Instr LUI("rd imm", "LUI");                              list.push_back(LUI);    pc0.push_back(LUI);
	Instr AUIPC("rd imm", "AUIPC");                          list.push_back(AUIPC);  pc0.push_back(AUIPC);

	Instr JAL("rd imm", "JAL");                              list.push_back(JAL);    pc0.push_back(JAL);
	Instr JALR("rd rs1 imm", "JALR");                        list.push_back(JALR);   pc0.push_back(JALR);
	Instr BEQ("rs1 rs2 imm", "BEQ");                         list.push_back(BEQ);
	Instr BNE("rs1 rs2 imm", "BNE");                         list.push_back(BNE);
	Instr BLT("rs1 rs2 imm", "BLT");                         list.push_back(BLT);
	Instr BGE("rs1 rs2 imm", "BGE");                         list.push_back(BGE);
	Instr BLTU("rs1 rs2 imm", "BLTU");                      list.push_back(BLTU);
	Instr BGEU("rs1 rs2 imm", "BGEU");                      list.push_back(BGEU);
	Instr LB("rd rs1 imm", "LB");                            list.push_back(LB);
	Instr LH("rd rs1 imm", "LH");                            list.push_back(LH);
	Instr LW("rd rs1 imm", "LW");                            list.push_back(LW);
	Instr LBU("rd rs1 imm", "LBU");                          list.push_back(LBU);
	Instr LHU("rd rs1 imm", "LHU");                          list.push_back(LHU);

	Instr SB("rs1 rs2 imm", "SB");                          list.push_back(SB);     pc0.push_back(SB);
	Instr SH("rs1 rs2 imm", "SH");                          list.push_back(SH);     pc0.push_back(SH);
	Instr SW("rs1 rs2 imm", "SW");                          list.push_back(SW);     pc0.push_back(SW);

	Instr ADDI("rd rs1 imm", "ADDI");                        list.push_back(ADDI);   pc0.push_back(ADDI);
	Instr SLTI("rd rs1 imm", "SLTI");                        list.push_back(SLTI);   pc0.push_back(SLTI);
	Instr SLTIU("rd rs1 imm", "SLTIU");                      list.push_back(SLTIU);  pc0.push_back(SLTIU);
	Instr XORI("rd rs1 imm", "XORI");                        list.push_back(XORI);   pc0.push_back(XORI);
	Instr ORI("rd rs1 imm", "ORI");                          list.push_back(ORI);    pc0.push_back(ORI);
	Instr ANDI("rd rs1 imm", "ANDI");                        list.push_back(ANDI);   pc0.push_back(ANDI);
	Instr SLLI("rd rs1 shamt", "SLLI");                      list.push_back(SLLI);   pc0.push_back(SLLI);
	Instr SRLI("rd rs1 shamt", "SRLI");                      list.push_back(SRLI);   pc0.push_back(SRLI);
	Instr SRAI("rd rs1 shamt", "SRAI");                      list.push_back(SRAI);   pc0.push_back(SRAI);

	Instr ADD("rd rs1 rs2", "ADD");                         list.push_back(ADD);
	Instr SUB("rd rs1 rs2", "SUB");                         list.push_back(SUB);
	Instr SLL("rd rs1 rs2", "SLL");                         list.push_back(SLL);
	Instr SLT("rd rs1 rs2", "SLT");                         list.push_back(SLT);
	Instr SLTU("rd rs1 rs2", "SLTU");                       list.push_back(SLTU);
	Instr XOR("rd rs1 rs2", "XOR");                         list.push_back(XOR);
	Instr SRL("rd rs1 rs2", "SRL");                         list.push_back(SRL);
	Instr SRA("rd rs1 rs2", "SRA");                         list.push_back(SRA);
	Instr OR("rd rs1 rs2", "OR");                           list.push_back(OR);
	Instr AND("rd rs1 rs2", "AND");                         list.push_back(AND);
}

void ISA::getRandom(int number, string *p) {
	string output = "";
	int randIndex;

	for (int i = 0; i < number; i++)
	{
		output = handlePC0(number);
		p[i] = output;
	}
	//TODO:Temporary done for pc0 now


	//this->pc += 4;
}

string ISA::handlePC0(int number) {

	string output;
	int randInd;
	randInd = rand() % pc0.size();
	output = pc0[randInd].getKeyword();
	output = output + " ";

	int rd, rs1, shamt, imm;
	rd = (rand() % 31) + 1;    //from reg 1 to reg 31 (because we write)

	switch (randInd)
	{
		//LUI
	case 0:
		UI(output, imm, rd, false);
		break;
		//AUIPC
	case 1:
		UI(output, imm, rd, true);
		break;
		//JAL
	case 2:
		jumps(output, imm, rs1, rd, number, pc, false);
		break;
		//JALR
	case 3:
		jumps(output, imm, rs1, rd, number, pc, true);
		//SB
		/*case 4: rs1 = 0; //all other regs are undefined at this point
		rs2 = 0; //first instruction so src has to be 0
		//TODO: calculate how the immediate is gonna be calculated as the new memory structure
		//temporary assuming memory is from 0 to 31
		imm = rand() % 32;
		break;
		//SH
		case 5:
		rs1 = 0; //all other regs are undefined at this point
		rs2 = 0; //first instruction so src has to be 0
		//TODO: calculate how the immediate is gonna be calculated as the new memory structure
		//temporary assuming memory is from 0 to 31
		imm = rand() % 32;
		break;
		//SW
		case 6:
		rs1 = 0; //all other regs are undefined at this point
		rs2 = 0; //first instruction so src has to be 0
		//TODO: calculate how the immediate is gonna be calculated as the new memory structure
		//temporary assuming memory is from 0 to 31
		imm = rand() % 32;
		break;*/
		//Addi
	case 7: Itype(output, rs1, imm, pc, rd, false, 0);
		break;
		//slti
	case 8: Itype(output, rs1, imm, pc, rd, false, 1);
		break;
		//sltiu
	case 9: Itype(output, rs1, imm, pc, rd, true, 2);
		break;
		//xori
	case 10:Itype(output, rs1, imm, pc, rd, false, 3);
		break;
		//ori
	case 11:Itype(output, rs1, imm, pc, rd, false, 4);
		break;
		//andi
	case 12:Itype(output, rs1, imm, pc, rd, false, 5);
		break;
		//SLLI
	case 13:shifts(output, rs1, shamt, rd, pc, 0);
		break;
		//srli
	case 14:shifts(output, rs1, shamt, rd, pc, 1);
		break;
		//srai:
	case 15:shifts(output, rs1, shamt, rd, pc, 2);
		break;
	default: output = "The instruction selected is probably store and it isn't implemented yet \n";
	}
	return output;

}

void ISA::Itype(string& output, int&rs1, int& imm, int pc, int rd, bool SLTIU, int indic) {

	//srand(time(NULL));

	if (!SLTIU)
		imm = (rand() % 8192) - 4096; //from -(2^12) to (2^12 - 1) , if it's signed immediate()
	else
		imm = rand() % 4096; //(2^12)-1

	if (pc == 0)
		rs1 = 0;
	else
	{
		do {
			rs1 = rand() % 32;
		} while (!regs[rs1].full); //repeat if we got an empty source
	}

	regs[rd].full = true;
	if (indic == 0) //addi
		regs[rd].data = regs[rs1].data + imm;
	else
		if (indic == 1) //slti
			if (regs[rs1].data < imm)
				regs[rd].data = 1;
			else
				regs[rd].data = 0;
		else
			if (indic == 2)  //sltiu
			{
				unsigned int temp = imm;
				if (regs[rs1].data < temp)
					regs[rd].data = 1;
				else
					regs[rd].data = 0;
			}
			else        //xori
				if (indic == 3)
					regs[rd].data = regs[rs1].data ^ imm;
				else    //ori
					if (indic == 4)
						regs[rd].data = regs[rs1].data | imm;
					else //andi
						regs[rd].data = regs[rs1].data & imm;

	output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(imm) + "\n";
}

void ISA::shifts(string & output, int &rs1, int &shamt, int rd, int pc, int indic) {

	shamt = rand() % 32; //from 0 to (2^5)-1
	if (pc == 0)
		rs1 = 0;
	else
	{
		do {
			rs1 = rand() % 32;
		} while (!regs[rs1].full); //repeat if we got an empty source
	}

	if (indic == 0) //slli
		regs[rd].data = regs[rs1].data << shamt;
	else
		if (indic == 1)
			regs[rd].data = regs[rs1].data >> shamt; //TODO: fix it if possible; we are treating srli as srai

	regs[rd].full = true;

	output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(shamt) + "\n";
}

void ISA::UI(string & output, int & imm, int rd, bool AUIPC) {

	imm = (rand() % 1048576) - 524288; //from -(2^19) to (2^19 -1)
	output = output + to_string(rd) + ',' + to_string(imm) + "\n";
	regs[rd].data = imm << 20;
	if (AUIPC)
		regs[rd].data += pc;
	regs[rd].full = true;
}

void ISA::jumps(string & output, int & imm, int& rs1, int rd, int number, int pc, bool jalr) {

	int maxPC = (number - 1) * 4;
	int maxOffset = maxPC - pc;
	if (!jalr)
	{
		do
		{
			imm = rand() % (maxOffset + 1); //+1 to have maxOffset as an output
		} while (imm % 4 != 0 || imm == 0);
		output = output + to_string(rd) + ',' + to_string(imm) + "\n";
	}
	else
	{
		do
		{
			rs1 = rand() % 32;
		} while (!regs[rs1].full);

		maxOffset -= regs[rs1].data;
		do
		{
			imm = rand() % (maxOffset + 1);
		} while (imm % 4 != 0 || imm == 0);
		output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(imm) + "\n";
	}

}

ISA::~ISA() {

}
