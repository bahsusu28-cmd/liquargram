@echo off
setlocal

echo ========================================
echo Building Dependencies ONLY
echo This takes 1-2 hours but only once!
echo ========================================
echo.
echo You can minimize this window and do other stuff.
echo It will beep when done.
echo.
pause

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" -vcvars_ver=14.44

cd Telegram\build\prepare
call win.bat

if errorlevel 1 (
    echo.
    echo ERROR: Failed to build dependencies
    echo.
    pause
    exit /b 1
)

cd ..\..\..

echo.
echo ========================================
echo DEPENDENCIES BUILT!
echo ========================================
echo.
echo Now run: ultra_quick_build.bat
echo It will take only 5-10 minutes!
echo.
echo [BEEP]
powershell -c "[console]::beep(1000,500)"
pause
