//
// Created by Oba on 09/03/17.
//
#include <cstring>
#include "ISA.h"

ISA::ISA() {
    this-> pc = 0;
    memset(regs,false,sizeof(regs));
    regs[0] = true;
    memset(mem,false,sizeof(mem));

    Instr LUI("rd imm","LUI");                              list.push_back(LUI);    pc0.push_back(LUI);
    Instr AUIPC("rd imm","AUIPC");                          list.push_back(AUIPC);  pc0.push_back(AUIPC);

    Instr JAL("rd imm","JAL");                              list.push_back(JAL);    pc0.push_back(JAL);
    Instr JALR("rd rs1 imm","JALR");                        list.push_back(JALR);   pc0.push_back(JALR);
    Instr BEQ("rs1 rs2 imm","BEQ");                         list.push_back(BEQ);
    Instr BNE("rs1 rs2 imm","BNE");                         list.push_back(BNE);
    Instr BLT("rs1 rs2 imm","BLT");                         list.push_back(BLT);
    Instr BGE("rs1 rs2 imm","BGE");                         list.push_back(BGE);
    Instr BLTU("rs1 rs2 imm", "BLTU");                      list.push_back(BLTU);
    Instr BGEU("rs1 rs2 imm", "BGEU");                      list.push_back(BGEU);
    Instr LB("rd rs1 imm","LB");                            list.push_back(LB);
    Instr LH("rd rs1 imm","LH");                            list.push_back(LH);
    Instr LW("rd rs1 imm","LW");                            list.push_back(LW);
    Instr LBU("rd rs1 imm","LBU");                          list.push_back(LBU);
    Instr LHU("rd rs1 imm","LHU");                          list.push_back(LHU);

    Instr SB("rs1 rs2 imm", "SB");                          list.push_back(SB);     pc0.push_back(SB);
    Instr SH("rs1 rs2 imm", "SH");                          list.push_back(SH);     pc0.push_back(SH);
    Instr SW("rs1 rs2 imm", "SW");                          list.push_back(SW);     pc0.push_back(SW);

    Instr ADDI("rd rs1 imm","ADDI");                        list.push_back(ADDI);   pc0.push_back(ADDI);
    Instr SLTI("rd rs1 imm","SLTI");                        list.push_back(SLTI);   pc0.push_back(SLTI);
    Instr SLTIU("rd rs1 imm","SLTIU");                      list.push_back(SLTIU);  pc0.push_back(SLTIU);
    Instr XORI("rd rs1 imm","XORI");                        list.push_back(XORI);   pc0.push_back(XORI);
    Instr ORI("rd rs1 imm","ORI");                          list.push_back(ORI);    pc0.push_back(ORI);
    Instr ANDI("rd rs1 imm","ANDI");                        list.push_back(ANDI);   pc0.push_back(ANDI);
    Instr SLLI("rd rs1 shamt","SLLI");                      list.push_back(SLLI);   pc0.push_back(SLLI);
    Instr SRLI("rd rs1 shamt","SRLI");                      list.push_back(SRLI);   pc0.push_back(SRLI);
    Instr SRAI("rd rs1 shamt","SRAI");                      list.push_back(SRAI);   pc0.push_back(SRAI);

    Instr ADD("rd rs1 rs2", "ADD");                         list.push_back(ADD);
    Instr SUB("rd rs1 rs2", "SUB");                         list.push_back(SUB);
    Instr SLL("rd rs1 rs2", "SLL");                         list.push_back(SLL);
    Instr SLT("rd rs1 rs2", "SLT");                         list.push_back(SLT);
    Instr SLTU("rd rs1 rs2", "SLTU");                       list.push_back(SLTU);
    Instr XOR("rd rs1 rs2", "XOR");                         list.push_back(XOR);
    Instr SRL("rd rs1 rs2", "SRL");                         list.push_back(SRL);
    Instr SRA("rd rs1 rs2", "SRA");                         list.push_back(SRA);
    Instr OR("rd rs1 rs2", "OR");                           list.push_back(OR);
    Instr AND("rd rs1 rs2", "AND");                         list.push_back(AND);
}

string ISA::getRandom(int number) {
    string output="";
    srand(time(NULL));
    int randIndex;

    for(int i = 0; i < number; i++)
    {
        if(pc == 0)
            output = handlePC0(number);
        else
        {

        }
    }


    //At pc = 0, I can't have the following: branches,shifts,loads,R type

    this->pc += 4;
}

