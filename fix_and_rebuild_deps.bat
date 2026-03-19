@echo off
setlocal

echo ========================================
echo Fixing Dependencies Build
echo ========================================
echo.

REM Download jom manually with retry
echo Downloading jom (Qt build tool)...
cd ..\ThirdParty

if not exist jom (
    echo Trying alternative download method...
    curl -L -o jom.zip "https://download.qt.io/official_releases/jom/jom_1_1_4.zip"
    
    if errorlevel 1 (
        echo First attempt failed, trying mirror...
        curl -L -o jom.zip "https://github.com/qt-labs/jom/releases/download/v1.1.4/jom_1_1_4.zip"
    )
    
    if errorlevel 1 (
        echo Download failed. Trying with PowerShell...
        powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://download.qt.io/official_releases/jom/jom_1_1_4.zip' -OutFile 'jom.zip'"
    )
    
    if exist jom.zip (
        echo Extracting jom...
        powershell -Command "Expand-Archive -Path jom.zip -DestinationPath jom -Force"
        del jom.zip
        echo jom downloaded successfully!
    ) else (
        echo ERROR: Could not download jom
        echo.
        echo Please check your internet connection and try again.
        cd ..\liquargram
        pause
        exit /b 1
    )
)

cd ..\liquargram

echo.
echo Resuming dependencies build...
echo.
pause

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" -vcvars_ver=14.44

cd Telegram\build\prepare
call win.bat

if errorlevel 1 (
    echo.
    echo ERROR: Build still failed
    echo.
    echo Try running this again, or use GitHub Actions instead.
    cd ..\..\..
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
echo.
powershell -c "[console]::beep(1000,500)"
pause
