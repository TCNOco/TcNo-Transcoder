@ECHO OFF
setlocal enableExtensions disableDelayedExpansion
title TechNobo's Transcoder - NVEncC
:start
::---------------------------------------
:: ------------ VARIABLE DEF ------------
::---------------------------------------
:: CD to .bat location
cd /d "%~dp0"
:: Load variables
CALL settings.bat
:: Static variables. DO NOT EDIT
SET batVer=1.1
SET nvenccVer=4.31
SET minNV=418.81

:: Checking if 32 or 64 bit, if not set prior.
IF NOT DEFINED bit (
    REG Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || SET OS=64BIT
    IF %OS%==32BIT SET bit=32
    IF %OS%==64BIT SET bit=64
)

:: Setting executable to the correct version
IF "%bit%"=="32" (set nvexe=NVEncC.exe) ELSE (set nvexe=NVEncC64.exe)
CD x%bit%
::---------------------------------------


::---------------------------------------
:: ------------- ARGUMENTS -------------
::---------------------------------------
:: Checks for arguments, like -h or --help
IF "%~1"=="-h" (goto help)
IF "%~1"=="--help" (goto help)
IF "%~1"=="-i" (goto info)
IF "%~1"=="--info" (goto info)
:: Show welcome screen
GOTO :welcome
:welcomeReturn

:: Checks if a file (or multiple files) were dragged onto the .bat
:: They will be processed instantly, without further warning than "Do you wish to continue?"
:: If you're going to do this, test the settings beforehand, but running this .bat, and following the steps with 1 file.
:: If you are happy with the results, then feel free to continue.
IF [%1]==[] GOTO :skip
ECHO ATTENTION!
ECHO Dragging files in will process them INSTANTLY using the settings in settings.bat!
ECHO.
ECHO The following files will be processed:
ECHO %*
ECHO.
set /p sure="Are you sure you wish to continue? (y/n): "

IF "%sure%"=="y" ( GOTO :processMulti ) ELSE ( GOTO :multiCancel )
::---------------------------------------


::---------------------------------------
:: ------------- NORMAL USE -------------
::---------------------------------------
:: If no arguments were added, the program will start here
:skip

SET /p inF="Drag and Drop input file into here: "
ECHO.
:: Sets outF to the output file, with the format defined in settings.bat
IF DEFINED outFLD (goto :FolderGiven) ELSE (goto :NoFolderGiven)
:fgReturn

:: Enter respective version's folder.
ECHO Using NVEncC x%bit%
ECHO The file will save to: %outF%
ECHO If you want it saved to a new directory, exit, and set it in settings.bat.
PAUSE
ECHO.
ECHO %inF% will render with the current settings:
ECHO Resolution: %res%
ECHO FPS: %fps%
ECHO Codec: %codec%
ECHO.
ECHO This command will be run:
ECHO.

:: Sets string that it will run
GOTO :setStr
:setStrReturn

echo %comStr%

echo.
echo.
:: Checks that the user is comfortable running the command
SET /p corr="Is this correct? (y/n): "
IF "%corr%"=="y" (%comStr%)
IF "%corr%"=="n" (echo Stopped.)

:: Goes back a folder (if run from command line) so user doesn't have to navigate themselves.
CD ../
ECHO.
ECHO.
GOTO :thanks
:thanksReturn
ECHO.
:: Loops back to the start of the program
GOTO :start
::---------------------------------------


::---------------------------------------
:: ------------ HELP & INFO ------------
::---------------------------------------
:help
    cls
    ECHO Hello.
    ECHO Welcome to TechNobo's Video Transcoder %batVer%
    ECHO built for generating Proxy files with multitrack audio quickly.
    ECHO.
    ECHO ---------------------------------------
    ECHO.
    ECHO BASIC USAGE:
    ECHO Edit run.bat with a text editor to manually set variables at the top.
    ECHO.
    ECHO ---------------------------------------
    ECHO.
    ECHO INFORMATION OPTIONS:
    ECHO -h, --help            Displays this help INFORMATION
    ECHO -i, --info            Displays program & author info
    ECHO.
    ECHO ---------------------------------------
    ECHO.
    ECHO TROUBLESHOOTING:
    ECHO - Make sure you're using the most updated Nvidia drivers. The project currently uses NVEncC version %nvenccVer%. Make sure you're using Nvidia graphics driver %minNV% or later.
    ECHO.
    ECHO.
    ECHO.
    ECHO For far more information, check the TcNo Transcoder Wiki https://github.com/TcNobo/TcNo-Transcoder/wiki
GOTO :eof

