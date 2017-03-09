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

Instr::Instr(string format, string keyword) {

    this-> format = format;
    this->keyword = keyword;
    //this->ID = ID;
}

Instr::~Instr() {

}

string Instr::getFormat() {
    return this->format;
}

string Instr::getKeyword() {
    return this->keyword;
}

#endif //RISCV32I_RANDOM_TESTCASES_GENERATOR_INSTR_H
