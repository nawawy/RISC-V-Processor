//
// Created by oba on 09/03/17.
//

#ifndef ISA_H
#define ISA_H

#include <vector>
#include <time.h>
#include <cstring>
#include <string>
#include "Instr.h"
class ISA
{
private:

	struct brch {
		string name;
		int addr;
	};
	brch branch[20];
	vector<Instr> list;
	vector<Instr> pc0;
	bool regs[32];
	bool instr[20];
	bool mem[128];
	int pc,instrInd;
	string handlePC0(int);
	string handleRest(int, int);
	void Itype(string&, int&, int&, int, int, bool);
	void shifts(string&, int&, int&, int, int);
	void UI(string&, int&, int);
	void jumps(string&, int&, int&, int, int, int, bool);
	void branches(string&, int&, int&, int&, int, int);
	void loads(string&, int&, int&, int);
	void store(string&, int&, int&, int&);
	void Rtype(string&, int&, int&, int);
	void fixBranches(string*);


public:
	ISA();
	void getRandom(int, string*);
	~ISA();
};
#endif //RISCV32I_RANDOM_TESTCASES_GENERATOR_ISA_H
