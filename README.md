<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="web/brand/logo-light.svg">
  <img src="web/brand/logo.svg" alt="PeakCut" height="64">
</picture>

<br><br>

### Long videos in. Ready-to-post clips out.

PeakCut finds the best moments in a video or live stream, cuts them to vertical 9:16<br>
with word-by-word captions and a hook, and can post them for you.<br>
**Free, open source, and it runs on your own computer.**

<br>

[![Latest release](https://img.shields.io/github/v/release/Aniket886/Peak-Cut?style=flat-square&color=2F6BFF&label=release)](https://github.com/Aniket886/Peak-Cut/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-0E1726?style=flat-square)](LICENSE)
![Platform](https://img.shields.io/badge/platform-Windows%20%C2%B7%20macOS%20%C2%B7%20Linux-5A6577?style=flat-square)
![Python](https://img.shields.io/badge/python-3.10%2B-5A6577?style=flat-square)

[**Download for Windows**](https://github.com/Aniket886/Peak-Cut/releases/latest) &nbsp;·&nbsp;
[Website](https://peak-cut-henna.vercel.app) &nbsp;·&nbsp;
[Run from source](#run-from-source) &nbsp;·&nbsp;
[Deploy a server](DEPLOY.md)

<br>

<table>
  <tr>
    <td align="center"><img src="web/brand/demo-hype.jpg" width="200" alt="Hype caption style"><br><sub><b>Hype</b></sub></td>
    <td align="center"><img src="web/brand/demo-bounce.jpg" width="200" alt="Bounce caption style"><br><sub><b>Bounce</b></sub></td>
    <td align="center"><img src="web/brand/demo-clean.jpg" width="200" alt="Clean caption style"><br><sub><b>Clean</b></sub></td>
  </tr>
</table>

</div>

<br>

## Features

|   |   |
|---|---|
| **Finds the moments** | An AI model reads the transcript and picks moments that hold attention, then writes a hook and a title. No AI key? It falls back to loudness (shouting, big reactions). |
| **Captions that move** | Word-by-word captions in three styles, cut to 9:16 and ready for Shorts, Reels and TikTok. |
| **Live clipping** | Press **Go live** on a creator and PeakCut records the stream and clips highlights while it is still running. |
| **Posts for you** | Connect YouTube, Instagram and TikTok, then queue or auto-post with spacing and daily caps. |
| **Private by default** | Speech to text runs on your machine, so audio never leaves it. Your AI key stays in your own data folder. |
| **Bring your own AI** | Gemini, OpenAI, Grok, Groq, OpenRouter, Claude, a local Ollama model, or any OpenAI-compatible address. |

<br>

## Get started

### Windows (recommended)

Nothing else to install. Python and ffmpeg are included.

1. Download **`PeakCut-Setup.exe`** from the [latest release](https://github.com/Aniket886/Peak-Cut/releases/latest).
   Prefer no installer? Take **`PeakCut-Windows.zip`**, extract it and run `PeakCut.exe`.
2. Run it. The installer needs no administrator password.
3. Start **PeakCut** from the Start menu. A black window opens; keep it open while you work and close it to stop.
   The first start downloads the speech model once (about 480 MB), then PeakCut opens at <http://127.0.0.1:8765>.
4. Open **Settings, AI**, paste an AI key (optional), then paste a video link or upload a file.

> [!NOTE]
> Windows may show a blue **SmartScreen** warning because the program is not code-signed yet. Choose **More info**,
> then **Run anyway**.

Your videos, clips and settings live in `%LOCALAPPDATA%\PeakCut\data`. Uninstalling does not delete them.

### Run from source

You need Python 3.10 or newer and `ffmpeg` on your PATH.

**Windows, one step:** double-click [`PeakCut-Setup-and-Run.bat`](PeakCut-Setup-and-Run.bat). It installs Python and
ffmpeg if they are missing, sets everything up and starts PeakCut. If it asks, run it a second time.

**Any system:**

```bash
git clone https://github.com/Aniket886/Peak-Cut.git
cd Peak-Cut
python -m venv .venv
```

Activate the environment (`.venv\Scripts\activate` on Windows, `source .venv/bin/activate` on Mac and Linux), then:

```bash
pip install -r requirements.txt
python -m studio.fetch_model
python -m studio.server
```

Open <http://127.0.0.1:8765>. There is no sign-in on your own computer. To start it again later, activate the
environment and run `python -m studio.server`. On Windows, install ffmpeg with `winget install --id Gyan.FFmpeg -e`.

<br>

## How it works

```text
Add a video  →  Download  →  Transcribe  →  Pick moments  →  Render  →  Review  →  Save or post
 (link/file)    (yt-dlp)    (on your PC)   (AI or loudness)  (ffmpeg)   (clips)
```

1. **Add a video.** Paste a YouTube, Twitch or Kick link, or drop in a file. Several videos run at once.
2. **Transcribe.** Speech to text runs locally with `sherpa-onnx` and the Parakeet model.
3. **Pick the moments.** With an AI key, a model chooses the moments and writes hooks and titles. Without one, clips
   are chosen by loudness.
4. **Render.** Each moment is cut to 9:16 with captions.
5. **Review.** Preview, rename or delete clips under **All videos**, or under the creator they belong to.
6. **Save or post.** Download the clips, or post them to connected accounts
   ([one-time setup](DEPLOY.md#connecting-youtube-instagram-and-tiktok)).

Each creator has their own workspace: channels, clip settings, posting rules and an activity log.

<br>

## Choose your AI

The AI is optional. Without a key, clips are chosen by loudness. With one, they are chosen by what is being said,
which is usually better for gameplay and commentary.

The easy way is in the dashboard: **Settings, AI**. Pick the service, paste your key, press **Find models**, then
**Save and test**. The key stays in the data folder on your machine and is never shown again.

| Provider | `PEAKCUT_AI_PROVIDER` | Get a key |
|---|---|---|
| Google Gemini | `gemini` | [aistudio.google.com/apikey](https://aistudio.google.com/apikey) |
| OpenAI | `openai` | [platform.openai.com/api-keys](https://platform.openai.com/api-keys) |
| Grok (xAI) | `xai` | [console.x.ai](https://console.x.ai) |
| Groq | `groq` | [console.groq.com/keys](https://console.groq.com/keys) |
| OpenRouter | `openrouter` | [openrouter.ai/keys](https://openrouter.ai/keys) |
| Claude | `anthropic` | [console.anthropic.com](https://console.anthropic.com) |
| Ollama (local, no key) | `ollama` | [ollama.com](https://ollama.com) |
| Any OpenAI-compatible address | `custom` | also set `PEAKCUT_AI_BASE_URL` |

<details>
<summary><b>Configure with a file instead</b></summary>

<br>

The same settings can go in `.env`. What is saved in the dashboard wins.

```ini
PEAKCUT_AI_PROVIDER=gemini
PEAKCUT_AI_MODELS=gemini-2.5-flash
PEAKCUT_AI_KEY=your-key-here
```

- `PEAKCUT_AI_MODELS` is the model id exactly as the service names it. Several ids separated by commas are tried in
  order, which gives you a fallback.
- A fast, inexpensive model is the right choice. A one-hour video is read in about four requests.
- You pay the AI service directly. The **AI usage** page shows the requests and tokens each video took.

</details>

<br>

## Settings

Everything is set through environment variables, normally in a `.env` file next to this README.
[`.env.example`](.env.example) lists every setting with a short explanation. The ones that matter first:

| Setting | What it is for |
|---|---|
| `PEAKCUT_AI_PROVIDER`, `PEAKCUT_AI_MODELS`, `PEAKCUT_AI_KEY` | The AI that picks clips and writes titles (or set it in the dashboard) |
| `PEAKCUT_ACCOUNTS` | `1` makes everyone sign in. Use it on any server other people can reach |
| `PEAKCUT_DATA` | Where videos, clips and the database are kept (default `./data`) |
| `PEAKCUT_REPO_URL`, `PEAKCUT_FOLLOW_URL` | The links at the top of the dashboard. Empty hides a button |
| `PEAKCUT_UPDATE_REPO`, `PEAKCUT_UPDATE_CHECK` | Which repository the update notice watches, and `0` to turn it off |
| `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` | Optional: Sign in with Google, and connecting YouTube |
| `PEAKCUT_SMTP_*`, `PEAKCUT_MAIL_FROM` | Optional: confirmation and password emails |

`.env`, the `secrets/` folder and all user data are ignored by git. Keep keys there, never in the code.

<br>

## Under the hood

| Part | What it is |
|---|---|
| `studio/` | The server: FastAPI, the clip pipeline, live recording, accounts |
| `studio/ai.py` | The only file that talks to an AI service. Add a provider here |
| `web/` | The pages: landing, sign-in, the app, the admin dashboard (plain HTML, CSS and JavaScript, no build step) |
| `launcher/` | The Windows program and installer: PyInstaller build, Inno Setup script, icon |
| `site/` | The download website, deployed to Vercel |
| `tests/` | Tests that run against a throwaway copy of the app |
| `deploy/`, `Dockerfile`, `docker-compose.yml` | One-server deployment with PostgreSQL and automatic HTTPS |

Video work is done with `ffmpeg` and `yt-dlp`. Data is kept per user: accounts in the database (SQLite on your own
computer, PostgreSQL on a server), videos and clips in each user's own folder. [AGENTS.md](AGENTS.md) is a short map
of the code for contributors.

<details>
<summary><b>Admins and load handling</b></summary>

<br>

**Admins.** Only matters with accounts on (`PEAKCUT_ACCOUNTS=1`); without them you are the owner. Grant a role on the
machine that runs PeakCut: `python -m studio.admin grant you@example.com` (`revoke` and `list` work the same way).
The admin dashboard is at `/admin`.

**Under load.** Each person's videos wait in their own line and the lines take turns. The server measures its own
processor, memory and disk, and starts extra videos and recordings only while there is room. There are no limits on
upload size, video length or storage unless you set them in `.env`.

</details>

<details>
<summary><b>Design system</b></summary>

<br>

A light, quiet interface: colour is kept for actions and state, and everything else stays neutral.

| Token | Value | Used for |
|---|---|---|
| Ink | `#0E1726` | Text, headings, dark panels |
| Accent (cobalt) | `#2F6BFF` | Buttons, active tabs, charts, focus |
| Accent soft | `#EEF3FF` | Banners, selected rows, icon chips |
| Canvas | `#F2F4F7` | Sidebar and page frame |
| Surface | `#FFFFFF` | The main work area |
| Line | `#E8EBF0` | Borders and dividers |

- **Type:** Geist for the interface, with slightly tightened headings.
- **Logo:** a peak with a cut through it, next to a Poppins ExtraBold wordmark. Files are in `web/brand/`.
- **Themes:** the colours are variables at the top of each page (`--brand`, `--frame`, `--text`, ...), so a new theme
  is a small edit.

</details>

<br>

## Deploy a server

[DEPLOY.md](DEPLOY.md) walks through a single Linux server with Docker: the app, PostgreSQL, and Caddy for HTTPS.

```bash
docker compose up -d --build
```

## Build the Windows installer

```powershell
powershell -ExecutionPolicy Bypass -File launcher\build.ps1
```

This makes `dist\PeakCut-Windows.zip`, and `dist\PeakCut-Setup.exe` when [Inno Setup](https://jrsoftware.org/isinfo.php)
is installed. It needs `ffmpeg` and `ffprobe` on your PATH.

## Tests

```bash
python tests/run.py
```

This starts a copy of the app on a spare port with an empty temporary data folder, runs the tests, then removes it.
It needs no keys and never touches real data. On Windows, set `PYTHONUTF8=1` first so the Hindi and Urdu caption test
can print its results.

<br>

## Security

- With sign-in off, PeakCut listens on this computer only (`127.0.0.1`) and refuses changes sent by other websites.
  Do not expose it to the internet that way: turn accounts on.
- Passwords are stored only as salted scrypt hashes. Sessions are random tokens stored hashed; cookies are HTTP-only.
- Every route works out who is asking from the session, never from the request, so users only reach their own data.
- Only known video sites are fetched, and text from videos is treated as data when it is shown to the AI.
- Found a problem? Report it privately through the repository's security advisories instead of a public issue.

## Use it responsibly

Clip videos you made, or have permission to use. You are responsible for the rights to what you download, clip and
post, and for following the terms of the sites you fetch from and post to. Game footage and trailers often belong to
the publisher, so check their content policy before you post clips.

## Credits and license

PeakCut is maintained by [Aniket886](https://github.com/Aniket886). It is a fork of
[PeakCut](https://github.com/haziqahmedqasmi/PeakCut) and is released under the [MIT license](LICENSE). The original
copyright notice is kept, as the license requires, and a line for this fork's changes is added.

**What this fork changes:** the look (a cobalt and slate colour scheme, a light sidebar and a new logo), the project
links and update check (they point to this repository), the Windows app and installer, and the removal of the original
author's "Follow me" button. The clip pipeline, live recording, accounts and everything else are the original
project's work.

Caption fonts in `studio/fonts/` (Anton, Archivo Black, Poppins) are under the SIL Open Font License; the license
texts are in the same folder.
