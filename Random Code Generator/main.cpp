#include <iostream>
#include "ISA.h"
using namespace std;
int main() {

    string *p;
    ISA test;
    test.getRandom(5,p);

    for(int i = 0; i < 5; i++)
        cout << p[i] << endl;

    return 0;
}