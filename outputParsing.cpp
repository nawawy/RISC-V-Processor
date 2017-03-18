#include <fstream>
#include <string>
#include <cstring>
using namespace std;
ifstream gmOut, ourOut;
string regsGM[32];
string regsOur[32];
string instructions[22];
void parse1()
{
	string s, temp;
	gmOut.ignore(256, 'A');
	getline(gmOut, s);
	for (int i = 0; i < 32; i++)
	{
		getline(gmOut, s);
		for (int j = s.length() - 8; j < s.length(); j++)
			regsGM[i] += s[j];
	}
	getline(gmOut, s);           //empty line
}
void parse2()
{
	string s; string temp;
	for (int i = 0; i < 32; i++)
	{
		getline(ourOut, s);
		getline(ourOut, temp);
		for (int j = s.length() - 8; j < s.length(); j++)
			regsOur[i] += s[j];
	}
	getline(ourOut, s);						//naw
}
int main()
{
	int count = 0; int index = 0;
    ifstream instr;
	ofstream compareOut;
    instr.open("output.txt");
	gmOut.open("g_result.txt");
	ourOut.open("d_res.txt");
	string empty = "";
	string s;

	for (int i = 0; i < 32; i++)
	{
		regsGM[i] = "";
		regsOur[i] = "";
	}

    while(instr.peek() != EOF)
        getline(instr,instructions[index++]);

	getline(gmOut, s);           //"Program Excusion"
	while (1)
	{
		parse1();
		parse2();
        compareOut << "Case: " << ++count << "\n";
		for (int i = 0; i < 32; i++)
			if (regsGM[i] != regsOur[i])
			{compareOut << instructions[count-1] << "\n"; break;}

		char a, b;
		a = gmOut.peek();
		b = ourOut.peek();
		if (a == EOF || b == EOF)
			break;
	}

	ourOut.close();
	gmOut.close();
    instr.close();
	return 0;
}
