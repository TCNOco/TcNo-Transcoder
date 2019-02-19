@ECHO OFF
setlocal enableExtensions disableDelayedExpansion
title TechNobo's Transcoder - NVEncC

::---------------------------------------------------------
:: TcNo-Transcoder
:: Created by TechNobo: https://tcno.co/
:: GitHub Repo: https://github.com/TcNobo/TcNo-Transcoder
::---------------------------------------------------------

:pgStart
::---------------------------------------
:: ------------ VARIABLE DEF ------------
::---------------------------------------
:: CD to .bat location
cd /d "%~dp0"
:: Load variables
CALL settings.bat
:: Static variables. DO NOT EDIT
SET batVer=1.4
SET nvenccVer=4.31
:: NvencC 4.31 info:
:: - Released: 12/02/2019
:: - GitHub: https://github.com/rigaya/NVEnc/releases
SET minNV=418.81
:: Minimum Nvidia Graphics Driver version
:: Download updates from: https://www.nvidia.com/Download/index.aspx

:: Checking if 32 or 64 bit, if not set prior.
IF NOT DEFINED bit ( GOTO getbit )
:getbitReturn

:: Setting executable to the correct version
IF "%bit%"=="32" (set nvexe=NVEncC.exe) ELSE (set nvexe=NVEncC64.exe)
CD x%bit%
::---------------------------------------


::---------------------------------------
:: ------------- ARGUMENTS -------------
::---------------------------------------
:: Checks for arguments, like -h or --help
IF "%~1"=="-h" ( GOTO help )
IF "%~1"=="--help" ( GOTO help )
IF "%~1"=="-i" ( GOTO info )
IF "%~1"=="--info" ( GOTO info )
IF "%~1"=="-d" ( GOTO devices )
IF "%~1"=="--devices" ( GOTO devices )
IF "%~1"=="-a" ( GOTO audio )
IF "%~1"=="--audio" ( GOTO audio )
IF "%~1"=="-v" ( GOTO video )
IF "%~1"=="--video" ( GOTO video )
:: Show welcome screen
GOTO welcome
:welcomeReturn

:: Checks if a file (or multiple files) were dragged onto the .bat
:: They will be processed instantly, without further warning than "Do you wish to continue?"
:: If you're going to do this, test the settings beforehand, but running this .bat, and following the steps with 1 file.
:: If you are happy with the results, then feel free to continue.
IF [%1]==[] GOTO skip
ECHO ATTENTION!
ECHO Dragging files in will process them INSTANTLY using the settings in settings.bat!
ECHO.
ECHO The following files will be processed:
ECHO %*
ECHO.
set /p sure="Are you sure you wish to continue? (y/n): "

IF "%sure%"=="y" ( GOTO processMulti ) ELSE ( GOTO multiCancel )
::---------------------------------------


::---------------------------------------
:: ------------- NORMAL USE -------------
::---------------------------------------
:: If no arguments were added, the program will start here
:skip

SET /p inF="Drag and Drop input file into here: "
ECHO.
:: Sets outF to the output file, with the format defined in settings.bat
IF DEFINED outFLD ( GOTO FolderGiven ) ELSE ( GOTO NoFolderGiven )
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
GOTO setStr
:setStrReturn

ECHO %comStr%

ECHO.
ECHO.
:: Checks that the user is comfortable running the command
SET /p corr="Is this correct? (y/n): "
IF "%corr%"=="y" (%comStr%)
IF "%corr%"=="n" ( ECHO Stopped. )

:: Goes back a folder (if run from command line) so user doesn't have to navigate themselves.
CD ../
ECHO.
ECHO.
GOTO thanks
:thanksReturn
ECHO.
:: Loops back to the start of the program
GOTO pgStart
::---------------------------------------


::---------------------------------------
:: ------------ HELP + INFO ------------
::---------------------------------------
:help
    CLS
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
    ECHO -h, --help             Displays this help INFORMATION
    ECHO -i, --info             Displays program + author info
    ECHO -d, --devices          Displays available GPUs
    ECHO -a, --audio            Displays available input + output audio codecs/formats
    ECHO -v, --video            Displays available input + output video codecs/formats
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
    CLS
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

:devices
    CLS
    ECHO NOTE:
    ECHO When manually setting: use 0, 1, or any other integer, next to the GPU of your choice 
    ECHO The following GPU's are available for NVEncC transcoding:
    %nvexe% --check-device
GOTO :eof

:audio
    CLS
    ECHO.
    ECHO TechNobo's Video Transcoder
    ECHO ------------------------------------------
    ECHO Listing available audio ENCODERS (output)
    ECHO ------------------------------------------
    ECHO.
    %nvexe% --check-encoders
    ECHO.
    ECHO ------------------------------------------
    ECHO Listing available audio DECODERS (input)
    ECHO ------------------------------------------
    ECHO.
    ECHO.
    %nvexe% --check-decoders
    ECHO.
    ECHO ------------------------------------------
    ECHO Remember to scroll to the top.
    ECHO ABOVE: Audio ENCODERS and then DECODERS.
    ECHO.
    ECHO To see a list of videdo encoders, use -v
    ECHO ------------------------------------------
GOTO :eof

:video
    CLS
    ECHO.
    ECHO TechNobo's Video Transcoder
    ECHO ------------------------------------------
    ECHO.
    %nvexe% --check-formats
    ECHO.
    ECHO ------------------------------------------
    ECHO Remember to scroll to the top.
    ECHO ABOVE: Video Muxers and Demuxers.
    ECHO.
    ECHO  ^|^|  D- : Demuxer (input) ONLY.
    ECHO  ^|^|  -M : Muxer (output) ONLY.
    ECHO  ^|^|  DM : Demuxer and Muxer, both input and output available.
    ECHO.
    ECHO To see a list of audio encoders, use -a
    ECHO ------------------------------------------
