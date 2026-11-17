# Builds the Windows program:  dist\PeakCut\PeakCut.exe  and  dist\PeakCut-Windows.zip
# Run from the project folder:  powershell -ExecutionPolicy Bypass -File launcher\build.ps1
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

$py = if (Test-Path ".venv\Scripts\python.exe") { ".venv\Scripts\python.exe" } else { "python" }
& $py -m pip install --quiet pyinstaller -r requirements.txt

# ffmpeg and ffprobe are shipped next to the program
$ff = (Get-Command ffmpeg -ErrorAction SilentlyContinue).Source
$fp = (Get-Command ffprobe -ErrorAction SilentlyContinue).Source
if (-not $ff -or -not $fp) { throw "ffmpeg and ffprobe must be installed and on PATH to build (winget install Gyan.FFmpeg)." }

Remove-Item -Recurse -Force build, dist -ErrorAction SilentlyContinue
& $py -m PyInstaller --noconfirm --clean --name PeakCut --console `
    --collect-submodules uvicorn --collect-submodules studio `
    --collect-all sherpa_onnx --collect-all yt_dlp `
    --add-data "web;web" --add-data "studio\fonts;studio\fonts" `
    launcher\peakcut_app.py
if ($LASTEXITCODE -ne 0) { throw "PyInstaller failed" }

New-Item -ItemType Directory -Force "dist\PeakCut\bin" | Out-Null
Copy-Item $ff, $fp "dist\PeakCut\bin\"
Copy-Item README.md, LICENSE "dist\PeakCut\" -ErrorAction SilentlyContinue

Compress-Archive -Path "dist\PeakCut" -DestinationPath "dist\PeakCut-Windows.zip" -Force
Write-Host "Done: dist\PeakCut-Windows.zip"
