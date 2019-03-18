// TcNo-Transcoder-Queue.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

/*-----------------------------------------------------------------------
 * TcNo-Transcoder-Queue
 * For managing TcNo-Transcoder Queue (Adding new jobs via context menu)
 * Created by TechNobo (Wesley Pyburn): https://tcno.co/
 * GitHub Repo: https://github.com/TcNobo/TcNo-Transcoder
 *----------------------------------------------------------------------- */
// There is no need for an ouput.
// The less that is processed, the better.
// Made to be quick and lightweight, hence it's done in C++.

#include <iostream>
#include <fstream>

int main(int argc, char* argv[])
{
	std::ofstream outF;

	outF.open("queue.txt", std::ofstream::app);
	for (int i = 1; i < argc; ++i)
		outF << argv[i] << '\n';
	return 0;
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
