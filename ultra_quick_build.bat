@echo off
setlocal

echo ========================================
echo Liquargram ULTRA QUICK BUILD
echo Using system packages (EXPERIMENTAL)
echo ========================================
echo.

REM Initialize Visual Studio
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" -vcvars_ver=14.44
if errorlevel 1 (
    echo ERROR: Failed to initialize Visual Studio
    pause
    exit /b 1
)

REM Clean old cache if exists
if exist "Telegram\out" (
    echo Cleaning old build cache...
    rmdir /s /q Telegram\out
)

REM Try to use vcpkg or system libraries
echo Attempting to use system libraries...
cd Telegram

python configure.py x64 ^
    -D TDESKTOP_API_ID=94575 ^
    -D TDESKTOP_API_HASH=a3406de8d171bb422bb6ddf3bbd800e2 ^
    -D DESKTOP_APP_USE_PACKAGED=ON ^
    -D DESKTOP_APP_USE_PACKAGED_LAZY=ON

if errorlevel 1 (
    echo.
    echo System libraries approach failed.
    echo Falling back to standard build...
    echo.
    python configure.py x64 ^
        -D TDESKTOP_API_ID=94575 ^
        -D TDESKTOP_API_HASH=a3406de8d171bb422bb6ddf3bbd800e2
    
    if errorlevel 1 (
        echo ERROR: Configuration failed
        echo You need to build dependencies first.
        echo Run: setup_dependencies.bat
        cd ..
        pause
        exit /b 1
    )
)

echo.
echo Building...
cmake --build out --config Debug --target Telegram

if errorlevel 1 (
    echo.
    echo Build failed. You probably need to build dependencies.
    echo Run: setup_dependencies.bat
    cd ..
    pause
    exit /b 1
)

cd ..
echo.
echo ========================================
echo SUCCESS!
echo ========================================
echo.
echo Run: run_liquargram.bat
pause