string ISA::handlePC0(int number) {

    srand(time(NULL));
    string output="";
    int randInd;
    randInd = rand() % pc0.size();
    output += pc0[randInd].getKeyword();
    output = output + " ";

    int rd,rs1,rs2,shamt;
    rd = (rand()%31) + 1;    //from reg 1 to reg 31 (because we write) and we have pc 0
    long long imm;
    int maxPC = (number-1) * 4;

    switch(randInd)
    {
            //LUI
        case 0:
            UI(output,imm,rd);
            break;

            //AUIPC
        case 1:
            UI(output,imm,rd);
            break;

            //JAL
        case 2:
            do
            {
                imm = (rand() % (maxPC+1));
            }while((imm % 4) != 0 || (imm == 0)); // do it again if imm isn't word addressable or points to same instruction
            output = output + to_string(rd) + ',' + to_string(imm) + "\n";
            break;

            //JALR
        case 3:
            rs1 = rand() % 32; // from reg 0 to 31
            do
            {
                imm = (rand() % (maxPC+1)); // plus 4 fl akher so we jump to another instruction
            }while((imm % 4) != 0 || (imm == 0));// do it again if imm isn't word addressable or points to same instruction
            output = output + to_string(rd) +',' + to_string(rs1) + ',' + to_string(imm) + "\n";

            //SB
        case 4: rs1 = 0; //all other regs are undefined at this point
            rs2 = 0; //first instruction so src has to be 0
            //TODO: calculate how the immediate is gonna be calculated as the new memory structure
            //temporary assuming memory is from 0 to 31
           imm = rand() % 32;
            break;

            //SH
        case 5:
            rs1 = 0; //all other regs are undefined at this point
            rs2 = 0; //first instruction so src has to be 0
            //TODO: calculate how the immediate is gonna be calculated as the new memory structure
            //temporary assuming memory is from 0 to 31
            imm = rand() % 32;
            break;
            //SW
        case 6:
            rs1 = 0; //all other regs are undefined at this point
            rs2 = 0; //first instruction so src has to be 0
            //TODO: calculate how the immediate is gonna be calculated as the new memory structure
            //temporary assuming memory is from 0 to 31
            imm = rand() % 32;
            break;
            //Addi
        case 7: Itype(output,rs1,imm,pc,false);
            break;
            //slti
        case 8: Itype(output,rs1,imm,pc,false);
            break;
            //sltiu
        case 9: Itype(output,rs1,imm,pc,true);
            break;
            //xori
        case 10:Itype(output,rs1,imm,pc,false);
            break;
            //ori
        case 11:Itype(output,rs1,imm,pc,false);
            break;
            //andi
        case 12:Itype(output,rs1,imm,pc,false);
            break;
            //SLLI
        case 13:shifts(output,rs1,shamt,pc);
            break;
            //srli
        case 14:shifts(output,rs1,shamt,pc);
            break;
            //srai:
        case 15:shifts(output,rs1,shamt,pc);
            break;
    }
    return output;

}

void ISA::Itype(string& output, int&rs1, long long& imm, int pc, bool SLTIU) {

    srand(time(NULL));

    if(!SLTIU)
    imm = (rand() % 8192) - 4096; //from -(2^12) to (2^12 - 1) , if it's signed immediate()
    else
        imm = rand()% 4096; //(2^12)-1

    if(pc == 0)
        rs1 = 0;
    else
    {
        do{
            rs1 = rand() % 32;
        }while(!regs[rs1]); //repeat if we got an empty source
    }

    output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(imm) + "\n";
}

void ISA::shifts(string & output, int &rs1,int &shamt,int pc) {

    shamt = rand() % 32; //from 0 to (2^5)-1
    if(pc == 0)
        rs1 = 0;
    else
    {
        do{
            rs1 = rand() % 32;
        }while(!regs[rs1]); //repeat if we got an empty source
    }

    output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(shamt) + "\n";
}

void ISA::UI(string & output, long long & imm, int rd) {

    imm = (rand() % 1048576) - 524288; //from -(2^19) to (2^19 -1)
    output = output + to_string(rd) + ',' + to_string(imm) + "\n";
}

