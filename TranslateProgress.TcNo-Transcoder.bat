:: Shows the progress of translation.
:: Lines that have been translated to the new C# codebase will be commented out with ::
:: Lines that don't need to be in C# Will also be commented out.
:: Once everything is commented out, there should be a functioning C# version available, to replace this.
:: Current plans:
:: C#.net 4.6


@ECHO OFF
setlocal enableExtensions enableDelayedExpansion
:: title TechNobo's Transcoder - NVEncC

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
SET batVer=1.5.3
SET nvenccVer=4.31
:: NvencC 4.31 info:
:: - Released: 12/02/2019
:: - GitHub: https://github.com/rigaya/NVEnc/releases
SET minNV=418.81
:: Minimum Nvidia Graphics Driver version
:: Download updates from: https://www.nvidia.com/Download/index.aspx
SET processQueue=false
:: Start time of encode. Leave BLANK
SET startTime=
:: Last file it encoded
SET lastFile=

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
IF "%~1"=="-q" ( GOTO startQueueProcessing )
IF "%~1"=="--queue" ( GOTO startQueueProcessing )
:: Show welcome screen
GOTO welcome
:welcomeReturn


:: Checks if a file (or multiple files) were dragged onto the .bat
:: They will be processed instantly, without further warning than "Do you wish to continue?"
:: If you're going to do this, test the settings beforehand, but running this .bat, and following the steps with 1 file.
:: If you are happy with the results, then feel free to continue.
IF [%1]==[] GOTO skip
:: Check if program will skip this check. For use with Queue
IF NOT EXIST "..\skipcheck" ( GOTO skipFalse )
:: Deletes skipcheck boolean file
DEL "..\skipcheck" /q
SET sure=y
:: Deletes queue, unless otherwise specified (by default)
IF DEFINED delOldQueue ( DEL "..\extra\queue.txt" && GOTO skipcheck) 
:: Get local date and time, to rename queue file
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%-%ldt:~10,2%-%ldt:~12,2%
:: TODO: Remove the milliseconds. Split at ., and keep only the first half
:: Rename old queue file
REN "..\extra\queue.txt" "queue-%ldt%.txt"
GOTO skipcheck

:skipFalse
ECHO ATTENTION!
ECHO Dragging files in will process them INSTANTLY using the settings in settings.bat!
ECHO.
ECHO The following files will be processed:
ECHO %*
ECHO.
set /p sure="Are you sure you wish to continue? (y/n): "

:skipcheck
IF "%sure%"=="y" ( GOTO processMulti ) ELSE ( GOTO multiCancel )
::---------------------------------------


