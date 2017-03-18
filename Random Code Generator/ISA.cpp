//
// Created by Oba on 09/03/17.
//

#include "ISA.h"

ISA::ISA() {
	srand(time(NULL));

	this->pc = 0;
	memset(regs, false, sizeof(regs));
	regs[0] = true;
	memset(mem, false, sizeof(mem));
	mem[0] = true;
	instrInd = 0;

	for (int i = 0; i < 20; i++)
		instr[i] = false;

	for (int i = 0; i < 20; i++)
		branch[i].name = "Jump" + to_string(i + 1);

	Instr LUI("LUI");                              list.push_back(LUI);    pc0.push_back(LUI);
	Instr AUIPC("AUIPC");                          list.push_back(AUIPC);  pc0.push_back(AUIPC);

	Instr JAL("JAL");                              list.push_back(JAL);    pc0.push_back(JAL);
	Instr JALR("JALR");                            list.push_back(JALR);   pc0.push_back(JALR);

	Instr BEQ("BEQ");                              list.push_back(BEQ);
	Instr BNE("BNE");                              list.push_back(BNE);
	Instr BLT("BLT");                              list.push_back(BLT);
	Instr BGE("BGE");                              list.push_back(BGE);
	Instr BLTU("BLTU");                            list.push_back(BLTU);
	Instr BGEU("BGEU");                            list.push_back(BGEU);

	Instr ADDI("ADDI");                               list.push_back(ADDI);   pc0.push_back(ADDI);
	Instr SLTI("SLTI");                               list.push_back(SLTI);   pc0.push_back(SLTI);
	Instr SLTIU("SLTIU");                             list.push_back(SLTIU);  pc0.push_back(SLTIU);
	Instr XORI("XORI");                               list.push_back(XORI);   pc0.push_back(XORI);
	Instr ORI("ORI");                                 list.push_back(ORI);    pc0.push_back(ORI);
	Instr ANDI("ANDI");                               list.push_back(ANDI);   pc0.push_back(ANDI);
	Instr SLLI("SLLI");                               list.push_back(SLLI);   pc0.push_back(SLLI);
	Instr SRLI("SRLI");                               list.push_back(SRLI);   pc0.push_back(SRLI);
	Instr SRAI("SRAI");                               list.push_back(SRAI);   pc0.push_back(SRAI);

	Instr ADD("ADD");                         list.push_back(ADD);
	Instr SUB("SUB");                         list.push_back(SUB);
	Instr SLL("SLL");                         list.push_back(SLL);
	Instr SLT("SLT");                         list.push_back(SLT);
	Instr SLTU("SLTU");                       list.push_back(SLTU);
	Instr XOR("XOR");                         list.push_back(XOR);
	Instr SRL("SRL");                         list.push_back(SRL);
	Instr SRA("SRA");                         list.push_back(SRA);
	Instr OR("OR");                           list.push_back(OR);
	Instr AND("AND");                         list.push_back(AND);

	Instr LB("LB");                                 list.push_back(LB);
	Instr LH("LH");                                 list.push_back(LH);
	Instr LW("LW");                                 list.push_back(LW);
	Instr LBU("LBU");                               list.push_back(LBU);
	Instr LHU("LHU");                               list.push_back(LHU); //33

	Instr SB("SB");                                  list.push_back(SB);     pc0.push_back(SB);
	Instr SH("SH");                                  list.push_back(SH);     pc0.push_back(SH);
	Instr SW("SW");                                  list.push_back(SW);     pc0.push_back(SW);
}

void ISA::getRandom(int number, string *p) {
	string output;
	for (int i = 0; i < number; i++)
	{
		if (i == 0)
			output = handlePC0(number);
		else
			output = handleRest(number, i);

		p[i] = output;
		this->pc += 4;
		instrInd++;
	}
	fixBranches(p);
}

