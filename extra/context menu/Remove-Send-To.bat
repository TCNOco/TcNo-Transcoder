@ECHO OFF
ECHO ---------------------------------------------------------
ECHO Removing 'Add to TcNo Transcode Queue' from Right-Click menu
ECHO To add it back, run extra\Add-Send-To.bat
ECHO ---------------------------------------------------------
ECHO Remember to run as Admin, if this fails.
ECHO.
ECHO Removing from registry:
REG DELETE "HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder\command" /f
REG DELETE "HKEY_CLASSES_ROOT\directory\shell\TcNo-Transcoder" /f
REG DELETE "HKEY_CLASSES_ROOT\*\shell\TcNo-Transcoder\command" /f
REG DELETE "HKEY_CLASSES_ROOT\*\shell\TcNo-Transcoder" /f
ECHO.
ECHO Done!
PAUSE