@echo off
:PROMPT
echo ======= FFMPEG VIDEO DOWNLOADER =======
echo === [1] Download from URL           ===
echo === [2] Download from URL (options) ===
echo === [3] Combine audio/video         ===
echo === [a] Analyze URL                 ===
echo === [q] Quit program                ===
echo =======================================
echo:

set /P option="Select an option: "
echo:

if [%option%]==[1] GOTO DOWNLOAD
if [%option%]==[2] GOTO DOWNLOAD_OPTIONS
if [%option%]==[3] GOTO COMBINE
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

:COMBINE
echo === COMBINE AUDIO/VIDEO ===
set /P audio="Enter audio file: "
set /P video="Enter video file: "
echo:
ffmpeg -i "%audio%" -i "%video%" -c:v copy -map 0:v -map 1:a -y output_file.mp4
goto QUIT

:ANALYZE
echo === ANALYZE URL ===
set /P url="Enter a url: "
echo:
ffmpeg -i "%url%"
pause
goto PROMPT

:QUIT
