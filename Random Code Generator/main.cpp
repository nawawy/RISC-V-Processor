#include <iostream>
#include "ISA.h"
using namespace std;
int number = 20;
int main() {

    string *p;
    p = new string[number];
    ISA test;
    test.getRandom(number, p);

    for (int i = 0; i < number; i++)
        cout << p[i] << endl;

    system("pause");
    return 0;
}
