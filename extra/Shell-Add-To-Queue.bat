@ECHO OFF
title TechNobo's Transcoder - Adding file to queue
:: CD to .bat location
cd /d "%~dp0"
:: Set argument to variable, to check if it exists
SET i=%1
:: Adds to queue file
IF DEFINED i ( ECHO %1 >> queue.txt ) ELSE ( GOTO err )
GOto :eof

:err
    :: If the file is run directly, and not from context menu
    ECHO.
    ECHO -------------------------------------
    ECHO Please don't directly run this file.
    ECHO -------------------------------------
    ECHO When 'Add-Send-To.bat' in the previous directory is run, you can Right-Click a file (or files), and 'Add to TcNo Transcode Queue'
    ECHO OR 
    ECHO Run this file as an API. Add a single file as an argument. Example:
    ECHO Shell-Add-To-Queue.bat "D:\Video\Video.mp4"
    ECHO.
    PAUSE
GOTO :eof