---
name: composio-routine-setup
description: Set up, repair or verify Composio for an AI employee's sessions and unattended routines (Anna, Peter, Victoria, Alex, Rachel, Helen, Nadia, John, Darius, Eugene…) using the Composio Connect MCP server and a ck_ consumer key. Use this whenever someone says a routine "can't use Composio", "isn't signed in", "starts from scratch every run", wants Gmail/Drive/GitHub via Composio in a routine, is rolling Composio out to another employee, sees a 401 / 403 / "Proxy refused to open a tunnel" from connect.composio.dev, or asks to test whether Composio works in an environment.
---

# Composio for an employee's routine

## Why it's built this way (read once)

- Routine runs start in a **fresh container** every time. Composio **connections** (e.g. `anna-gmail`)
  live on Composio's side and survive; the **CLI install and its sign-in don't**.
- Composio's dashboard (**Sessions & API Key**) issues only **`ck_` consumer keys**. They authenticate
  MCP clients to **Composio Connect** (`https://connect.composio.dev/mcp`, header
  `x-consumer-api-key`). They **cannot** sign the CLI in — the CLI takes `uak_` user keys (the
  "CLI Sessions", which expire after 3 months). So routines use the **MCP route**, not the CLI.
- Claude Code loads `.mcp.json` from the repo at session start, expanding `${COMPOSIO_API_KEY:-}` from
  the environment. `enabledMcpjsonServers` in `.claude/settings.json` pre-approves it so an unattended
  run doesn't stall on a prompt.
- Proven on Anna and Eugene, 2026-09-29 (`change-log/change-log-2026-09-29-composio-routines-anna-eugene.md`).

## Boundaries

- **Other repos only when Minda asks** for that repo (SRC-13 rule). Otherwise hand the steps to that
  employee via their KB's `Raw/` (cross-KB rule) — this skill's steps and scripts are the content.
- Eugene never sees, types or stores the key. Minda puts it in the environment; scripts read it from
  the environment and print only its first 3 characters.
- Environment settings, network access and the routines form are **Minda's** (charter §3) — give her
  the exact steps; verify afterwards.
- One `ck_` key reaches **every** connection in `minda_workspace`. Aliases keep each employee on their
  own connections by convention, not enforcement — say so when handing over.
- Permission deny-rules don't cover the MCP route (actions run through generic meta-tools like
  `COMPOSIO_MULTI_EXECUTE_TOOL`), so an employee's "read and draft only" rule rests on their charter
  and prompt on this path. State this plainly.

## Steps

**0. Which login?** Some employees run in **another claude.ai login**, not Eugene's (minda@). As of
2026-09-30 that means **Anna, Helen, Nadia and John** (Anna's routine: "Fishbone Construction Ltd" environment;
Helen and Nadia: "AMFA Furniture Ltd"; John: "Fishbone Properties Ltd", repo `minda-ui/Fishbone-Properties-Ltd`).
Merge the repo PR **before** the test: a session loads `.mcp.json` from `main` only when it starts. Eugene can't see their routines or
environments, and environments with the same name in two logins are separate. For these employees,
Minda does steps 1, 3 and 4 in *their* login. For step 4 she pastes the test prompt from
`Runbooks/Runbook-Anna-Routine-Composio-Setup.md` (v0.3) into a new session there and sends Eugene a
screenshot. **Fill in the real account name** in the prompt before handing it over: a placeholder
like `ALIAS` gets pasted as-is and fails. Step 2 (the repo) is the same from any login. Rachel, Darius and Eugene are in Eugene's
login, so Eugene can test them himself.

**1. Minda — environment (per employee's cloud environment)** — environment menu in the session title
bar → **Edit**:
- **Environment variables:** `COMPOSIO_API_KEY=ck_…` (from dashboard → Sessions & API Key).
- **Network access:** allow `connect.composio.dev` (or a broader level). Without it you get
  `Proxy refused to open a tunnel: 403 Forbidden`.

**2. Repo — `.mcp.json` + settings** (the employee's KB repo, branch → PR):
```bash
bash .claude/skills/composio-routine-setup/scripts/apply_repo.sh <path-to-repo-checkout> --dry-run
bash .claude/skills/composio-routine-setup/scripts/apply_repo.sh <path-to-repo-checkout>
```
It writes `.mcp.json` (template in `templates/mcp.json`) and adds `"composio"` to
`enabledMcpjsonServers`, keeping existing hooks and allow/deny rules. If the repo's SessionStart hook
tries `composio login --user-api-key` with the same variable, make it skip `ck_` keys (see
minda-ui/Anna `.claude/hooks/session-start.sh`) so it stops logging a false "sign-in failed".

**3. Minda — the routine** (claude.ai/code/routines → routine → Edit):
- Environment = that employee's environment (the one holding the key).
- **Repository = that employee's repo** attached. If it isn't, neither `.mcp.json` nor the hook loads —
  this was Anna's first failure (her routine showed "Fishbone Construction Ltd · Anna").
- The routine prompt should tell it to pass its **own** `account` alias on every Composio call and
  name what it must never do (e.g. no Gmail send). Deliver prompt changes as a complete replacement
  (`CLAUDE.md` §2b).

**4. Verify** — in a **new** session in that environment (env vars and `.mcp.json` load only at
session start):
```bash
bash .claude/skills/composio-routine-setup/scripts/verify_connect.sh <that-employee>-googledrive
```
Checks, in order, and stops at the first failure: key set and `ck_` → host reachable → MCP handshake
→ tools listed → a read-only Drive "about" call as the given alias. The session should also list
`mcp__composio__*` tools. For a routine, check its next run's output the same way.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| "Composio installed but isn't signed in" | CLI path with a `ck_` key | Expected — use the MCP route (this skill) |
| Key set, 0 Composio tools, "needs auth"; worked before | A **new `ck_` key was generated**, which cancels the old one in every environment (2026-09-30) | Never generate a new key for one environment. To fix one, copy the **current** key. After a rotation, update every environment in every login (list in step 0), then re-test |
| `COMPOSIO_API_KEY not set` | Key missing, or session started before it was added | Add in environment variables; start a new session |
| `Proxy refused to open a tunnel: 403` | Network access blocks the host | Allow `connect.composio.dev` |
| handshake 401 | Key rejected | Re-copy the key; regenerated `ck_` keys can 401 (ComposioHQ/composio#3485) |
| No `mcp__composio__*` tools in a routine | Repo not attached, or server not pre-approved | Attach the repo; run `apply_repo.sh` |
| Drive read returns no user | Wrong/missing alias | `composio connections list` (CLI, signed in) — use an ACTIVE alias |

## Report

Per employee: key present (prefix only), network OK, handshake OK, tool count, Drive read account,
routine's repo/environment confirmed — and anything left for Minda. Log it in the session change-log
and ledger, and on that employee's Hub row if one exists.
