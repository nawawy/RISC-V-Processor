//
// Created by oba on 09/03/17.
//

#ifndef INSTR_H
#define INSTR_H
#include <string>
using namespace std;

class Instr
{
    private:
    string keyword;

    public:
    Instr(string keyword);
    string getKeyword();
    ~Instr();
};

#endif //RISCV32I_RANDOM_TESTCASES_GENERATOR_INSTR_H
