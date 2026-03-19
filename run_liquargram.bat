@echo off
if exist "Telegram\out\Debug\Telegram.exe" (
    start "" "Telegram\out\Debug\Telegram.exe"
) else if exist "Telegram\out\Release\Telegram.exe" (
    start "" "Telegram\out\Release\Telegram.exe"
) else (
    echo ERROR: Liquargram not built yet!
    echo Run build_liquargram.bat first
    pause
)
