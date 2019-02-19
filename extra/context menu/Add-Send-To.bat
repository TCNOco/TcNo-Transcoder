@ECHO OFF
:: Will run another .bat file, which adds every file selected and "sent" to TcNo-Transcoder into a queue.txt.
:: The user can manually create this, or use this method.
:: The program will be launched right after.

:: CD to .bat location
CD /d "%~dp0"
CD ../
SET curdir=%cd:\=\\%
ECHO ---------------------------------------------------------
ECHO Adding 'Add to TcNo Transcode Queue' to Right-Click menu
ECHO To remove this, run extra\Remove-Send-To.bat
ECHO ---------------------------------------------------------
ECHO Remember to run as Admin, if this fails.
ECHO.
ECHO Adding to registry:
REG ADD "HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder" /ve /t REG_SZ /d "Add to TcNo Transcode Queue" /f
REG ADD "HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder\command" /ve /t REG_SZ /d "\"%curdir%\\Shell-Add-To-Queue.bat\" \"%%1\"" /f
REG ADD "HKEY_CLASSES_ROOT\*\shell\TcNo-Transcoder" /ve /t REG_SZ /d "Add to TcNo Transcode Queue" /f
REG ADD "HKEY_CLASSES_ROOT\*\shell\TcNo-Transcoder\command" /ve /t REG_SZ /d "\"%curdir%\\Shell-Add-To-Queue.bat\" \"%%1\"" /f
ECHO.
ECHO Done!
PAUSE