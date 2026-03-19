@echo off
setlocal

echo ========================================
echo Liquargram Quick Rebuild
echo ========================================
echo.

REM Initialize Visual Studio environment
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" -vcvars_ver=14.44
if errorlevel 1 (
    echo ERROR: Failed to initialize Visual Studio environment
    pause
    exit /b 1
)

REM Build project
echo Building Liquargram (Debug mode)...
cmake --build Telegram\out --config Debug --target Telegram
if errorlevel 1 (
    echo ERROR: Build failed - files may be locked
    echo.
    echo Please close Telegram.exe and any debugger, then try again.
    pause
    exit /b 1
)

echo.
echo ========================================
echo REBUILD SUCCESSFUL!
echo ========================================
echo.
echo Executable: Telegram\out\Debug\Telegram.exe
echo.
pause
