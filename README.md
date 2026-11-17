<p align="center">
  <img src="web/brand/logo.svg" alt="Peak Cut" height="56">
</p>

<p align="center">
  Turn long videos and live streams into captioned vertical clips, ready to post.<br>
  Free and open source. Runs on your own computer, with your own AI key (optional).
</p>

---

Paste a YouTube, Twitch or Kick link (or upload a file) and Peak Cut finds the moments worth clipping, cuts them to
9:16, adds word-by-word captions and a hook, and can post them to your connected accounts. It can also record a
creator's live stream and clip the highlights while the stream is still running.

Maintained by [Aniket886](https://github.com/Aniket886). Built on the open source
[PeakCut](https://github.com/haziqahmedqasmi/PeakCut) project (see [Credits](#credits-and-license)).

## Contents

- [How it works](#how-it-works)
- [Download for Windows](#download-for-windows)
- [Quick start (from source)](#quick-start-from-source)
- [Choose your AI](#choose-your-ai)
- [Design](#design)
- [Settings](#settings)
- [How it is built](#how-it-is-built)
- [Deploy](#deploy) · [Tests](#tests) · [Security](#security)
- [Credits and license](#credits-and-license)

## How it works

```
Paste a link or upload  ->  Download  ->  Transcribe  ->  Pick moments  ->  Render  ->  Review  ->  Download or post
      (Home page)          (yt-dlp)     (on your PC)    (AI or loudness)   (ffmpeg)    (clips)
```

1. **Add a video.** Paste a YouTube, Twitch or Kick link on the Home page, or drop in a file. Several videos can run
   at once; each person's videos wait in their own line.
2. **Transcribe.** Speech to text runs on your own machine, so audio never leaves it.
3. **Pick the moments.** With an AI key, a model reads the transcript and chooses moments that would hold a stranger's
   attention, then writes a hook and a title. With no key, clips are picked by loudness instead (shouting, big
   reactions, explosions), which still works but is less precise.
4. **Render.** Each moment is cut to 9:16 with word-by-word captions in one of three styles.
5. **Review.** Clips appear under **All videos**, or under the creator they belong to. Preview, rename or delete them.
6. **Download or post.** Save the clips, or connect YouTube, Instagram and TikTok and queue or auto-post them, with
   spacing and daily caps (one-time setup in [DEPLOY.md](DEPLOY.md#connecting-youtube-instagram-and-tiktok)).

**Live clipping.** Add a creator, press **Go live**, and Peak Cut records the stream into a rolling buffer and clips
highlights as they happen, using loudness, chat activity and the transcript.

**Workspaces per creator.** Each creator has their own channels, clip settings, posting rules and activity log.

## Download for Windows

The easiest way to use PeakCut. Nothing else to install: Python and ffmpeg are included.

1. Go to the [latest release](https://github.com/Aniket886/Peak-Cut/releases/latest) and download
   **PeakCut-Setup.exe** (the installer, recommended) or **PeakCut-Windows.zip** (no install: extract it and run
   `PeakCut.exe`).
2. Run it. If Windows shows a blue SmartScreen warning, choose **More info**, then **Run anyway**. The program is not
   code-signed yet. The installer needs no administrator password.
3. Start **PeakCut** from the Start menu (or run `PeakCut.exe`). A black window opens; keep it open while you use
   PeakCut and close it to stop. The first start downloads the speech model once (about 480 MB), then PeakCut opens
   in your browser at http://127.0.0.1:8765.
4. In **Settings, AI**, paste an AI key (optional, see [Choose your AI](#choose-your-ai)). Then paste a link or
   upload a video.

Your videos, clips and settings are kept in `%LOCALAPPDATA%\PeakCut\data`. Uninstalling does not delete them.

Prefer the source? Double-click `PeakCut-Setup-and-Run.bat`. It installs Python and ffmpeg if they are missing, sets
up everything, and starts PeakCut. Run it a second time if it asks you to.

## Quick start (from source)

You need Python 3.10 or newer and `ffmpeg` on your PATH.

On Windows, install ffmpeg once:

```bash
winget install --id Gyan.FFmpeg -e
```

Then, in the project folder:

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

`fetch_model` downloads the speech model once (about 480 MB). Open http://127.0.0.1:8765. There is no sign-in on your
own computer: it opens straight into the dashboard.

To start it again later, activate the environment and run `python -m studio.server`.

## Choose your AI

The AI is optional. Without a key, clips are chosen by loudness. With one, they are chosen by what is being said,
which is usually better for gameplay and commentary.

The easy way is in the dashboard: **Settings, AI**. Pick the service, paste your key, press **Find models**, then
**Save and test**. The key is kept in the data folder on your machine and is never shown again.

If you prefer a file (or run a server), the same three things can go in `.env`. What is saved in the dashboard wins:

```ini
PEAKCUT_AI_PROVIDER=gemini
PEAKCUT_AI_MODELS=gemini-2.5-flash
PEAKCUT_AI_KEY=your-key-here
```

| `PEAKCUT_AI_PROVIDER` | Service | Where to get a key |
|---|---|---|
| `gemini` | Google Gemini | https://aistudio.google.com/apikey |
| `openai` | OpenAI | https://platform.openai.com/api-keys |
| `xai` | Grok (xAI) | https://console.x.ai |
| `groq` | Groq | https://console.groq.com/keys |
| `openrouter` | OpenRouter (many models, one key) | https://openrouter.ai/keys |
| `anthropic` | Claude | https://console.anthropic.com |
| `ollama` | A model on your own machine, no key | https://ollama.com |
| `custom` | Any OpenAI-compatible address: also set `PEAKCUT_AI_BASE_URL` | |

- `PEAKCUT_AI_MODELS` is the model id exactly as the service names it. Several ids separated by commas are tried in
  order, which gives you a fallback.
- A fast, inexpensive model is the right choice. A one-hour video is read in about four requests.
- You pay the AI service directly. The **AI usage** page shows the requests and tokens each video took.

## Design

Peak Cut has a light, quiet interface: the colour is kept for actions and state, and everything else stays neutral.

| Token | Value | Used for |
|---|---|---|
| Ink | `#0E1726` | Text, headings, dark panels |
| Accent (cobalt) | `#2F6BFF` | Buttons, active tabs, charts, focus |
| Accent soft | `#EEF3FF` | Banners, selected rows, icon chips |
| Canvas | `#F2F4F7` | Sidebar and page frame |
| Surface | `#FFFFFF` | The main work area |
| Line | `#E8EBF0` | Borders and dividers |

- **Type:** Geist for the interface, with slightly tightened headings.
- **Layout:** a light sidebar, a white work area with a hairline border, and large corner radii only on big panels.
- **Logo:** a peak with a cut through it, next to a Poppins ExtraBold wordmark. Files are in `web/brand/`
  (`logo.svg`, `logo-light.svg`, `favicon.svg`, and `logo-email.png` for email apps).
- **Pages** are plain HTML, CSS and JavaScript with no build step. The colours are variables at the top of each page
  (`--brand`, `--frame`, `--text`, ...), so a new theme is a small edit.

## Settings

Everything is set through environment variables, normally in a `.env` file next to this README.
[`.env.example`](.env.example) lists every setting with a short explanation. The ones that matter first:

| Setting | What it is for |
|---|---|
| `PEAKCUT_AI_PROVIDER`, `PEAKCUT_AI_MODELS`, `PEAKCUT_AI_KEY` | The AI that picks clips and writes titles (or set it in the dashboard) |
| `PEAKCUT_ACCOUNTS` | `1` makes everyone sign in. Use it on any server other people can reach |
| `PEAKCUT_REPO_URL`, `PEAKCUT_FOLLOW_URL` | The links at the top of the dashboard. Empty hides a button |
| `PEAKCUT_UPDATE_REPO`, `PEAKCUT_UPDATE_CHECK` | Which repository the update notice watches, and `0` to turn it off |
| `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` | Optional: Sign in with Google, and connecting YouTube |
| `PEAKCUT_SMTP_*`, `PEAKCUT_MAIL_FROM` | Optional: confirmation and password emails |
| `PEAKCUT_DATA` | Where videos, clips and the database are kept (default `./data`) |

`.env`, the `secrets/` folder and all user data are ignored by git. Keep keys there, never in the code.

## How it is built

| Part | What it is |
|---|---|
| `studio/` | The server: FastAPI, the clip pipeline, live recording, accounts |
| `studio/ai.py` | The only file that talks to an AI service. Add a provider here |
| `web/` | The pages: landing, sign-in, the app, the admin dashboard |
| `tests/` | Tests that run against a throwaway copy of the app |
| `deploy/`, `Dockerfile`, `docker-compose.yml` | One-server deployment with PostgreSQL and automatic HTTPS |

Video work is done with `ffmpeg` and `yt-dlp`. Speech is transcribed with `sherpa-onnx` and the Parakeet model.
Data is kept per user: accounts in the database (SQLite on your own computer, PostgreSQL on a server), videos and
clips in each user's own folder. [AGENTS.md](AGENTS.md) is a short map of the code for contributors and AI coding
assistants.

**Admins.** Only matters with accounts on (`PEAKCUT_ACCOUNTS=1`); without them you are the owner. Grant a role on the
machine that runs Peak Cut: `python -m studio.admin grant you@example.com` (`revoke` and `list` work the same way).
The admin dashboard is at `/admin`.

**Under load.** Each person's videos wait in their own line and the lines take turns. The server measures its own
processor, memory and disk, and starts extra videos and recordings only while there is room. There are no limits on
upload size, video length or storage unless you set them in `.env`.

## Deploy

[DEPLOY.md](DEPLOY.md) walks through a single server with Docker: the app, PostgreSQL, and Caddy for HTTPS.

```bash
docker compose up -d --build
```

## Tests

```bash
python tests/run.py
```

This starts a copy of the app on a spare port with an empty temporary data folder, runs the tests, then removes it.
It needs no keys and never touches real data. On Windows, set `PYTHONUTF8=1` first so the Hindi and Urdu caption test
can print its results.

## Security

- With sign-in off, Peak Cut listens on this computer only (`127.0.0.1`) and refuses changes sent by other websites.
  Do not expose it to the internet that way: turn accounts on.
- Passwords are stored only as salted scrypt hashes. Sessions are random tokens stored hashed; cookies are HTTP-only.
- Every route works out who is asking from the session, never from the request, so users only reach their own data.
- Only known video sites are fetched, and text from videos is treated as data when it is shown to the AI.
- Found a problem? Report it privately through the repository's security advisories instead of a public issue.

## Using it responsibly

Clip videos you made, or have permission to use. You are responsible for the rights to what you download, clip and
post, and for following the terms of the sites you fetch from and post to. Game footage and trailers often belong to
the publisher, so check their content policy before you post clips.

## Credits and license

Peak Cut is a fork of [PeakCut](https://github.com/haziqahmedqasmi/PeakCut) and is released under the
[MIT license](LICENSE). The original copyright notice is kept, as the license requires, and a line for this fork's
changes is added.

**What this fork changes:** the look (a cobalt and slate colour scheme, a light sidebar and a new logo), the project
links and update check (they point to this repository), and the removal of the original author's "Follow me" button.
The clip pipeline, live recording, accounts and everything else are the original project's work.

Caption fonts in `studio/fonts/` (Anton, Archivo Black, Poppins) are under the SIL Open Font License; the license
texts are in the same folder.
