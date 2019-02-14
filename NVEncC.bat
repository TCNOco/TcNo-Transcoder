@ECHO OFF
:start
:: Load variables
CALL settings.bat
:: Static variables. DO NOT EDIT
SET batVer=1.0
SET nvenccVer=4.31
SET minNV=418.81

:: Checks for arguments, like -h or --help
IF "%~1"=="-h" (goto help)
IF "%~1"=="--help" (goto help)

SET /p inF="Drag and Drop input file into here: "
ECHO.
:: Sets outF to the output file, with the format defined in settings.bat
IF DEFINED outFLD (goto :FolderGiven) ELSE (goto :NoFolderGiven)

:fgReturn


:: Checking if 32 or 64 bit, if not set prior.
IF NOT DEFINED bit (
    REG Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || SET OS=64BIT
    IF %OS%==32BIT SET bit=32
    IF %OS%==64BIT SET bit=64
)

:: Setting executable to the correct version
IF "%bit%"=="32" (set nvexe=NVEncC.exe) ELSE (set nvexe=NVEncC64.exe)

:: Enter respective version's folder.
CD x%bit%
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

SET comStr=%nvexe% -i %inf% --%decodemode% --audio-copy --codec %codec% --fps %fps% --output-res %res% --profile %profile% --level %level% --preset %preset% --lookahead %lookahead% --cuda-schedule %cudasch% --%bitrate% --gop-len %GOPLen% --bframes %bframes% --ref %ref% --mv-precision %mvpr% --colormatrix %cm% --output "%outF%"
IF DEFINED sar (set comStr=%comStr% --sar %sar%)
IF DEFINED cabac (set comStr=%comStr% --cabac)
IF DEFINED deblock (
    IF "%deblock%"=="on" (set comStr=%comStr% --deblock)
    IF "%deblock%"=="off" (set comStr=%comStr% --no-deblock)
)
IF DEFINED otherargs (set comStr=%comStr% %otherargs%)

echo %comStr%

echo.
echo.
SET /p corr="Is this correct? (y/n): "
IF "%corr%"=="y" (%comStr%)
IF "%corr%"=="n" (echo Stopped.)

CD ../
ECHO.
ECHO.
ECHO Program is finished!
GOTO :start

:help
ECHO Hello. Welcome to TechNobo's Video Transcoder %batVer%, built for generating Proxy files with multitrack audio quickly.
ECHO.
ECHO BASIC USAGE:
ECHO Edit run.bat with a text editor to manually set variables at the top.
ECHO.
ECHO INFORMATION OPTIONS:
ECHO -h, --help            Displays this help INFORMATION
ECHO.
ECHO ISSUES RUNNING:
ECHO - Make sure you're using the most updated Nvidia drivers. The project currently uses NVEncC version %nvenccVer%. Make sure you're using Nvidia graphics driver %minNV% or later.
goto :eof

:FolderGiven
    for %%f in (%inF%) do set fnW=%%~nf
    set outF=%outFLD%\%fnW%%suf%.%outFM%
goto :fgReturn

:NoFolderGiven
    FOR %%f IN (%inF%) DO set fn=%%~dpnf
    set outF=%fn%%suf%.%outFM%
goto :fgReturn