@echo off
setlocal

echo ========================================
echo Liquargram Build Script
echo ========================================
echo.

REM Initialize Visual Studio environment
echo [1/4] Initializing Visual Studio 2022 environment...
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" -vcvars_ver=14.44
if errorlevel 1 (
    echo ERROR: Failed to initialize Visual Studio environment
    pause
    exit /b 1
)
echo.

REM Check if dependencies are built
if not exist "..\win64\Libraries" (
    echo [2/4] Building dependencies (this will take 1-2 hours)...
    echo This only needs to be done once!
    cd Telegram\build\prepare
    call win.bat
    if errorlevel 1 (
        echo ERROR: Failed to build dependencies
        cd ..\..\..
        pause
        exit /b 1
    )
    cd ..\..\..
    echo Dependencies built successfully!
) else (
    echo [2/4] Dependencies already built, skipping...
)
echo.

REM Configure project
echo [3/4] Configuring Liquargram...
cd Telegram
python configure.py x64 -D TDESKTOP_API_ID=94575 -D TDESKTOP_API_HASH=a3406de8d171bb422bb6ddf3bbd800e2
if errorlevel 1 (
    echo ERROR: Failed to configure project
    cd ..
    pause
    exit /b 1
)
echo.

REM Build project
echo [4/4] Building Liquargram (Debug mode)...
cmake --build out --config Debug --target Telegram
if errorlevel 1 (
    echo ERROR: Build failed
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
echo Executable location: out\Debug\Telegram.exe
echo.
echo To build Release version (slower but optimized):
echo   cmake --build Telegram\out --config Release --target Telegram
echo.
pause
