@echo off
:PROMPT
echo ======= FFMPEG VIDEO DOWNLOADER =======
echo === [1] Download from URL (m3u8)    ===
echo === [2] Download from URL (options) ===
echo === [3] Download from URL (bitrate) ===
echo === [4] Combine audio/video         ===
echo === [5] Create video snippet        ===
echo === [a] Analyze URL                 ===
echo === [q] Quit program                ===
echo =======================================
echo:

set /P option="Select an option: "
echo:

if [%option%]==[1] GOTO DOWNLOAD
if [%option%]==[2] GOTO DOWNLOAD_OPTIONS
if [%option%]==[3] GOTO DOWNLOAD_BITRATE
if [%option%]==[4] GOTO COMBINE
if [%option%]==[5] GOTO SNIPPET
if [%option%]==[a] GOTO ANALYZE
if [%option%]==[q] GOTO QUIT
echo === Invalid option. Please choose an option from the list. ===
echo:
goto PROMPT

:DOWNLOAD
echo === DOWNLOAD ===
set /P url="Enter a url: "
echo:
ffmpeg -headers "referer: https://emturbovid.com/" -i "%url%" -c copy -bsf:a aac_adtstoasc output_file.mp4
goto QUIT

:DOWNLOAD_OPTIONS
echo === DOWNLOAD WITH OPTIONS ===
set /P url="Enter a url: "
echo:
echo === OPTIONALS ===
echo === To select a program, usually a specific resolution: "-map p:[PROGRAM #]"
echo === To set timestamps: "-ss [HH:MM:SS] -to [HH:MM:SS]"
set /P optionals="Enter optional parameters: "
echo:
ffmpeg -headers "referer: https://emturbovid.com/" -i "%url%" %optionals% -c copy -bsf:a aac_adtstoasc output_file.mp4
goto QUIT

:DOWNLOAD_BITRATE
echo === DOWNLOAD WITH BITRATE ===
set /P url="Enter a url: "
echo:
set /P average bitrate="Enter target bitrate [#Mbps]M: "
echo:
set /P minimum bitrate="Enter minimum bitrate [#Mbps]M: "
echo:
set /P maximum bitrate="Enter maximum bitrate [#Mbps]M: "
echo:
set /P buffer bitrate="Enter buffer size (1-2x max bitrate) [#Mbps]M: "
echo:
ffmpeg -headers "referer: https://emturbovid.com/" -i "%url%" -c:v libx264 -b:v %average% -pass 1 -preset medium -crf 20 -an -f mp4 NUL &&
ffmpeg -i "%url%" -c:v libx264 -b:v %average% -pass 2 -minrate %minimum% -maxrate %maximum% -bufsize %buffer% -c:a copy output_file.mp4
goto QUIT

:COMBINE
echo === COMBINE AUDIO/VIDEO ===
set /P audio="Enter audio file: "
set /P video="Enter video file: "
echo:
ffmpeg -i "%audio%" -i "%video%" -c:v copy -c:a aac -map 0:a:0 -map 1:v:0 output_file.mp4
goto QUIT

:SNIPPET
echo === COMBINE AUDIO/VIDEO ===
set /P video="Enter video file: "
set /P start="Enter start time [HH:MM:SS]: "
set /P end="Enter end time [HH:MM:SS]: "
echo:
ffmpeg -ss %start% -to %end% -i "%video%" -c copy output_file.mp4
goto QUIT

:ANALYZE
echo === ANALYZE URL ===
set /P url="Enter a url: "
echo:
ffmpeg -i "%url%"
pause
echo:
goto PROMPT

:QUIT
