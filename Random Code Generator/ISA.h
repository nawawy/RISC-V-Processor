//
// Created by oba on 09/03/17.
//

#ifndef ISA_H
#define ISA_H

#include <vector>
#include <time.h>
#include <cstring>
#include "Instr.h"
class ISA
{
private:

	vector<Instr> list;
	vector<Instr> pc0;
	vector<int>indxs;
	vector<int>imms;
	bool regs[32];
	bool mem[128];
	int pc;
	string handlePC0(int);
	string handleRest(int, int);
	void Itype(string&, int&, int&, int, int, bool);
	void shifts(string&, int&, int&, int, int);
	void UI(string&, int&, int);
	void jumps(string&, int&, int&, int, int, int, bool);
	void branches(string&, int&, int&, int&, int, int);
	void loads(string&,int&,int&,int);
	void store(string&, int&, int&, int&);
	void Rtype(string&, int&, int&, int);


public:
	ISA();
	void getRandom(int, string*);
	~ISA();
};
#endif //RISCV32I_RANDOM_TESTCASES_GENERATOR_ISA_H
