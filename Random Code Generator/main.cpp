#include <iostream>
#include <fstream>
#include "ISA.h"
using namespace std;
int number = 20;
int main() {

	string *p;
	ofstream output;
	output.open("output.txt");
	p = new string[number];
	ISA test;
	test.getRandom(number, p);

	for (int i = 0; i < number; i++)
		output << p[i];
	output << "li a7, 10\n";
	output << "ecall\n";
	system("pause");
	return 0;
}
