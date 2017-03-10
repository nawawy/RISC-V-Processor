//
// Created by oba on 10/03/17.
//

#include "Instr.h"

Instr::Instr(string format, string keyword) {

    this-> format = format;
    this->keyword = keyword;
    //this->ID = ID;
}

Instr::~Instr() {

}

string Instr::getKeyword() {
    return this->keyword;
}


string Instr::getFormat() {
    return this->format;
}