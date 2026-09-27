# Change log — 2026-09-27 — Charter-Rules adopted; Composio rollout (AWT-0145, AWT-0155)

Interactive session with Minda, branch `claude/lucid-mayer-nsoili`. Ran after the earlier 2026-09-27
sessions (`change-log-2026-09-27-main-branch-corruption-found-fixed.md`).

## 1. Charter-Rules.md adopted — AWT-0145 closed

- Minda: "adopt Charter-rules.md."
- Checked first (Rule C): Drive, this branch and `origin/main` were already byte-identical —
  `Charter-Rules.md` 6135 B, `Charter-History.md` 10476 B, `CLAUDE.md` 20645 B. Rule F already folded
  in by the earlier session; nothing to edit.
- Hub **AWT-0145** (Alex: fold Rule F in, review Hub-changes broadcast) closed Done. The broadcast
  (Tasks & Requests Archive split, sheet `1037721118312324`) is informational — no action.
- Rule A Hub check: 9 other own rows open — AWT-0121 (High, new: M365 cancellation impact check),
  AWT-0090 (High, due 09-29), AWT-0118, AWT-0132, AWT-0135, AWT-0125 open; AWT-0060, AWT-0101 blocked.

## 2. Composio rollout — AWT-0155 closed

Source: Alex's `Raw/2026-09-27_Proposal_Composio-Rollout.md` (Minda-approved estate rollout).
Every step below was at Minda's explicit instruction in this session.

| Step | Result |
|---|---|
| Install | `curl -fsSL https://composio.dev/install \| sh -s -- @composio/cli@0.4.1` — Minda pasted the command with a `<version>` placeholder; filled from the proposal's pin. Checksum verified. Optional agent-plugin sub-step failed (HTTP 403); CLI unaffected. |
| Login | `composio login --no-browser --no-wait` → Minda authorised the URL → `--poll` succeeded. `whoami` verified: minda@fishboneconstruction.co.uk, org `minda_workspace` (`ok_AFelFDrMGAcx`), account type human. |
| Link | `eugene-googledrive` only. **No Gmail** — the proposal listed it, but `CLAUDE.md` §1 says Eugene has no Gmail connector (not an email agent); flagged, Minda chose Drive. Smartsheet not linked (native connector works). |
| Read check | `GOOGLEDRIVE_GET_ABOUT` = minda@; listing of Eugene's folder matches native-connector sizes. |
| Write test 1 (small) | `external-source-register.md` + **SRC-13 Composio** (3740 → 4503 B). |
| Write test 2 (large) | `current-state.md` + session entry (57160 → 58545 B). |

Both writes via Composio only, archive-then-recreate: old file renamed `(archived 2026-09-27 1933/1934,
…)` and moved to `Archive/` (`UPDATE_FILE_METADATA_PATCH` add/removeParents), new file uploaded to the
root (`UPLOAD_FILE`). Verified: Drive `md5Checksum` == local md5; downloaded copy `cmp`-identical;
0 U+FFFD; special-character counts equal; exactly one live copy of each in the root. Before editing,
both Drive files were downloaded via Composio and confirmed identical to git.

## 3. SessionStart hook — PR merged

- `.claude/hooks/session-start.sh` now installs the pinned CLI on web sessions: skips if 0.4.1 already
  present, best-effort (never aborts), adds `~/.local/bin` to PATH via `CLAUDE_ENV_FILE`.
- Tested: `bash -n` clean; CLI present → skip, exit 0; clean state → installs 0.4.1, exit 0.
- [minda-ui/Eugene#1](https://github.com/minda-ui/Eugene/pull/1) merged by Minda → `main` `61055ca`.
  Branch restarted from `main` afterwards for this log.
- **Limit:** login + link state live in the ephemeral container. Each new session still needs Minda's
  two browser approvals (login, Drive link). No credential goes in the repo (charter §3).

## Loose ends

- SRC-13's note still says the CLI is not persistent "unless added to the SessionStart hook" — now
  it is. Fix on the next write of `external-source-register.md` (not worth an archive cycle alone).
- One EXPIRED unaliased Drive connection (`googledrive_tute-sassy`) in the shared Composio org — not
  Eugene's; `composio connections remove` needs Minda's own terminal.
- Raw/ still holds already-processed notes (earlier `git rm` blocked by the safety classifier) —
  harmless clutter.
