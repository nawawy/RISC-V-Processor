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
        string format;
        string keyword;
    public:
        Instr(string,string);
        string getFormat();
        string getKeyword();
        ~Instr();
};

#endif //RISCV32I_RANDOM_TESTCASES_GENERATOR_INSTR_H

//Format isn't used for now, (maybe it won't be used at all)
//Nothing to comment on, too basic