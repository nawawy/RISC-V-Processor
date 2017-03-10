//
// Created by Oba on 09/03/17.
//

#include "ISA.h"

ISA::ISA() {
    srand(time(NULL));

    this-> pc = 0;
    memset(regs,false,sizeof(regs));
    regs[0]= true;
    memset(mem,false,sizeof(mem));

    Instr LUI("LUI");                              list.push_back(LUI);    pc0.push_back(LUI);
    Instr AUIPC("AUIPC");                          list.push_back(AUIPC);  pc0.push_back(AUIPC);

    Instr JAL("JAL");                              list.push_back(JAL);    pc0.push_back(JAL);
    Instr JALR("JALR");                            list.push_back(JALR);   pc0.push_back(JALR);

    Instr BEQ("BEQ");                              list.push_back(BEQ);
    Instr BNE("BNE");                              list.push_back(BNE);
    Instr BLT("BLT");                              list.push_back(BLT);
    Instr BGE("BGE");                              list.push_back(BGE);
    Instr BLTU("BLTU");                            list.push_back(BLTU);
    Instr BGEU("BGEU");                            list.push_back(BGEU);

    Instr LB("LB");                                 list.push_back(LB);
    Instr LH("LH");                                 list.push_back(LH);
    Instr LW("LW");                                 list.push_back(LW);
    Instr LBU("LBU");                               list.push_back(LBU);
    Instr LHU("LHU");                               list.push_back(LHU);

    Instr SB("SB");                                  list.push_back(SB);     pc0.push_back(SB);
    Instr SH("SH");                                  list.push_back(SH);     pc0.push_back(SH);
    Instr SW("SW");                                  list.push_back(SW);     pc0.push_back(SW);

    Instr ADDI("ADDI");                               list.push_back(ADDI);   pc0.push_back(ADDI);
    Instr SLTI("SLTI");                               list.push_back(SLTI);   pc0.push_back(SLTI);
    Instr SLTIU("SLTIU");                             list.push_back(SLTIU);  pc0.push_back(SLTIU);
    Instr XORI("XORI");                               list.push_back(XORI);   pc0.push_back(XORI);
    Instr ORI("ORI");                                 list.push_back(ORI);    pc0.push_back(ORI);
    Instr ANDI("ANDI");                               list.push_back(ANDI);   pc0.push_back(ANDI);
    Instr SLLI("SLLI");                               list.push_back(SLLI);   pc0.push_back(SLLI);
    Instr SRLI("SRLI");                               list.push_back(SRLI);   pc0.push_back(SRLI);
    Instr SRAI("SRAI");                               list.push_back(SRAI);   pc0.push_back(SRAI);

    Instr ADD("ADD");                         list.push_back(ADD);
    Instr SUB("SUB");                         list.push_back(SUB);
    Instr SLL("SLL");                         list.push_back(SLL);
    Instr SLT("SLT");                         list.push_back(SLT);
    Instr SLTU("SLTU");                       list.push_back(SLTU);
    Instr XOR("XOR");                         list.push_back(XOR);
    Instr SRL("SRL");                         list.push_back(SRL);
    Instr SRA("SRA");                         list.push_back(SRA);
    Instr OR("OR");                           list.push_back(OR);
    Instr AND("AND");                         list.push_back(AND);
}

void ISA::getRandom(int number, string *p) {
    string output;
    for(int i = 0; i < number; i++)
    {
        if(i == 0)
            output = handlePC0(number);
        else
            output = handleRest(number,i);

        p[i] = output;
        this->pc += 4;
    }
}

string ISA::handlePC0(int number) {

    string output;
    int randInd;
    randInd = rand() % pc0.size();
    output = pc0[randInd].getKeyword();
    output = output + " ";

    int rd,rs1,shamt,imm;
    rd = (rand()%31) + 1;    //from reg 1 to reg 31 (because we write)

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
            jumps(output,imm,rs1,rd,number,pc,false);
            break;
            //JALR
        case 3:
            jumps(output,imm,rs1,rd,number,pc,true);
            break;
            //SB
        /*case 4: rs1 = 0; //all other regs are undefined at this point
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
            break;*/
            //Addi
        case 7: Itype(output,rs1,imm,pc,rd,false);
            break;
            //slti
        case 8: Itype(output,rs1,imm,pc,rd,false);
            break;
            //sltiu
        case 9: Itype(output,rs1,imm,pc,rd,true);
            break;
            //xori
        case 10:Itype(output,rs1,imm,pc,rd,false);
            break;
            //ori
        case 11:Itype(output,rs1,imm,pc,rd,false);
            break;
            //andi
        case 12:Itype(output,rs1,imm,pc,rd,false);
            break;
            //SLLI
        case 13:shifts(output,rs1,shamt,rd,pc);
            break;
            //srli
        case 14:shifts(output,rs1,shamt,rd,pc);
            break;
            //srai:
        case 15:shifts(output,rs1,shamt,rd,pc);
            break;
        default: output = "The instruction selected is store and it isn't implemented yet \n";
    }
    return output;

}

void ISA::Itype(string& output, int&rs1, int& imm, int pc, int rd, bool unsign) {

    if(unsign)
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

    regs[rd] = true;
    output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(imm) + "\n";
}

