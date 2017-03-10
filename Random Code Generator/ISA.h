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
    struct regsfile{
        bool full;
        int data;
    };
    vector<Instr> list;
    vector<Instr> pc0;
    regsfile regs[32];
    bool mem[32];
    int pc;
    

    public:
        ISA();
        void getRandom(int,string*);
        string handlePC0(int);
        void Itype(string&,int&,int&,int,int,bool,int);
        void shifts(string&,int&,int&,int,int,int);
        void UI(string&,int&,int,bool);
        void jumps(string&, int&,int&,int,int,int,bool);
        ~ISA();
};
#endif //RISCV32I_RANDOM_TESTCASES_GENERATOR_ISA_H

/*UI should be completely done {LUI,AUIPC}
jumps should be completely done
Itype should be completely done
shifts should be working but we have a test case not working (low probability fash5 tho enha ttl3)

not sure about the destructor yet*/