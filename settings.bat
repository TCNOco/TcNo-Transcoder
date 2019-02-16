:: ----------------------------------------------------
:: Welcome to TechNobo's Video Transcoder settings
:: ----------------------------------------------------
:: In here is where all the settings are saved.
:: Edit them here, or set them manually when rendering
:: files, or by using -s or --settings.
:: -----------------------------------------------------

:: ----------------------------------------------------
:: --------------------- REQUIRED ---------------------
:: ----------------------------------------------------
:: Output format
set outFM=mp4

:: Copy the audio?
:: Yes = 1, No = Leave it blank.
:: Converting from WEBM to MP4, with Opus audio causes issues, for example.
set audiocopy=1

:: Audio codec
:: (REQUIRES audiocopy setting above to be BLANK!)
:: To check available encoders, start TcNo-Transcoder.bat with the -a or --audio argument.
:: OR enter either x32 or x64, and run "nvencc --check-encoders" or "NVEncC64 --check-encoders"
set audiocodec=

:: Ouput suffix
:: What goes after the file, just before the extension
:: set suf=_Proxy >> eg: test_Proxy.mp4
set suf=_Proxy

:: Output directory
:: Leave blank to save to the input file's folder.
:: MAKE SURE IT DOES NOT HAVE A TRAILING \ 
:: EG: D:\Proxies
set outFLD=

:: Resolution of the output file.
:: eg. <640x360/1920x1080 etc> 
set res=640x360

:: FPS of the output file.
:: set fps=<24/30/60/120/144 etc>
set fps=60

:: Codec of the output file.
:: set codec=<h264/h265>
:: To check available encoders, start TcNo-Transcoder.bat with the -v or --video argument.
:: OR enter either x32 or x64, and run "nvencc --check-formats" or "NVEncC64 --check-formats"
set codec=h264

:: Output profile
:: H.264: baseline, main, high(default), high444
:: HEVC : main, main10, main444
:: set profile=<baseline/high/main10 etc>
set profile=high

:: Output level
:: - H.264: auto(default), 1, 1b, 1.1, 1.2, 1.3, 2, 2.1, 2.2, 3, 3.1, 3.2, 4, 4.1, 4.2, 5, 5.1, 5.2
:: - HEVC:  auto(default), 1, 2, 2.1, 3, 3.1, 4, 4.1, 5, 5.1, 5.2, 6, 6.1, 6.2
:: set level=<auto/1/4.2/5.1 etc>
set level=auto

:: Encoder preset
:: set preset=<default/performance/quality>
set preset=performance

:: Output depth
:: set outdp=<8/10>
set outdp=8

:: CUDA Schedule
:: set CUDA schedule mode (default: sync).
:: auto: let CUDA driver to decide
:: spin  : CPU will spin when waiting for GPU tasks, will provide the highest performance but with high CPU utilization.
:: yield : CPU will yield when waiting for GPU tasks.
:: sync  : CPU will sleep when waiting for GPU tasks, performance might drop slightly, while CPU utilization will be lower, especially on HW decode mode.
set cudasch=spin

:: Input decode to Hardware or Software
:: avhw: uses libavformat + cuvid for input, this enables full hw transcode and resize.
:: avhw <native/cuda>       Native is default, I find it faster.
:: avsw: uses avcodec + sw decoder, dedcoding input file with software.
::
:: set hwsw=<avhw <native/cuda> / avsw>
set decodemode=avhw native

:: Sample Aspect Ratio
:: set sar=<int>:<int>
:: Leave blank if you won't use it.
set sar=1:1

:: Lookahead
:: Enable lookahead and set lookahead depth (1-32). The default is 16 frames.
set lookahead=16

:: GOP Length
:: Default 0 frames
set GOPLen=0

:: Number of Consecutive B-Frames
:: -h264 default: 3
:: -HEVC default: 0
set bframes=3

:: Number of Reference frames
:: Default 3 frames
set ref=3

:: MV Precision
:: Default: auto
:: Can also be set to:
:: - Q-pel (High Quality)
:: - half-pel
:: - full-pel (Low Quality)
set mvpr=Q-pel

:: Colormatrix
:: Options: undef, auto, bt709, smpte170m, bt470bg, smpte240m, YCgCo, fcc, GBR, bt2020nc, bt2020c
:: cm=<string>
set cm=undef

:: --------------------------
:: ------- h264 ONLY -------
:: --------------------------
:: MAKE SURE TO TURN THESE OFF IF YOU'RE NOT USING h264
:: --------------------------
:: Use CABAC
:: ON: cabac=1
:: OFF: cabac=
set cabac=1

:: Deblock filter
:: ON: deblock: on
:: OFF: deblock: off
:: If you're not using h264, leave it blank!
set deblock=on

:: --------------------------

:: --------------------------
:: ------ VBR SETTINGS ------
:: --------------------------
:: Set the output bitrate/quality
:: cqp <int>                encode in Constant QP Mode
:: cqp <int>:<int>:<int>    encode in Constant QP Mode
:: vbr <int>                set bitrate for VBR mode (kbps)
:: vbrhq <int>              set bitrate for VBR (High Quality) mode (kbps)
:: cbr <int>                set bitrate for CBR mode (kbps)
:: cbrhq <int>              set bitrate for CBR (High Quality) mode (kbps)
set bitrate=cqp 15

:: Set VBR quality (LEAVE BLANK IF NOT USING VBR ABOVE!)
:: target quality for VBR mode (0-51, 0=auto)
:: set vbrq=<NOTHING/0-51>
set vbrq=
:: Set Max Bitrate in kbps
:: set maxbr=<int>
set maxbr=
:: --------------------------




:: ----------------------------------------------------
:: --------------------- OPTIONAL ---------------------
:: ----------------------------------------------------
:: Choose a GPU to use
:: To get a list of GPU's, run the command "NVEncC --check-device" or "NVEncC64 --check-device"
:: MAKE SURE YOU KNOW WHAT GPU YOU'RE SETTING IT TO!
:: Leave this BLANK to let NVEncC choose the best card automatically.
:: set gpu=<int>    eg. set gpu=1
set gpu=

:: set bit=<32/64>    -- Chooses to use 32 or 64 bit Windows. Detects automatically if not set.
set bit=

:: Other arguments. Will be appended to the end of the command that is run.
:: nvencc -arg -arg -arg -[Added Here]
:: eg. set otherargs=--interlace tff --crop 20,20,20,20 
::
:: To see what arguments are available, enter either x32 or x64, and run "nvencc --help" or "NVEncC64 -h"
set otherargs=

:: Override EVERY other setting.
:: Leaves only the input and output file automated. Set everything yourself in otherargs.
:: Set to 1 to enable.
:: LEAVE BLANK FOR OFF (default)
set ovrr=