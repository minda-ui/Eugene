# Runbook — Anna's routine settings: Composio working in unattended runs (v0.2)

_Eugene runbook, 2026-09-29. Guide-only for the live steps (charter §3): Minda enters the API key,
edits environment settings and the routines form; Eugene supplies the files and verifies afterwards.
Related: Hub AWT-0060 (SessionStart hook on `minda-ui/Anna`), SRC-13 (Composio)._

## v0.2 update (2026-09-29) — the key Composio issues is `ck_`, so use Composio Connect (MCP)

First routine run: "Composio installed (v0.4.1) but isn't signed in." Cause: Composio's **Sessions &
API Key** page issues a **`ck_` consumer key**, which authenticates MCP clients to **Composio Connect**
(`https://connect.composio.dev/mcp`, header `x-consumer-api-key`). It cannot sign the CLI in — the CLI
takes only `uak_` user keys (the "CLI Sessions" on the same page, 3-month expiry). Minda chose the
MCP route (no expiry, no CLI sign-in). Shipped in **minda-ui/Anna#2**:

- `.mcp.json` — server `composio`, url `https://connect.composio.dev/mcp`, header
  `x-consumer-api-key: ${COMPOSIO_API_KEY:-}` (from the environment; `:-` keeps sessions without the
  key loadable).
- `.claude/settings.json` — `"enabledMcpjsonServers": ["composio"]` so unattended runs load it with no
  approval prompt.
- Hook — skips CLI sign-in for `ck_` keys (MCP-only); a `uak_` key still signs the CLI in (fallback).

Part A changes: keep the `ck_` key as `COMPOSIO_API_KEY`; allow **`connect.composio.dev`** if network
access is restricted. Part C: the routine **must** have `minda-ui/Anna` attached (first run showed
"Fishbone Construction Ltd · Anna" — Anna's repo apparently not attached, so neither hook nor
`.mcp.json` loads).

