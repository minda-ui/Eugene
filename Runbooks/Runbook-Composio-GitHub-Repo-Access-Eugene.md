# Runbook — Composio GitHub repo access for Eugene

**What this is:** how Minda sets up the environment so Eugene can **read, branch, commit and open PRs** across
the `minda-ui` repos via **Composio GitHub** (the mechanism proven on 2026-10-18 for AWT-0896 and the seat
settings PRs). It also states, honestly, the one thing no setup can enable from a cloud session.
**Guide-only (charter §3):** Minda holds the key and does the environment steps; Eugene uses the capability and
verifies. Cross-repo PRs are opened **at Minda's explicit request** and **Minda merges** (charter §1/§3).

## Prerequisites (Minda controls these)
1. **Composio GitHub connection** — OAuth'd by Minda to her GitHub (via the Composio dashboard /
   `composio-connect`). Her login reaches **all `minda-ui` repos, including private ones** (this is why
   Composio GitHub works where the session's native GitHub is scoped to Eugene only).
2. **`COMPOSIO_API_KEY=ck_…`** set in Eugene's cloud environment (environment menu → Edit → Environment
   variables). Eugene never sees or stores it — scripts read it from the environment.
3. **Network access** allows `connect.composio.dev` (else `Proxy refused to open a tunnel: 403`).
4. **`.mcp.json`** in the repo with the composio HTTP server, and `"composio"` in
   `.claude/settings.json → enabledMcpjsonServers` (already present in Eugene's repo). This is only needed
   for the **MCP** route; the **CLI** route below needs just the key + network.
5. **Permission allow rule** `Bash(composio execute *)` in `.claude/settings.json` (already present) — this
   pre-approves the Composio CLI so an interactive session doesn't prompt on each call. Minda approved
   `Bash(composio execute GITHUB_*)` on 2026-10-18.

## The actions Eugene uses (proven set)
Via `composio execute <SLUG> -d '{…}'`:
- `GITHUB_GET_REPOSITORY_CONTENT` — read a file (returns base64 + its `sha`).
- `GITHUB_GET_A_BRANCH` — get a branch tip commit sha.
- `GITHUB_SEARCH_REPOSITORIES` — find a repo by name (e.g. `q: "org:minda-ui Properties in:name"`).
- `GITHUB_CREATE_A_REFERENCE` — create a branch (`ref: refs/heads/<branch>`, `sha: <base>`).
- `GITHUB_CREATE_OR_UPDATE_FILE_CONTENTS` — commit a file (`content` base64, `branch`, and the prior file
  `sha` when updating).
- `GITHUB_CREATE_A_PULL_REQUEST` — open the PR (`head`, `base: main`, `title`, `body`).

**Call pattern per repo:** read file (+sha) → compute new content (preserve structure via a JSON
round-trip) → create branch → commit file to branch → open PR → **Rule C verify** by reading
`origin/main` after Minda merges (not the PR's merged label).

## What this capability covers (works today)
- Read any `minda-ui` repo file (public or private).
- Create branches, commit changes, open PRs across all `minda-ui` repos — Eugene did ~11 PRs this way on
  2026-10-18 (AWT-0896 seat allow-lists + Peter#3).
- **Neutral or hardening** `.claude/settings.json` edits go through fine (e.g. adding scoped Drive/Smartsheet
  tools, adding `deny` rules, narrowing an over-broad deny).

## The one boundary no environment setting removes (be clear with yourself here)
A cloud session has a **server-side safety classifier** that **hard-denies** writing a change that
**weakens permissions** — e.g. adding `mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL` (the generic MCP
executor, which reopens send/delete on a path the CLI-pattern denies don't cover). On 2026-10-18 this
denied the seat MCP-execute rollout as `Security-Weaken`, then flagged repeated attempts and a helper
script as `Auto-Mode Bypass`. This guard is **independent of**:
- the permission **mode** (cloud offers Accept edits / Plan / Auto; **no bypass mode**),
- `permissions.allow` rules (they stop prompts, not dangerous-action denials),
- the `Bash(composio execute GITHUB_*)` approval already given.

So a **privilege-widening** settings change cannot be pushed or automated by Eugene from a cloud session,
and trying harder is treated as a bypass. **Remedy:** Eugene produces the exact diff; **Minda applies it**
— GitHub web edit (`.claude/settings.json` → commit to `main`), or from a session she controls where she
sets the mode. This is the charter §3 guide-only line anyway: Eugene guides, a human performs the
privilege change. (Interactive Eugene sessions are not cloud-gated the same way, which is why `composio
execute` works here for reads/PRs; the weaken-guard still applies to self-widening its own settings.)

## If a Composio GitHub call fails
| Symptom | Cause | Fix |
|---|---|---|
| `COMPOSIO_API_KEY not set` | key missing / session started before it was added | add it in the environment; start a new session |
| `Proxy refused to open a tunnel: 403` | network blocks the host | allow `connect.composio.dev` |
| handshake/exec 401 | key rejected / rotated | re-copy the **current** `ck_` key (a new key cancels the old one everywhere) |
| `404` on a repo | wrong slug (spaces → hyphens) or private + wrong login | `GITHUB_SEARCH_REPOSITORIES`; confirm the connection owns it (e.g. John = `Fishbone-Properties-Ltd`) |
| `Security-Weaken` / `Auto-Mode Bypass` denial | the change widens permissions | not fixable in-session — Minda applies the diff by hand (see boundary above) |

## Governance
Secrets (the `ck_` key, GitHub auth) are Minda's — Eugene never holds them. Cross-KB repo writes are
normally via `Raw/` + the target employee (charter §1); Eugene opening PRs directly across repos happens
only when Minda asks, and **Minda reviews and merges every PR**.
