/*-----------------------------------------------------------------------
 * TcNo-Transcoder Queue Manager
 * For managing TcNo-Transcoder Queue (Adding new jobs via context menu)
 * Created by TechNobo (Wesley Pyburn): https://tcno.co/
 * GitHub Repo: https://github.com/TcNobo/TcNo-Transcoder
 *----------------------------------------------------------------------- */
#include <fstream>

int main(int argc, char* argv[])
{
	std::ofstream outF;
	std::string ex = argv[0];
	
	outF.open(ex.substr(0, ex.find_last_of('\\') + 1)+"queue.txt", std::ofstream::app);
	for (int i = 1; i < argc; ++i)
		outF << argv[i] << '\n';
	return 0;
}