**Limits:** (1) the B2 deny-rules match CLI commands only — via MCP, actions run through generic
meta-tools with the action name as an argument, which permission rules can't match, so read-and-draft
-only rests on Anna's charter/prompt on this path; (2) which Gmail account Connect uses must be
checked on the first run; (3) untested without the key — a known Composio issue reports `401 Invalid
consumer API key` after regenerating a `ck_` key (ComposioHQ/composio#3485).

**First-run check (replaces Part E steps 1–3 for this path):** the run lists `mcp__composio__*` tools;
one read through them returns mail from the intended mailbox; no 401.

## The problem

Every routine run starts in a fresh container. Composio's **connections** survive (stored on
Composio's side), but the **CLI** and its **sign-in** don't. Anna's runs therefore can't use
`anna-gmail` / `anna-googledrive` today.

## What exists now (checked 2026-09-29)

| Item | State |
|---|---|
| Cloud environment `Anna` | Exists — `env_0199WwbnodKqhVU8HSkGJTPe` |
| Composio connections | All ACTIVE: `anna-gmail` (info@fishboneconstruction.co.uk), `anna-gmail-properties` (info@fishboneproperties.co.uk), `anna-gmail-ops` (ops@fishboneconstruction.co.uk), `anna-googledrive` |
| Repo `minda-ui/Anna` | Seeded (charter + control files). `.claude/settings.json` has the Composio allow-rules. **No SessionStart hook** — nothing installs Composio (or the PDF toolkit) |
| Anna's routine | Her `CLAUDE.md` §7 names "Anna – Construction project email check" `trig_014PjEdPWN5pBcxB5rzFhY1T` (created 2026-09-29). **Not found** from the minda@ account's routine list — either created under another login or not saved. Confirm in claude.ai/code/routines. |

## Part A — Minda: environment settings (one-time)

1. **Create a Composio API key.** dashboard.composio.dev → org `minda_workspace` → Settings → API keys →
   create, name it `routines-anna`. Copy it once. **Do not paste it into chat, a repo or a Drive file.**
2. **Add it to the Anna environment.** claude.ai/code → open a session in the **Anna** environment →
   environment menu in the title bar → **Edit** → Environment variables:
   `COMPOSIO_API_KEY=<the key>`. Save. (Only new sessions pick it up.)
3. **Network access** (same Edit screen). If the level is anything narrower than full access, allow:
   `composio.dev`, `backend.composio.dev`, `github.com`, `objects.githubusercontent.com`,
   `release-assets.githubusercontent.com`, `*.r2.cloudflarestorage.com` (Composio file downloads).

> **Security:** a user API key reaches **every** connection in `minda_workspace` (all employees' Gmail
> and Drive). Account aliases keep Anna on her own connections by convention, not enforcement. Put the
> key only in environments that need it; rotate it if a session ever misbehaves.

## Part B — repo files (`minda-ui/Anna`, branch `main`)

Two files. Eugene can commit them (AWT-0060) if given push access to `minda-ui/Anna`; otherwise Minda
pastes them via GitHub's web UI (Add file → Create new file / edit). Anna herself can't edit
`settings.json` (Self-Modification guard).

### B1. `.claude/hooks/session-start.sh` (new file — full contents)

```bash
#!/bin/bash
# Anna (AI Construction Assistant) — SessionStart hook.
#
# 1. PDF toolkit (group standard — same block as every Fishbone KB repo).
# 2. Composio CLI, pinned, so unattended routine runs can use Anna's own
#    Composio connections (anna-gmail, anna-gmail-properties, anna-gmail-ops,
#    anna-googledrive) without a browser.
#
# Sign-in reads COMPOSIO_API_KEY from the cloud environment's variables (set
# by Minda in the Anna environment's settings). The key is never written to
# this repo or printed. No key -> CLI installed but not signed in; the
# session falls back to the native connectors.
#
# Idempotent, non-interactive, web/remote sessions only. Never aborts the
# session.
set -uo pipefail

# Web/remote sessions only — do nothing on a local machine.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# --- OCR engine + PDF rasteriser (system packages; best-effort, needs sudo) ---
if ! command -v tesseract >/dev/null 2>&1 || ! command -v pdftoppm >/dev/null 2>&1; then
  if command -v sudo >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -qq 2>/dev/null || true
    sudo apt-get install -y -qq tesseract-ocr poppler-utils >/dev/null 2>&1 \
      || echo "session-start: tesseract/poppler not installed — OCR of scanned PDFs may be unavailable" >&2
  fi
fi

# --- Python PDF libraries (text, tables, rendering, OCR bindings) ---
pip install --quiet pdfplumber pymupdf pdf2image pytesseract pillow pypdf \
  || echo "session-start: pip install of PDF libraries failed" >&2

# --- Composio CLI (pinned) ---
COMPOSIO_VERSION="0.4.1"
COMPOSIO_ORG="minda_workspace"
COMPOSIO_BIN="$HOME/.local/bin/composio"
if [ "$("$COMPOSIO_BIN" --version 2>/dev/null)" != "$COMPOSIO_VERSION" ]; then
  curl -fsSL https://composio.dev/install | sh -s -- "@composio/cli@${COMPOSIO_VERSION}" >/dev/null 2>&1 || true
fi
if [ ! -x "$COMPOSIO_BIN" ]; then
  echo "session-start: composio CLI not installed" >&2
else
  if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
  fi
  # --- Composio sign-in from the environment's API key (no browser) ---
  if "$COMPOSIO_BIN" whoami 2>/dev/null | grep -q '"email"'; then
    :  # already signed in
  elif [ -n "${COMPOSIO_API_KEY:-}" ]; then
    "$COMPOSIO_BIN" login --user-api-key "$COMPOSIO_API_KEY" --org "$COMPOSIO_ORG" \
      -y --no-skill-install >/dev/null 2>&1 || true
    "$COMPOSIO_BIN" whoami 2>/dev/null | grep -q '"email"' \
      || echo "session-start: composio sign-in with COMPOSIO_API_KEY failed — native connectors only this run" >&2
  else
    echo "session-start: COMPOSIO_API_KEY not set — composio installed but not signed in" >&2
  fi
fi

exit 0
```

### B2. `.claude/settings.json` (replace — full contents)

Keeps the existing allow-rules, registers the hook, and adds deny-rules that enforce Anna's
read-and-draft-only Gmail rule and her never-delete rule at the permission layer.

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)"
    ],
    "deny": [
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)"
    ]
  }
}
```

## Part C — Minda: routines form (claude.ai/code/routines → Anna's routine → Edit)

| Field | Setting |
|---|---|
| Name | `Anna – Construction project email check` |
| Environment | **Anna** (must be the one holding `COMPOSIO_API_KEY`) |
| Repository | **`minda-ui/Anna`**, branch **`main`** — required, or the hook and settings above never load |
| Schedule | Mon–Fri, every 2 h, 05:55–17:55 UK — cron `CRON_TZ=Europe/London 55 5-17/2 * * 1-5` |
| Connectors | Gmail + Google Drive (native — stay the primary path); Composio is the fallback |
| Prompt | Anna's canonical full prompt from her own KB, with the Part D block included |

## Part D — Composio section for Anna's routine prompt

Anna's canonical prompt lives in her own KB; Eugene doesn't edit it (cross-KB rule). Anna folds this
block into her **full** prompt and hands Minda the complete paste-ready replacement:

```
COMPOSIO (fallback when a native Gmail/Drive connector is missing or fails)
- The session-start hook installs the Composio CLI and signs it in from the environment.
  First check: `composio whoami` must show minda@fishboneconstruction.co.uk / minda_workspace.
  If it doesn't, use native connectors only and note "Composio unavailable" in this run's log.
- Use ONLY Anna's own connections, always with --account:
  anna-gmail (info@fishboneconstruction.co.uk), anna-gmail-properties (info@fishboneproperties.co.uk),
  anna-gmail-ops (ops@fishboneconstruction.co.uk), anna-googledrive.
  Never another employee's alias, even if it would work.
- Gmail is READ and DRAFT only. Never send, reply, forward or send a draft; never delete or trash.
- Drive writes follow archive-then-recreate + byte-verify, same as native.
```

## Part E — verification (first run after Parts A–C)

1. Routine run log shows no `session-start:` warning lines (or only the PDF/OCR one).
2. The run's own `composio whoami` = minda@fishboneconstruction.co.uk / `minda_workspace`.
3. One read per connection in use, e.g. `GMAIL_FETCH_EMAILS --account anna-gmail` (1 result) and
   `GOOGLEDRIVE_GET_ABOUT --account anna-googledrive`.
4. A send-type call is refused by the deny-rules (check only by reading the settings; don't test by
   sending).
5. Eugene re-checks the run and logs the result on AWT-0060.

**Not yet proven:** the API-key sign-in block (Part B1) — written to the CLI's documented
`login --user-api-key` option but not run with a real key; it can't be tested until Part A is done.
The install block is the same code as Eugene's own hook, tested 2026-09-27.

## Same pattern for other employees

Parts A–C repeat per environment/repo: change the header, aliases and deny-list to that employee's
remit. Victoria's group seat (AWT-0180) is the next obvious one.