GOTO :eof
::---------------------------------------


::---------------------------------------
:: ------------- FUNCTIONS -------------
::---------------------------------------
:: Check if Windows is x32 or x64, unless otherwise specified.
:getbit
REG Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || SET OS=64BIT
    IF %OS%==32BIT SET bit=32
    IF %OS%==64BIT SET bit=64
GOTO getbitReturn
:: Sets the output file and folder, depending on whether the user set the output folder, or not.
:: Runs when the output folder is set manually:
:FolderGiven
    for %%f in (%inF%) do set fnW=%%~nf
    set outF=%outFLD%\%fnW%%suf%.%outFM%
IF NOT DEFINED multi ( GOTO fgReturn ) ELSE ( GOTO multifgReturn )

:: Runs when the output folder is NOT set manually:
:NoFolderGiven
    FOR %%f IN (%inF%) DO set fn=%%~dpnf
    set outF=%fn%%suf%.%outFM%
    IF NOT DEFINED multi ( GOTO fgReturn ) ELSE ( GOTO multifgReturn )

:: Sets the string that the program will run. This is what does all the magic.
:setStr
    IF NOT DEFINED ovrr ( GOTO noOverride ) ELSE ( GOTO override )
    :noOverrideReturn
    :overrideReturn
    IF NOT DEFINED multi  ( GOTO setStrReturn ) ELSE ( GOTO multiStrReturn )

:: Setting string when no override defined.
:noOverride
    SET comStr=%nvexe% -i %inf% --%decodemode% --codec %codec% --fps %fps% --output-res %res% --profile %profile% --level %level% --preset %preset% --lookahead %lookahead% --cuda-schedule %cudasch% --%bitrate% --gop-len %GOPLen% --bframes %bframes% --ref %ref% --mv-precision %mvpr% --colormatrix %cm% --output "%outF%" 
    IF DEFINED audiocopy (set comStr=%comStr% --audio-copy)
    IF DEFINED audiocodec (set comStr=%comStr% --audio-codec %audiocodec%)
    IF DEFINED sar (set comStr=%comStr% --sar %sar%)
    IF DEFINED cabac (set comStr=%comStr% --cabac)
    IF DEFINED deblock ( GOTO deblock )
    :deblockReturn
    IF DEFINED gpu (set comStr=%comStr% --device %gpu%)
    IF DEFINED otherargs (set comStr=%comStr% %otherargs%)
GOTO noOverrideReturn

:: Enables or disables the Deblock flag, if set in settings.bat
:deblock
    IF "%deblock%"=="on" (set comStr=%comStr% --deblock)
    IF "%deblock%"=="off" (set comStr=%comStr% --no-deblock)
GOTO deblockReturn

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
GOTO overrideReturn

:processMulti
    :: Tells :FolderGiven, :NoFolderGiven and :setStr where to return to
    SET multi=1

    :: Loops through each file dragged onto the .bat
    :loop
        :: Checks if it's a folder
        FOR %%i IN (%1) DO IF EXIST %%~si\NUL ( GOTO fldr ) ELSE ( GOTO notFldr )
        :fldr
            :: FOLDER
            SET fld=1
            ECHO ---------------------------
            ECHO Discovering files in folder: %1
            SET i=0
            :: Lists files in folder, and counts
            FOR %%i IN (%1\*.*) DO (
                :: Only runs if it's a file, and not a folder. Only works one folder deep, and doesn't check subfolders, for now. Functionality may be changed later.
                FOR %%f IN (%%i) DO IF NOT EXIST %%~sf\NUL (
                    ECHO -    %%i
                    SET /A i+=1
                )
            )
            ECHO ---------------------------
            ECHO PROCESSING %i% FILES
            ECHO ---------------------------

            :: Processes each file in folder
            FOR %%i IN (%1\*.*) DO ( 
                :: Runs only if it's a file and not a folder.
                FOR %%f IN (%%i) DO IF NOT EXIST %%~sf\NUL ( 
                        SET inF=%%i
                        CALL :processFile 
                    )
            )
            ECHO ---------------------------
            ECHO FOLDER %1 COMPLETE
            ECHO ---------------------------
            GOTO nextArg
        :notFldr
            :: NOT A FOLDER
            SET fld=0
            SET inF=%1
            GOTO processFile
            :processFileReturn
        :nextArg
    :: Incriments the argument counter then loops if there are more to process.
    SHIFT
    IF not [%1]==[] GOTO loop
    ECHO.
    ECHO.
    GOTO thanks
    :thanksMultiReturn
    PAUSE
GOTO :eof

:processFile
    :: Gets output file and directory
    IF DEFINED outFLD ( GOTO FolderGiven) ELSE ( GOTO NoFolderGiven)
    :multifgReturn

    :: Sets string that it will run, and then runs it.
    GOTO setStr
    :multiStrReturn
    ECHO.
    ECHO PROCESSING:
    ECHO %comStr%
    ECHO.
    %comStr%
    ECHO.
    ECHO COMPLETE
    ECHO.
IF "%fld%"=="0" ( GOTO processFileReturn ) ELSE ( exit /b )

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
GOTO welcomeReturn

:thanks
    ECHO Everything complete.
    ECHO Thanks for using TechNobo's Transcoder!
    ECHO ---------------------
    ECHO GitHub: https://github.com/TcNobo/TcNo-Transcoder
    ECHO YouTube: https://YouTube.com/TechNobo
    ECHO Web: https://tcno.co/
IF NOT DEFINED multi ( GOTO thanksReturn ) ELSE ( GOTO thanksMultiReturn )
::---------------------------------------