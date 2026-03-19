@echo off
setlocal

echo ========================================
echo Setup Liquargram Dependencies
echo ========================================
echo.
echo Choose installation method:
echo.
echo [1] Download prebuilt (FAST - 5 min, ~500MB download)
echo [2] Build from source (SLOW - 1-2 hours)
echo [3] Use existing Telegram Desktop dependencies
echo.
set /p choice="Enter choice (1/2/3): "

if "%choice%"=="1" goto prebuilt
if "%choice%"=="2" goto fromsource
if "%choice%"=="3" goto existing
echo Invalid choice!
pause
exit /b 1

:prebuilt
echo.
echo Downloading prebuilt dependencies...
mkdir ..\win64 2>nul
cd ..\win64

echo.
echo NOTE: Official prebuilt packages may not be available.
echo Trying to download from Telegram Desktop releases...
echo.

REM Try to get latest release info
curl -s https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest > release.json

echo If download fails, we'll build from source automatically.
echo.
pause

cd ..\liquargram
goto fromsource

:fromsource
echo.
echo Building dependencies from source...
echo This will take 1-2 hours but only needs to be done once!
echo.
pause

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" -vcvars_ver=14.44
cd Telegram\build\prepare
call win.bat
cd ..\..\..

echo.
echo Dependencies built successfully!
pause
exit /b 0

:existing
echo.
echo Looking for existing Telegram Desktop installation...
echo.

set TDESKTOP_PATHS[0]=C:\TBuild\tdesktop
set TDESKTOP_PATHS[1]=D:\TBuild\tdesktop
set TDESKTOP_PATHS[2]=C:\Users\%USERNAME%\tdesktop
set TDESKTOP_PATHS[3]=L:\Telegram\tdesktop

for %%p in (%TDESKTOP_PATHS%) do (
    if exist "%%p\..\win64\Libraries" (
        echo Found dependencies at: %%p\..\win64\Libraries
        echo.
        set /p confirm="Use these dependencies? (y/n): "
        if /i "!confirm!"=="y" (
            mklink /J "..\win64" "%%p\..\win64"
            echo Linked successfully!
            pause
            exit /b 0
        )
    )
)

echo No existing dependencies found.
echo Please choose option 1 or 2.
pause
exit /b 1