void ISA::shifts(string & output, int &rs1,int &shamt,int rd, int pc) {

    shamt = rand() % 32; //from 0 to (2^5)-1
    if(pc == 0)
        rs1 = 0;
    else
    {
        do{
            rs1 = rand() % 32;
        }while(!regs[rs1]); //repeat if we got an empty source
    }
    
    regs[rd] = true;

    output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(shamt) + "\n";
}

void ISA::UI(string & output, int & imm, int rd) {

    imm = (rand() % 1048576) - 524288; //from -(2^19) to (2^19 -1)
    output = output + to_string(rd) + ',' + to_string(imm) + " here we have pc as following " + to_string(pc) + "\n";
    //TODO:fix output here
    regs[rd] = true;
}

void ISA::jumps(string & output, int & imm, int& rs1, int rd,int number,int pc,bool jalr) {

    int maxPC = (number-1) * 4;
    int maxOffset = maxPC - pc;
    if(!jalr)
    {
        do
        {
            imm = rand() % (maxOffset+1); //+1 to have maxOffset as an output
        }while(imm % 4 != 0 || imm == 0);
        output = output + to_string(rd) + ',' + to_string(imm) + " here we have pc " + to_string(pc) + "\n"; //TODO OUTPUT
    }
    else
    {
        rs1 = 0;
        do
        {
            imm = rand() % (maxOffset +1);
        }while(imm %4 != 0 || imm == 0);
        output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(imm) + " here we have pc " + to_string(pc) + "\n"; //TODO OUTPUT
    }

}

ISA::~ISA() {

}

string ISA::handleRest(int number, int i) {

    int imm,rd,rs1,rs2,shamt;
    rd = (rand() % 31) + 1;

    string output;
    int randInd;
    if(i == number-1)
        do
        {
            randInd = (int) (rand() % pc0.size());
        }while (randInd == 2 || randInd == 3);      //last instruction cant be JAL or JALR
    else
        randInd = (int) (rand() % pc0.size());

    output = list[randInd].getKeyword();
    output = output + " ";

    switch (randInd)
    {

        case 0: UI(output,imm,rd);    //LUI
            break;
        case 1: UI(output,imm,rd); //AUIPC
            break;
        case 2: jumps(output,imm,rs1,rd,number,pc,false); //JAL
            break;
        case 3: jumps(output,imm,rs1,rd,number,pc,true); //JALR
            break;
        case 4: branches(output,rs1,rs2,imm,pc,number); //BEQ
            break;
        case 5: branches(output,rs1,rs2,imm,pc,number); //BNE
            break;
        case 6: branches(output,rs1,rs2,imm,pc,number); //BLT
            break;
        case 7: branches(output,rs1,rs2,imm,pc,number); //BGE
            break;
        case 8: branches(output,rs1,rs2,imm,pc,number); //BLTU
            break;
        case 9: branches(output,rs1,rs2,imm,pc,number); //BGEU
            break;
        case 10: loads(output); //LB
            break;
        case 11: loads(output); //LH
            break;
        case 12: loads(output); //LW
            break;
        case 13: loads(output); //LBU
            break;
        case 14: loads(output); //LHU
            break;
        case 15: output = "The instruction selected is SB and it isn't implemented yet \n";
            break;
        case 16: output = "The instruction selected is SH and it isn't implemented yet \n";
            break;
        case 17: output = "The instruction selected is SW and it isn't implemented yet \n";
            break;
        case 18: Itype(output,rs1,imm,pc,rd,0);   //addi
            break;
            //slti
        case 19: Itype(output,rs1,imm,pc,rd,1);
            break;
            //sltiu
        case 20: Itype(output,rs1,imm,pc,rd,2);
            break;
            //xori
        case 21:Itype(output,rs1,imm,pc,rd,3);
            break;
            //ori
        case 22:Itype(output,rs1,imm,pc,rd,4);
            break;
            //andi
        case 23:Itype(output,rs1,imm,pc,rd,5);
            break;
            //SLLI
        case 24:shifts(output,rs1,shamt,rd,pc);
            break;
            //srli
        case 25:shifts(output,rs1,shamt,rd,pc);
            break;
            //srai:
        case 26:shifts(output,rs1,shamt,rd,pc);
            break;
        default: Rtype(output,rs1,rs2,rd); //R type
    }
    return output;
}

void ISA::branches(string & output, int &rs1, int &rs2,int& imm, int pc,int number) {

    do{
        rs1 = rand() % 32;
    }while(!regs[rs1]);

    do{
        rs2 = rand() % 32;
    }while(!regs[rs2]);

    int maxPC = (number-1) * 4;
    int maxOffset = maxPC - pc;
    do
    {
        imm = rand() % (maxOffset+1); //+1 to have maxOffset as an output
    }while(imm % 4 != 0 || imm == 0);

    output = output + to_string(rs1) + ',' + to_string(rs2) + ',' + to_string(imm) + " here we have pc " +
             to_string(pc) + "\n"; //TODO OUTPUT
}

void ISA::loads(string & output) {

    //TODO loads
    output = "The instruction selected is load and it isn't implemented yet \n";
}

void ISA::Rtype(string & output, int& rs1, int& rs2, int rd) {

    do
    {
        rs1 = rand() % 32;
    }while(!regs[rs1]);

    do
    {
        rs2 = rand() % 32;
    }while(!regs[rs2]);

    output = output + to_string(rd) + ',' + to_string(rs1) + ',' + to_string(rs2) + " and here the pc is " + to_string(this->pc) + "\n";
}