string ISA::handlePC0(int number) {

	string output;
	int randInd;
	randInd = rand() % pc0.size();
	output = pc0[randInd].getKeyword();
	output = output + " ";

	int rd, rs1,rs2, shamt, imm;
	rd = (rand() % 31) + 1;    //from reg 1 to reg 31 (because we write)
	switch (randInd)
	{
		//LUI
	case 0:
		UI(output, imm, rd);
		break;
		//AUIPC
	case 1:
		UI(output, imm, rd);
		break;
		//JAL
	case 2:
		jumps(output, imm, rs1, rd, number, pc, false);
		break;
		//JALR
	case 3:
		jumps(output, imm, rs1, rd, number, pc, true);
		break;
		//Addi
	case 4: Itype(output, rs1, imm, pc, rd, false);
		break;
		//slti
	case 5: Itype(output, rs1, imm, pc, rd, false);
		break;
		//sltiu
	case 6: Itype(output, rs1, imm, pc, rd, true);
		break;
		//xori
	case 7:Itype(output, rs1, imm, pc, rd, false);
		break;
		//ori
	case 8:Itype(output, rs1, imm, pc, rd, false);
		break;
		//andi
	case 9:Itype(output, rs1, imm, pc, rd, false);
		break;
		//SLLI
	case 10:shifts(output, rs1, shamt, rd, pc);
		break;
		//srli
	case 11:shifts(output, rs1, shamt, rd, pc);
		break;
		//srai:
	case 12:shifts(output, rs1, shamt, rd, pc);
		break;
	case 13:
	case 14:
	case 15: store(output, rs1, rs2, imm);
		break;
	}
	return output;
}

void ISA::Itype(string& output, int&rs1, int& imm, int pc, int rd, bool unsign) {

	if (!unsign)
		imm = rand() % 100; //from -(2^12) to (2^12 - 1) , if it's signed immediate()
	else
		imm = rand() % 100; //(2^12)-1

	if (pc == 0)
		rs1 = 0;
	else
	{
		do {
			rs1 = rand() % 32;
		} while (!regs[rs1]); //repeat if we got an empty source
	}

	regs[rd] = true;
	output = output + 'x' + to_string(rd) + ',' + 'x' + to_string(rs1) + ',' + to_string(imm) + "\n";
}

void ISA::shifts(string & output, int &rs1, int &shamt, int rd, int pc) {

	shamt = rand() % 32; //from 0 to (2^5)-1
	if (pc == 0)
		rs1 = 0;
	else
	{
		do {
			rs1 = rand() % 32;
		} while (!regs[rs1]); //repeat if we got an empty source
	}

	regs[rd] = true;

	output = output + 'x' + to_string(rd) + ',' + 'x' + to_string(rs1) + ',' + to_string(shamt) + "\n";
}

void ISA::UI(string & output, int & imm, int rd) {

	imm = rand() % 100; //from -(2^19) to (2^19 -1)
	output = output + 'x' + to_string(rd) + ',' + to_string(imm) + "\n";
	regs[rd] = true;
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
		rs1 = 0;
		do
		{
			imm = rand() % (maxOffset + 1);
		} while (imm % 4 != 0 || imm == 0);
		output = output + 'x' + to_string(rd) + ',' + 'x' + to_string(rs1) + ',' + to_string(imm) + "\n";
	}

}

ISA::~ISA() {

}

string ISA::handleRest(int number, int i) {

	int imm, rd, rs1, rs2, shamt;
	rd = (rand() % 31) + 1;

	string output = "";
	int randInd;
	if (i == number - 1)
		do
		{
			randInd = (int)(rand() % list.size());
		} while (randInd == 2 || randInd == 3);      //last instruction cant be JAL or JALR
	else
		randInd = (int)(rand() % list.size());

	output += list[randInd].getKeyword();
	output += " ";

	switch (randInd)
	{
		//LUI, AUIPC
	case 0:
	case 1: UI(output, imm, rd); //AUIPC
		break;

	case 2: jumps(output, imm, rs1, rd, number, pc, false); //JAL
		break;
	case 3: jumps(output, imm, rs1, rd, number, pc, true); //JALR
		break;

		//BEQ,BNE,BLT,BGE,BLTU,BGEU
	case 4:
	case 5:
	case 6:
	case 7:
	case 8:
	case 9: {branches(output, rs1, rs2, imm, pc, number); instr[instrInd] = true;}
		break;

	case 10: Itype(output, rs1, imm, pc, rd, false);   //addi
		break;
		//slti
	case 11: Itype(output, rs1, imm, pc, rd, false);
		break;
		//sltiu
	case 12: Itype(output, rs1, imm, pc, rd, true);
		break;
		//xori
	case 13:Itype(output, rs1, imm, pc, rd, false);
		break;
		//ori
	case 14:Itype(output, rs1, imm, pc, rd, false);
		break;
		//andi
	case 15:Itype(output, rs1, imm, pc, rd, 5);
		break;
		//SLLI,srli,srai
	case 16:
	case 17:
	case 18:shifts(output, rs1, shamt, rd, pc);
		break;
	case 29:
	case 30:
	case 31:
	case 32:
	case 33: loads(output, rs1, imm, rd);
		break;
	case 34:
	case 35:
	case 36: store(output, rs1, rs2, imm);
		break;

	default: Rtype(output, rs1, rs2, rd); //R type
	}
	return output;
}

