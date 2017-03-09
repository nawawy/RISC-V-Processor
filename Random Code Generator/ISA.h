//
// Created by oba on 09/03/17.
//

#ifndef ISA_H
#define ISA_H

#include <vector>
#include <time.h>
#include "Instr.h"
class ISA
{
    private:
    vector<Instr> list;
    vector<Instr> pc0;
    bool regs[32];
    bool mem[32];
    int pc;

    public:
        ISA();
        string getRandom(int);
        string handlePC0(int);
        ~ISA();
};
#endif //RISCV32I_RANDOM_TESTCASES_GENERATOR_ISA_H
