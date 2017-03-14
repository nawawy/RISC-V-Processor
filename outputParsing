#include <fstream>
#include <string>
#include <cstring>
using namespace std;
ifstream gmOut, ourOut;
string regsGM[32];
string regsOur[32];
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
	int count = 0;
	ofstream compareOut;
	gmOut.open("g_result.txt");
	ourOut.open("d_res.txt");
	string empty = "";
	string s;

	for (int i = 0; i < 32; i++)
	{
		regsGM[i] = "";
		regsOur[i] = "";
	}

	getline(gmOut, s);           //"Program Excusion"
	while (1)
	{
		count++;
		parse1();
		parse2();
		for (int i = 0; i < 32; i++)
			if (regsGM[i] != regsOur[i])
				compareOut << "Reg " << i << " is different on testcase " << count << "\n";

		compareOut << "End of case" << count << "\n";
		char a, b;
		a = gmOut.peek();
		b = ourOut.peek();
		if (a == EOF || b == EOF)
			break;
	}

	ourOut.close();
	gmOut.close();
	return 0;
}
