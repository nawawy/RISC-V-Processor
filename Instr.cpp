//
// Created by oba on 10/03/17.
//

#include "Instr.h"


Instr::Instr(string keyword) {
    this->keyword = keyword;
}

string Instr::getKeyword() {
    return this->keyword;
}

Instr::~Instr() {

}

