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
	getline(ourOut, s);					//instruction
	for (int i = 0; i < 32; i++)
	{
		getline(ourOut, s);
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
	gmOut.open("g_res2.txt");
	ourOut.open("d_res.txt");
	compareOut.open("nawww.txt");
	string empty = "";
	string s;

	while (instr.peek() != EOF)
		getline(instr, instructions[index++]);

	getline(gmOut, s);           //"Program Excusion"
	for (int i = 0; i < 36; i++)
		getline(ourOut, s);	
	while (1)
	{
		for (int i = 0; i < 32; i++)
		{
			regsGM[i] = "";
			regsOur[i] = "";
		}

		parse1();
		parse2();
		compareOut << "Case: " << ++count << "\n";
		for (int i = 0; i < 32; i++)
			if (regsGM[i] != regsOur[i])
			{
				compareOut << instructions[count - 1] << "\n";
				break;
			}

		char a, b;
		a = gmOut.peek();
		b = ourOut.peek();
		if (a == EOF || b == EOF || count == 20)
			break;
	}

	compareOut.close();
	ourOut.close();
	gmOut.close();
	instr.close();
	return 0;
}
