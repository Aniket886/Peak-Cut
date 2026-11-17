@echo off
setlocal
cd /d "%~dp0"
title PeakCut
echo.
echo  PeakCut: one-time setup, then start
echo  ===================================
echo.

rem ---- 1. Python
set "PY="
py -3 --version >nul 2>&1 && set "PY=py -3"
if not defined PY python --version >nul 2>&1 && set "PY=python"
if not defined PY (
    echo Python is not installed. Installing it now...
    winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements
    echo.
    echo Python was installed. Close this window and double-click this file again.
    pause
    exit /b 0
)

rem ---- 2. ffmpeg
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo ffmpeg is not installed. Installing it now...
    winget install -e --id Gyan.FFmpeg --accept-package-agreements --accept-source-agreements
    echo.
    echo ffmpeg was installed. Close this window and double-click this file again.
    pause
    exit /b 0
)

rem ---- 3. Python packages, in a private folder (.venv)
if not exist ".venv\Scripts\python.exe" (
    echo Creating the private Python environment...
    %PY% -m venv .venv
    if errorlevel 1 goto :failed
)
if not exist ".venv\.installed" (
    echo Installing PeakCut's packages. This takes a few minutes the first time...
    ".venv\Scripts\python.exe" -m pip install --upgrade pip
    ".venv\Scripts\python.exe" -m pip install -r requirements.txt
    if errorlevel 1 goto :failed
    echo done> ".venv\.installed"
)

rem ---- 4. Speech model (about 480 MB, only the first time)
".venv\Scripts\python.exe" -m studio.fetch_model
if errorlevel 1 goto :failed

rem ---- 5. Start, and open the browser once it is ready
echo.
echo Starting PeakCut at http://127.0.0.1:8765
echo Keep this window open while you use PeakCut. Close it to stop.
echo.
start "" /min cmd /c "timeout /t 6 /nobreak >nul & start http://127.0.0.1:8765"
".venv\Scripts\python.exe" -m studio.server
pause
exit /b 0

:failed
echo.
echo Something went wrong (see the message above). Check your internet connection and run this file again.
pause
exit /b 1