::---------------------------------------
:: ------------- NORMAL USE -------------
::---------------------------------------
:: If no arguments were added, the program will start here
:skip
:: Check if extra/queue.txt exists, and if it does, ask the user if they want to process every file in it.
IF EXIST "../extra/queue.txt" ( GOTO queue )
:queueCancel

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
    ECHO -q, --queue            Instantly start processing your current queue
    ECHO.
    ECHO ---------------------------------------
    ECHO.
    ECHO TROUBLESHOOTING:
    ECHO - Make sure you're using the most updated Nvidia drivers. The project currently uses NVEncC version %nvenccVer%. Make sure you're using Nvidia graphics driver %minNV% or later.
    ECHO.
    ECHO.
    ECHO ---------------------------------------
    ECHO Queue information
    ECHO ---------------------------------------
    ECHO You can queue items, in a .txt file to process them at a later stage, say, overnight.
    ECHO in %cd:~0,-4%\extra\ you can create a 'queue.txt' file, and enter each video on a new line like so:
    ECHO "E:\Videos\Video.mp4"
    ECHO "E:\ToProcess\"
    ECHO (You need the quotation marks)
    ECHO.
    ECHO Then, the next time you run TcNo-Transcoder.bat, you'll be asked if you want to process them.
    ECHO ---- BUT ----
    ECHO The easier way to do this is:
    ECHO Run %cd:~0,-4%\extra\context menu\Add-Send-To.bat
    ECHO To have a "Add to TcNo Transcode Queue" option whenever you right-click a file or folder.
    ECHO (When clicked, it will add them to the .txt file, adding them to the queue)
    ECHO To remove it, just run "Remove-Send-To.bat"
    ECHO.
    ECHO.
    ECHO ---------------------------------------
    ECHO More info
    ECHO ---------------------------------------
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
                    :: Makes sure there's no duplicates
                    IF NOT "!lastFile!"=="%%i" (
                        ECHO -    %%i
                        SET /A i+=1
                        SET lastFile=%%i
                    ) 
                )
            )
            ECHO ---------------------------
            ECHO PROCESSING %i% FILES
            ECHO ---------------------------

            :: Processes each file in folder
            FOR %%i IN (%1\*.*) DO ( 
                :: Runs only if it's a file and not a folder.
                FOR %%f IN (%%i) DO IF NOT EXIST %%~sf\NUL ( 
                    :: Makes sure there's no duplicates
                    IF NOT "!lastFile!"=="%%i" (
                        SET inF="%%i"
                        CALL :processFile 
                        SET lastFile=%%i
                    )
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
    :: Sets and displays the encode start time
    IF NOT DEFINED startTime ( GOTO defStart )
    :defStartReturn

    :: Gets output file and directory
    IF DEFINED outFLD ( GOTO FolderGiven) ELSE ( GOTO NoFolderGiven)
    :multifgReturn

    :: Sets string that it will run, and then runs it.
    GOTO setStr
    :multiStrReturn
    ECHO.
    ECHO PROCESSING:
    :: Print the command that will be run
    ECHO %comStr%
    ECHO.
    :: Run command and Transcode file
    %comStr%
    :: Runs command if user has set one, after completion.
    IF DEFINED afterCompletion ( GOTO afterComplete )
    :afterCompleteReturn
    ECHO.
    ECHO COMPLETE
    ECHO.
IF "%fld%"=="0" ( GOTO processFileReturn ) ELSE ( exit /b )

:: Sets the start encode time, and displays it
:defStart
    SET startTime=%date% %time%
GOTO defStartReturn

:afterComplete
%afterCompletion%
GOTO afterCompleteReturn

:multiCancel
    :: Ends file if the user does not wish to continue.
    ECHO Operation cancelled.
    PAUSE
GOTO :eof

:startQueueProcessing
    SET processQueue=true
GOTO queue

:queue
    :: Return, if the user doesn't want to process it.
    IF "%processQueue%"=="true" ( GOTO skipQq )
    set /p sure="There is a queue. Would you like to process it? (y/n): "
    IF NOT "%sure%"=="y" ( GOTO queueCancel )
    :: User wants to process the queue:
    ECHO --------------------------------------
    ECHO The following files will be processed
    ECHO --------------------------------------
    FOR /F "usebackq tokens=*" %%A in ("../extra/queue.txt") DO ECHO %%A
    ECHO --------------------------------------
    ECHO.
    ECHO You can edit the queue in the TcNo-Transcoder/extra/queue.txt file.
    set /p sure="Do you want to process these files? (y/n): "
    IF NOT "%sure%"=="y" ( GOTO queueStop )
    :: User wants to process the files
    :: Create a new argument string, with all the files in it
    :skipQq
    SET newStr=
    FOR /F "usebackq tokens=*" %%A in ("../extra/queue.txt") DO ( CALL SET "newStr=%%newStr%% %%A" )
    :: Will skip the check when the program is started again
    ECHO 1 > ../skipcheck
    cd ../
    START "" TcNo-Transcoder.bat %newStr%

GOTO :eof

:queueStop
    ECHO.
    ECHO Queue processing cancelled.
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
    ECHO ---------------------
    ECHO Start time: %startTime%
    ECHO Finish time: %date% %time%
    ECHO ---------------------
    ECHO Thanks for using TechNobo's Transcoder!
    ECHO ---------------------
    ECHO GitHub: https://github.com/TcNobo/TcNo-Transcoder
    ECHO YouTube: https://YouTube.com/TechNobo
    ECHO Web: https://tcno.co/
IF NOT DEFINED multi ( GOTO thanksReturn ) ELSE ( GOTO thanksMultiReturn )
::---------------------------------------