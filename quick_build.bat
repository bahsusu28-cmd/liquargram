@echo off
setlocal

echo ========================================
echo Liquargram QUICK BUILD (5-10 min)
echo ========================================
echo.

REM Initialize Visual Studio environment
echo [1/3] Initializing Visual Studio 2022...
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" -vcvars_ver=14.44
if errorlevel 1 (
    echo ERROR: Failed to initialize Visual Studio
    pause
    exit /b 1
)
echo.

REM Download prebuilt dependencies if not exist
if not exist "..\win64\Libraries" (
    echo [2/3] Downloading prebuilt dependencies (~500MB)...
    echo This is MUCH faster than building from source!
    
    mkdir ..\win64 2>nul
    cd ..\win64
    
    echo Downloading Qt and other libraries...
    curl -L -o libraries.zip "https://github.com/desktop-app/tdesktop/releases/download/v5.9.3/tdesktop-5.9.3-full.tar.gz"
    
    if errorlevel 1 (
        echo.
        echo WARNING: Auto-download failed. Building from source instead...
        cd ..\liquargram\Telegram\build\prepare
        call win.bat
        cd ..\..\..\..
    ) else (
        echo Extracting...
        tar -xzf libraries.zip
        del libraries.zip
        cd ..\liquargram
    )
) else (
    echo [2/3] Dependencies already exist, skipping...
)
echo.

REM Configure and build
echo [3/3] Configuring and building Liquargram...
cd Telegram

if not exist "out" (
    python configure.py x64 -D TDESKTOP_API_ID=94575 -D TDESKTOP_API_HASH=a3406de8d171bb422bb6ddf3bbd800e2
    if errorlevel 1 (
        echo ERROR: Configuration failed
        cd ..
        pause
        exit /b 1
    )
)

echo Building Debug version...
cmake --build out --config Debug --target Telegram
if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    echo.
    echo Common fixes:
    echo 1. Close Telegram.exe if it's running
    echo 2. Close Visual Studio if project is open
    echo 3. Try again
    cd ..
    pause
    exit /b 1
)

cd ..
echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo Executable: Telegram\out\Debug\Telegram.exe
echo.
echo Run: run_liquargram.bat
echo.
pause
