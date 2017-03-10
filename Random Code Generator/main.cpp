#include <iostream>
#include "ISA.h"
using namespace std;
int main() {

	string *p;
	p = new string[5];
	ISA test;
	test.getRandom(5, p);

	for (int i = 0; i < 5; i++)
		cout << p[i] << endl;

	system("pause");
	return 0;

}
