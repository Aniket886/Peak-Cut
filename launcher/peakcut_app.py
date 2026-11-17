"""PeakCut for Windows: the one program people double-click.

It keeps everything in the user's own folder (%LOCALAPPDATA%\\PeakCut), finds the ffmpeg that ships with it,
downloads the speech model the first time, starts PeakCut and opens it in the browser. Closing the window stops it.

Run it from source with:  python launcher/peakcut_app.py
"""
import os
import socket
import sys
import threading
import time
import webbrowser
from pathlib import Path

FROZEN = getattr(sys, "frozen", False)
HERE = Path(sys.executable).parent if FROZEN else Path(__file__).resolve().parent.parent
HOME = Path(os.environ.get("LOCALAPPDATA") or Path.home()) / "PeakCut"
PORT = int(os.environ.get("PEAKCUT_PORT") or "8765")


def say(text=""):
    print(text, flush=True)


def is_open(port):
    with socket.socket() as s:
        s.settimeout(0.5)
        return s.connect_ex(("127.0.0.1", port)) == 0


def prepare():
    HOME.mkdir(parents=True, exist_ok=True)
    os.environ.setdefault("PEAKCUT_DATA", str(HOME / "data"))
    os.environ.setdefault("PEAKCUT_PORT", str(PORT))
    os.environ.setdefault("PEAKCUT_HOST", "127.0.0.1")
    os.environ.setdefault("PEAKCUT_ACCOUNTS", "0")        # one person, one computer: no sign-in
    # ffmpeg and ffprobe sit in a "bin" folder next to this program
    for b in (HERE / "bin", HERE / "_internal" / "bin"):
        if b.exists():
            os.environ["PATH"] = str(b) + os.pathsep + os.environ.get("PATH", "")
    # settings (an AI key, for example) can be put in  %LOCALAPPDATA%\PeakCut\.env
    f = HOME / ".env"
    if f.exists():
        for line in f.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))


def open_when_ready(url):
    for _ in range(120):
        if is_open(PORT):
            webbrowser.open(url)
            return
        time.sleep(0.5)


def main():
    url = f"http://127.0.0.1:{PORT}"
    say("PeakCut\n=======")
    if is_open(PORT):
        say("PeakCut is already running. Opening it in your browser.")
        webbrowser.open(url)
        return
    prepare()
    from shutil import which
    if not which("ffmpeg"):
        say("ffmpeg was not found. Reinstall PeakCut, or install ffmpeg and try again.")
        input("Press Enter to close.")
        return
    from studio import fetch_model
    try:
        fetch_model.main()                                   # downloads the speech model once (about 480 MB)
    except Exception as e:                                   # no internet, or the download was cut off
        say(f"\nCould not download the speech model: {e}\nCheck your internet connection and start PeakCut again.")
        input("Press Enter to close.")
        return
    say(f"\nStarting PeakCut at {url}\nYour videos and clips are kept in {HOME / 'data'}")
    say("Keep this window open while you use PeakCut. Close it to stop.\n")
    threading.Thread(target=open_when_ready, args=(url,), daemon=True).start()
    from studio import server
    server.main()


if __name__ == "__main__":
    main()
