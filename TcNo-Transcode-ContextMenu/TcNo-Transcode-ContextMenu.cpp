// TcNo-Transcode-ContextMenu.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <Windows.h>

int main()
{
	/* 
	Folders:
		HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder << MUIVerb << Add to TcNo Transcode Queue
		HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder << SubCommands << TcNoTranscode.add

	Files: 
		HKEY_CLASSES_ROOT\*\shell\TcNo-Transcoder << MUIVerb << Add to TcNo Transcode Queue
		HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder << SubCommands << TcNoTranscode.add

	Background of folder:
		HKEY_CLASSES_ROOT\Directory\Background\shell\TcNo-Transcoder\ << MUIVerb << Start TcNo Transcode Queue
		HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder << SubCommands << TcNoTranscode.start

	Commands:
		HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.add << Add to Queue
		HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.add\command << \"TcNo-Transcoder-Queue.exe\" \"%1\"
		HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.start << Start transcode queue
		HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\TcNoTranscode.start\command << [main program exe] -q
	*/



	HKEY hKey;
	LONG result = 0;
	char filename[] = "C:\test.jpg";
	LPCWSTR path = L"Directory\\shell\\TcNo-Transcoder";
	LPCSTR subkey = "Directory\\shell\\TcNo-Transcoder\\MUIVerb";

	// HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder
	RegCreateKeyEx(HKEY_CLASSES_ROOT, path, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL);

	RegOpenKeyEx(HKEY_CLASSES_ROOT, path, 0, KEY_SET_VALUE, &hKey);
	TCHAR value[] = L"Add to TcNo Transcode Queue";
	RegSetValueEx(hKey, TEXT("MUIVerb"), 0, REG_SZ, (LPBYTE)value, sizeof(value));
	RegCloseKey(hKey);

	RegOpenKeyEx(HKEY_CLASSES_ROOT, path, 0, KEY_SET_VALUE, &hKey);
	TCHAR value[] = L"TcNoTranscode.add";
	RegSetValueEx(hKey, TEXT("SubCommands"), 0, REG_SZ, (LPBYTE)value, sizeof(value));
	RegCloseKey(hKey);




	std::cin;
    std::cout << "Hello World!\n"; 
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
