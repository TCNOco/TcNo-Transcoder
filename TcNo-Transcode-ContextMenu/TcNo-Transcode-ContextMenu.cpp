/*---------------------------------------------------------
 * TcNo-Transcoder Context Menu Manager
 * Created by TechNobo (Wesley Pyburn): https://tcno.co/
 * GitHub Repo: https://github.com/TcNobo/TcNo-Transcoder
 *--------------------------------------------------------- */

#include <iostream>
#include <Windows.h>
#include <atlstr.h>
#include <iostream>
#include <strsafe.h>
#include <stdio.h>


int main(int argc, char* argv[])
{
	/*
	---------- STRUCTURE ----------
	Folders:
		HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder << MUIVerb << Add to TcNo Transcode Queue
		HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder << SubCommands << TcNoTranscode.add

	Files:
		HKEY_CLASSES_ROOT\*\shell\TcNo-Transcoder << MUIVerb << Add to TcNo Transcode Queue
		HKEY_CLASSES_ROOT\*\shell\TcNo-Transcoder << SubCommands << TcNoTranscode.add

	Background of folders:
		HKEY_CLASSES_ROOT\Directory\Background\shell\TcNo-Transcoder\ << MUIVerb << Start TcNo Transcode Queue
		HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder << SubCommands << TcNoTranscode.start

	Commands:
		HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.add << Add to Queue
		HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.add\command << \"TcNo-Transcoder-Queue.exe\" \"%1\"
		HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.start << Start transcode queue
		HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.start\command << [main program exe] -q
	-------------------------------
	*/
	// Check whether the computer is 64 or 32 bit. Commands will be added to WOW64 on x64, and won't work in context menu (Not sure why?), but this fixes them.
	// TODO: Test on x32 systems.
	INT16 WinRegType;
	if (IsWow64Process)
		WinRegType = KEY_WOW64_64KEY;
	else
		WinRegType = KEY_WOW64_32KEY;

	// Close program if no arguments supplied
	if (argc != 2) {
		std::cout << "This program is designed to be started from the main TcNo-Transcode program." << std::endl;
		std::cout << "You can launch it manually from the command line by using \"-add\" and \"-remove\"" << std::endl << std::endl;
		system("pause");
		return -1;
	}

	// Check if user wants to add or remove registry entries.
	std::string argument = argv[1];
	if (argument == "-add") {
		TCHAR pBuf[2048];
		// This returns me the fullpath including the .exe 
		GetModuleFileName(NULL, pBuf, 2048);

		// Removes the .exe and tells the program where the other files are (Provided they are there)
		std::wstring pBufW(&pBuf[0]);
		std::string pBufS(pBufW.begin(), pBufW.end());
		pBufS = pBufS.substr(0, pBufS.find_last_of('\\')); // Go from ./*.exe to ./
		std::string QueueManager = pBufS + "\\TcNo-Transcoder-Queue.exe";
		pBufS = pBufS.substr(0, pBufS.find_last_of('\\')); // Go from ./extra/ to ./
		std::string TranscoderExe = pBufS + "\\TcNo-Transcoder.exe";


		std::wstring wQueueManager = std::wstring(QueueManager.begin(), QueueManager.end());
		std::wstring wTranscoderExe = std::wstring(TranscoderExe.begin(), TranscoderExe.end());

		std::string s_ATQCOMM = "\"" + QueueManager + "\" \"%1\"";
		std::string s_SQCOMM = "\"" + TranscoderExe + "\" \"-q\"";


		TCHAR ATQCOMM[2048];
		TCHAR SQCOMM[2048];
		_tcscpy_s(ATQCOMM, CA2T(s_ATQCOMM.c_str()));
		_tcscpy_s(SQCOMM, CA2T(s_SQCOMM.c_str()));


		HKEY hKey;
		LONG result = 0;
		char filename[] = "C:\test.jpg";
		LPCWSTR dirshell = L"Directory\\shell\\TcNo-Transcoder";
		LPCWSTR dirAllShell = L"*\\shell\\TcNo-Transcoder";
		LPCWSTR dirBackground = L"Directory\\Background\\shell\\TcNo-Transcoder";
		LPCWSTR HKLMMSadd = L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\TcNoTranscode.add";
		LPCWSTR HKLMMSstart = L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\TcNoTranscode.start";
		LPCWSTR HKLMMSaddCOM = L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\TcNoTranscode.add\\command";
		LPCWSTR HKLMMSstartCOM = L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\TcNoTranscode.start\\command";

		LPCSTR subkey = "Directory\\shell\\TcNo-Transcoder\\MUIVerb";
		TCHAR TC[] = L"TcNo Transcoder";
		TCHAR STCQ[] = L"Start TcNo Transcode Queue";
		TCHAR TCS[] = L"TcNoTranscode.start";

		TCHAR AddStart[] = L"TcNoTranscode.add;TcNoTranscode.start";

		/*
			----------
			Folders
			----------
		*/
		// HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder
		RegCreateKeyEx(HKEY_CLASSES_ROOT, dirshell, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL);

		RegOpenKeyEx(HKEY_CLASSES_ROOT, dirshell, 0, KEY_SET_VALUE, &hKey);
		RegSetValueEx(hKey, TEXT("MUIVerb"), 0, REG_SZ, (LPBYTE)TC, sizeof(TC));
		RegCloseKey(hKey);

		RegOpenKeyEx(HKEY_CLASSES_ROOT, dirshell, 0, KEY_SET_VALUE, &hKey);
		RegSetValueEx(hKey, TEXT("SubCommands"), 0, REG_SZ, (LPBYTE)AddStart, sizeof(AddStart));
		RegCloseKey(hKey);

		/*
			----------
			Files
			----------
		*/
		// HKEY_CLASSES_ROOT\*\shell\TcNo-Transcoder
		RegCreateKeyEx(HKEY_CLASSES_ROOT, dirAllShell, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL);

		RegOpenKeyEx(HKEY_CLASSES_ROOT, dirAllShell, 0, KEY_SET_VALUE, &hKey);
		RegSetValueEx(hKey, TEXT("MUIVerb"), 0, REG_SZ, (LPBYTE)TC, sizeof(TC));
		RegCloseKey(hKey);

		RegOpenKeyEx(HKEY_CLASSES_ROOT, dirAllShell, 0, KEY_SET_VALUE, &hKey);
		RegSetValueEx(hKey, TEXT("SubCommands"), 0, REG_SZ, (LPBYTE)AddStart, sizeof(AddStart));
		RegCloseKey(hKey);

		/*
			----------
			Background of folders
			----------
		*/
		// HKEY_CLASSES_ROOT\Directory\Background\shell\TcNo-Transcoder
		RegCreateKeyEx(HKEY_CLASSES_ROOT, dirBackground, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL);

		RegOpenKeyEx(HKEY_CLASSES_ROOT, dirBackground, 0, KEY_SET_VALUE, &hKey);
		RegSetValueEx(hKey, TEXT("MUIVerb"), 0, REG_SZ, (LPBYTE)TC, sizeof(TC));
		RegCloseKey(hKey);

		RegOpenKeyEx(HKEY_CLASSES_ROOT, dirBackground, 0, KEY_SET_VALUE, &hKey);
		RegSetValueEx(hKey, TEXT("SubCommands"), 0, REG_SZ, (LPBYTE)TCS, sizeof(TCS));
		RegCloseKey(hKey);

		/*
			----------
			Commands
			----------
		*/
		// HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.add << Add to Queue
		RegCreateKeyEx(HKEY_LOCAL_MACHINE, HKLMMSadd, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE | WinRegType, NULL, &hKey, NULL);
		RegOpenKeyEx(HKEY_LOCAL_MACHINE, HKLMMSadd, 0, KEY_SET_VALUE | WinRegType, &hKey);
		TCHAR ATQ[] = L"Add to Queue";
		RegSetValueEx(hKey, TEXT("MUIVerb"), 0, REG_SZ, (LPBYTE)ATQ, sizeof(ATQ));
		RegCloseKey(hKey);
		// HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.add\command <<  \"TcNo-Transcoder-Queue.exe\" \"%1\"
		RegCreateKeyEx(HKEY_LOCAL_MACHINE, HKLMMSaddCOM, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE | WinRegType, NULL, &hKey, NULL);
		RegOpenKeyEx(HKEY_LOCAL_MACHINE, HKLMMSaddCOM, 0, KEY_SET_VALUE | WinRegType, &hKey);
		RegSetValueEx(hKey, NULL, 0, REG_SZ, (LPBYTE)ATQCOMM, sizeof(ATQCOMM));
		RegCloseKey(hKey);

		// HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.start << Add to Queue
		RegCreateKeyEx(HKEY_LOCAL_MACHINE, HKLMMSstart, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE | WinRegType, NULL, &hKey, NULL);
		RegOpenKeyEx(HKEY_LOCAL_MACHINE, HKLMMSstart, 0, KEY_SET_VALUE | WinRegType, &hKey);
		TCHAR SQ[] = L"Start Queue";
		RegSetValueEx(hKey, TEXT("MUIVerb"), 0, REG_SZ, (LPBYTE)SQ, sizeof(SQ));
		RegCloseKey(hKey);
		// HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.start\command << [main program exe] - q
		RegCreateKeyEx(HKEY_LOCAL_MACHINE, HKLMMSstartCOM, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE | WinRegType, NULL, &hKey, NULL);
		RegOpenKeyEx(HKEY_LOCAL_MACHINE, HKLMMSstartCOM, 0, KEY_SET_VALUE | WinRegType, &hKey);
		RegSetValueEx(hKey, NULL, 0, REG_SZ, (LPBYTE)SQCOMM, sizeof(SQCOMM));
		RegCloseKey(hKey);

		return 0;
	}
	else if (argument == "-remove") {
		HKEY hKey;
		LPCSTR dirshell = "Directory\\shell\\TcNo-Transcoder";
		LPCSTR dirAllShell = "*\\shell\\TcNo-Transcoder";
		LPCSTR dirBackground = "Directory\\Background\\shell\\TcNo-Transcoder";

		LPCWSTR CommandStore = L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\CommandStore\\shell\\";
		LPCSTR CommAdd = "TcNoTranscode.add";
		LPCSTR CommStart = "TcNoTranscode.start";

		BOOL bSuccess;

		RegDeleteTreeA(HKEY_CLASSES_ROOT, dirshell);
		RegDeleteTreeA(HKEY_CLASSES_ROOT, dirAllShell);
		RegDeleteTreeA(HKEY_CLASSES_ROOT, dirBackground);

		RegOpenKeyEx(HKEY_LOCAL_MACHINE, CommandStore, 0, KEY_SET_VALUE | WinRegType, &hKey);
		bSuccess = RegDeleteTreeA(hKey, CommAdd);
		bSuccess = RegDeleteTreeA(hKey, CommStart);
		RegCloseKey(hKey);
		
		return 0;
	}
}