void ISA::branches(string & output, int &rs1, int &rs2, int& imm, int pc, int number) {

	bool srcs = false;
	do {
		rs1 = rand() % 32;
	} while (!regs[rs1]);

	do {
		rs2 = rand() % 32;
	} while (!regs[rs2]);

	if (rs1 == 0 && rs2 == 0)
		srcs = true;
	int maxPC = (number - 1) * 4;
	int maxOffset = maxPC - pc;
	int minOffset = 0 - pc;
	do
	{
		imm = (rand() % (maxOffset - minOffset + 1)) + minOffset;
	} while ((imm % 4 != 0 || imm == 0) || (srcs && imm < 0)); //will repeat if immediate isn't byte addressable, if imm == 0 or
															   // if sources are zero and imm is -ve as it will make infinite loop

	output = output + 'x' + to_string(rs1) + ',' + 'x' + to_string(rs2) + ",*" + to_string(imm+pc) + "*\n";
}

void ISA::loads(string & output, int& rs1, int& imm, int rd) {

	rs1 = 0;
	do //104 to 228
	{
		imm = (rand() % 125) + 104;
	} while (!mem[imm - 104] || imm % 4 != 0);

	output = output + 'x' + to_string(rd) + ',' + to_string(imm) + '(' + 'x' + to_string(rs1) + ')' + "\n";
}

void ISA::store(string & output, int& rs1, int& rs2, int& imm)
{
	rs1 = 0;
	do
	{
		rs2 = rand() % 32;
	} while (!regs[rs2]);


	do //104 to 228
	{
		imm = (rand() % 125) + 104;
	} while (!mem[imm - 104] || imm % 4 != 0);

	output = output + 'x' + to_string(rs2) + ',' + to_string(imm) + '(' + 'x' + to_string(rs1) + ')' + "\n";
}

void ISA::Rtype(string & output, int& rs1, int& rs2, int rd) {

	do
	{
		rs1 = rand() % 32;
	} while (!regs[rs1]);

	do
	{
		rs2 = rand() % 32;
	} while (!regs[rs2]);
	regs[rd] = true;
	output = output + 'x' + to_string(rd) + ',' + 'x' + to_string(rs1) + ',' + 'x' + to_string(rs2) + "\n";
}

void ISA::fixBranches(string *p)
{
	int index = 0, index2 = 0;
	for (int i = 0; i < 20; i++)
	{
		int power = 1;
		if (instr[i])	//Branch
		{
			size_t f1, f2; int tem = 0;
			f1 = p[i].find('*');
			f2 = p[i].find('*', f1 + 1);
			for (size_t j = f2 - 1; j > f1; j--)
			{
				tem += (int(p[i].at(j)) - 48) * power;
				power *= 10;
			}

			int number = int(f2 - f1 - 1);
			p[i].erase(f1, p[i].size() - f1);
			p[i].replace(f1, number, branch[index2++].name + "\n");

			if (p[tem / 4].at(0) != 'J')
				p[tem / 4] = branch[index++].name + ": " + p[tem / 4];
			else
				p[i].at(p[i].size() - 1) = p[tem/4].at(4);
		}
	}
}
