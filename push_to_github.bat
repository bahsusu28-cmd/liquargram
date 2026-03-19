@echo off
setlocal

echo ========================================
echo Push Liquargram to GitHub
echo ========================================
echo.

REM Check if remote exists
git remote -v | findstr origin >nul
if errorlevel 1 (
    echo No GitHub remote configured!
    echo.
    set /p repo_url="Enter your GitHub repository URL: "
    git remote add origin !repo_url!
)

echo.
echo Adding all changes...
git add .

echo.
set /p commit_msg="Commit message (or press Enter for default): "
if "%commit_msg%"=="" set commit_msg=Update Liquargram

git commit -m "%commit_msg%"

echo.
echo Pushing to GitHub...
git push -u origin main

if errorlevel 1 (
    echo.
    echo ERROR: Push failed!
    echo.
    echo Make sure you:
    echo 1. Created repository on GitHub
    echo 2. Have correct permissions
    echo 3. Configured git credentials
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS!
echo ========================================
echo.
echo Code pushed to GitHub!
echo.
echo Next steps:
echo 1. Go to your repository on GitHub
echo 2. Click "Actions" tab
echo 3. Click "Run workflow" button
echo 4. Wait ~1 hour for build
echo 5. Download .exe from Releases
echo.
pause