:info
    cls
    ECHO Hello.
    ECHO Welcome to TechNobo's Video Transcoder %batVer%
    ECHO built for generating Proxy files with multitrack audio quickly.
    ECHO.
    ECHO ---------------------------------------
    ECHO.
    ECHO This project is Open-Source, licensed under GPL-3.0
    ECHO You can see what's going on under the hood, or contribute here:
    ECHO GitHub: https://GitHub.com/TcNobo/TcNo-Transcoder
    ECHO.
    ECHO -------------------------------
    ECHO Created with love from TechNobo
    ECHO -------------------------------
    ECHO Instagram: https://www.instagram.com/TcNobo/
    ECHO Twitter: https://twitter.com/TcNobo
    ECHO YouTube: https://YouTube.com/TechNobo
    ECHO Web: https://tcno.co/
    ECHO.
    ECHO.
    ECHO Happy transcoding :)

GOTO :eof
::---------------------------------------


::---------------------------------------
:: ------------- FUNCTIONS -------------
::---------------------------------------
:: Sets the output file and folder, depending on whether the user set the output folder, or not.
:: Runs when the output folder is set manually:
:FolderGiven
    for %%f in (%inF%) do set fnW=%%~nf
    set outF=%outFLD%\%fnW%%suf%.%outFM%
IF NOT DEFINED multi (GOTO :fgReturn) ELSE (GOTO :multifgReturn)

:: Runs when the output folder is NOT set manually:
:NoFolderGiven
    FOR %%f IN (%inF%) DO set fn=%%~dpnf
    set outF=%fn%%suf%.%outFM%
IF NOT DEFINED multi (GOTO :fgReturn) ELSE (GOTO :multifgReturn)

:: Sets the string that the program will run. This is what does all the magic.
:setStr
    IF NOT DEFINED ovrr ( GOTO :noOverride ) ELSE ( GOTO :override )
    :noOverrideReturn
    :overrideReturn

IF NOT DEFINED multi (GOTO :setStrReturn) ELSE (GOTO :multiStrReturn)

:: Setting string when no override defined.
:noOverride
    SET comStr=%nvexe% -i %inf% --%decodemode% --audio-copy --codec %codec% --fps %fps% --output-res %res% --profile %profile% --level %level% --preset %preset% --lookahead %lookahead% --cuda-schedule %cudasch% --%bitrate% --gop-len %GOPLen% --bframes %bframes% --ref %ref% --mv-precision %mvpr% --colormatrix %cm% --output "%outF%"
    IF DEFINED sar (set comStr=%comStr% --sar %sar%)
    IF DEFINED cabac (set comStr=%comStr% --cabac)
    IF DEFINED deblock (
        IF "%deblock%"=="on" (set comStr=%comStr% --deblock)
        IF "%deblock%"=="off" (set comStr=%comStr% --no-deblock)
    )
    IF DEFINED otherargs (set comStr=%comStr% %otherargs%)
GOTO :noOverrideReturn

:: Setting string when override defined
:override
    IF DEFINED otherargs (
        SET comStr=%nvexe% -i %inf% --output "%outF%" %otherargs%
    ) ELSE (
        ECHO.
        ECHO ERROR:
        ECHO No other settings were found in "otherargs".
        ECHO Check your settings and relaunch
        PAUSE
        GOTO :eof
    )
GOTO :overrideReturn
:processMulti
:: Tells :FolderGiven, :NoFolderGiven and :setStr where to return to
SET multi=1

:: Loops through each file dragged onto the .bat
:loop
    ECHO %1
    SET inF=%1
    :: Gets output file and directory
    IF DEFINED outFLD (goto :FolderGiven) ELSE (goto :NoFolderGiven)
    :multifgReturn

    :: Sets string that it will run, and then runs it.
    GOTO :setStr
    :multiStrReturn
    ECHO.
    ECHO PROCESSING:
    ECHO %comStr%
    ECHO.
    ECHO.
    %comStr%
    ECHO.
    ECHO COMPLETE
    ECHO.
    ECHO.
:: Incriments the argument counter then loops if there are more to process.
SHIFT
IF not [%1]==[] GOTO loop
ECHO.
ECHO.
GOTO :thanks
:thanksMultiReturn
PAUSE
GOTO :eof

:multiCancel
    :: Ends file if the user does not wish to continue.
    ECHO Operation cancelled.
    PAUSE
GOTO :eof

:welcome
ECHO Welcome to TechNobo's Video Transcoder %batVer%
ECHO ------------------------
ECHO Run with -h or --help to display help.
ECHO Run with -i or --info to display info.
ECHO ------------------------
ECHO.
GOTO :welcomeReturn

:thanks
ECHO Everything complete.
ECHO Thanks for using TechNobo's Transcoder!
ECHO ---------------------
ECHO GitHub: https://github.com/TcNobo/TcNo-Transcoder
ECHO YouTube: https://YouTube.com/TechNobo
ECHO Web: https://tcno.co/
IF NOT DEFINED multi (GOTO :thanksReturn) ELSE (GOTO :thanksMultiReturn)

::---------------------------------------