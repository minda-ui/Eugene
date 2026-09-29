# Change log — 2026-09-29 — Composio in unattended routines (Anna + Eugene), GitHub link, Anna repo consolidated

Interactive session with Minda, branch `claude/lucid-mayer-nsoili` (restarted from `main` after each
merge). Continues the 2026-09-27 session (`change-log-2026-09-27-daily-summary.md`).

## Update 2026-09-29 ~09:40 UTC — Eugene's Composio Connect test: PASS

Newest note first; the "unconfirmed" entries below stand as what was known at the time.

- A session restart loaded `.mcp.json` and the `ck_` key, but the server failed with
  `Proxy refused to open a tunnel: 403 Forbidden` — the Eugene environment's network policy blocked
  `connect.composio.dev`. Minda added it to the environment's network access.
- Re-tested directly against the server (read-only):

| Check | Result |
|---|---|
| `connect.composio.dev` reachable | PASS — 401 without key (expected) |
| `ck_` key + MCP `initialize` | PASS — HTTP 200, session opened |
| `tools/list` | PASS — 11 tools (`COMPOSIO_SEARCH_TOOLS`, `COMPOSIO_MULTI_EXECUTE_TOOL`, `COMPOSIO_MANAGE_CONNECTIONS`, …) |
| `GOOGLEDRIVE_GET_ABOUT` via `account: eugene-googledrive` | PASS — minda@fishboneconstruction.co.uk |
| Listing Eugene's KB root | PASS — 14 items |

- Account selection works by alias (`account` field) — routine prompts must always pass their own.
- This session's built-in `mcp__composio__*` tools stay unloaded (connection failed at start); new
  sessions, incl. the 09:30 Task Check-in, load them automatically.
- **Anna:** same network entry needed in the Anna environment, plus `minda-ui/Anna` attached to her
  routine — then Run now; AWT-0060 closes after that run is verified.

## At a glance

| # | Work | Where | Outcome |
|---|---|---|---|
| 1 | Session-start Hub check (Rule A) | Hub | 7 own rows; AWT-0118/0180 found blocked only on repo scope |
| 2 | Why routines can't use Composio; fix designed | this log | Connections persist; CLI + sign-in don't |
| 3 | Anna routine runbook | `Runbooks/Runbook-Anna-Routine-Composio-Setup.md` v0.1 → v0.2 | Done |
| 4 | Anna hook + settings (AWT-0060) | minda-ui/Anna#1 | Merged `904dcfd` |
| 5 | `ck_` key finding → Composio Connect MCP for Anna | minda-ui/Anna#2 | Merged `a52b6ca` |
| 6 | Anna repo branches consolidated | minda-ui/Anna#3 | Merged `c8b7f50` |
| 7 | `eugene-github` Composio link + Minda's repo-scope rule | SRC-13, minda-ui/Eugene#4 | Merged `9004157` |
| 8 | Composio Connect MCP for Eugene | minda-ui/Eugene#5 | Merged `35f65b6` |
| 9 | Test of Eugene's Connect setup | child session `session_018dfhs1NfDLazRAzrZnfxad` | **Unconfirmed** at the time — **PASS** after network fix (see update above) |

## 1. Hub check

Open own rows: AWT-0090 (High, due today — Entra ID revoke still needs a tenant admin), AWT-0121
(High — Alex's leg stuck: AWT-0123 never created), AWT-0118 and AWT-0180 (blocked only because the
09-28 routine couldn't reach `minda-ui/fishbone-group`), AWT-0132 (no Ads/GTM connector), AWT-0060,
AWT-0101. Sibling branch `claude/beautiful-allen-1ze8qj` (09-28 Task Check-in) found 2 commits ahead
of `main` — **not folded in yet** (awaiting Minda).

## 2. Diagnosis — Composio in unattended runs

Composio **connections** persist server-side; the **CLI** and its **sign-in** live in the container
and are lost every run. The 09-28 Eugene routine showed exactly this (Drive sync deferred for want of
a login). Proposed: an environment variable carrying a key + a hook that signs in without a browser.

## 3–4. Anna: runbook + hook (AWT-0060)

- Found: `minda-ui/Anna` seeded (so AWT-0060 unblocked) but **no SessionStart hook**; environment
  `Anna` exists; connections `anna-gmail`, `anna-gmail-properties`, `anna-gmail-ops`,
  `anna-googledrive` all ACTIVE; Anna's routine `trig_014PjEdPWN5pBcxB5rzFhY1T` **not visible** from
  the minda@ account (flagged).
- Wrote the runbook (v0.1) and, with push access granted at Minda's request, committed the hook
  (PDF toolkit + pinned CLI 0.4.1 + API-key sign-in) and `settings.json` with deny-rules for Gmail
  send/reply/forward and Gmail/Drive delete. A test run of the hook was declined by this session's
  safety check (Unauthorized Persistence) — not retried.

## 5. The `ck_` key → Composio Connect (MCP)

- First routine run: "Composio installed (v0.4.1) but isn't signed in."
- Minda's key starts `ck_`. Composio's Sessions & API Key page only issues `ck_` **consumer keys**,
  sent as `x-consumer-api-key` to **Composio Connect** (`https://connect.composio.dev/mcp`). The CLI
  signs in only with `uak_` user keys (the "CLI Sessions", 3-month expiry). Sources: Composio docs
  (authenticating; Composio Connect; consumer project boundaries).
- Minda chose the MCP route. Anna now has `.mcp.json` (server `composio`, header from
  `${COMPOSIO_API_KEY:-}`) + `enabledMcpjsonServers`; the hook skips CLI sign-in for `ck_` keys.
- Limits recorded: the deny-rules don't cover the MCP path (actions run through generic meta-tools);
  which mailbox Connect uses must be checked on first run; known 401 after key regeneration
  (ComposioHQ/composio#3485).
- **Still open:** Anna's last run showed "Fishbone Construction Ltd · Anna" — `minda-ui/Anna`
  apparently not attached to the routine, so neither hook nor `.mcp.json` loads. Minda to attach it.

## 6. Anna repo consolidation

At Minda's request: `claude/lucid-mayer-nsoili` already in `main`; `claude/loving-gates-8bcu4a`
(7 commits, Anna's own charter updates 09-28/29) merged via PR #3 after a clean trial merge (disjoint
files). Both side branches now redundant — deletion left to Minda.

## 7. GitHub via Composio (`eugene-github`)

Linked and verified as GitHub user `minda-ui`. It reaches **all 23 repos with push** (admin on
`Eugene`). **Minda's rule: Eugene works with other repos only when she asks.** Recorded in SRC-13.
Also flagged: **13 KB repos are public** (incl. Fishbone-Group, Fishbone-Construction-Ltd,
Fishbone-SSAS, Rachel) — visibility change is Minda's; not yet raised on the Hub.

## 8–9. Eugene: Composio Connect MCP

- "Connect composio via composio": the `composio` toolkit has no auth and its meta-tools can't run
  from the CLI ("Cannot execute meta tool … directly") — they are what Composio Connect serves.
- So Eugene got the same `.mcp.json` + `enabledMcpjsonServers` as Anna (PR #5). Minda added the `ck_`
  key to the Eugene environment.
- This session can't see the key (env vars reach only new sessions). A fresh read-only test session
  was started; it went idle with **no readable result** from here — the test is **unconfirmed**.
  Minda to open it, or the 2026-09-30 09:30 Task Check-in will show whether `mcp__composio__*` loads.

## Boundaries kept

No Gmail used or linked for Eugene (charter §1). No credential seen or written — keys only ever named
by where they live. No live-system change made by Eugene: environment variables, routine settings,
key creation, repo visibility all Minda's. Other repos touched only on Minda's explicit request (Anna).

## Still open

| Item | Owner |
|---|---|
| Attach `minda-ui/Anna` to Anna's routine; Run now; confirm mailbox + no 401 | Minda, then Eugene verifies (AWT-0060) |
| Confirm Eugene's Connect test result (or read the 09-30 check-in) | Minda / Eugene |
| Fold `claude/beautiful-allen-1ze8qj` (09-28 check-in) into `main` + finish its Drive sync | Eugene, on Minda's go-ahead |
| 13 public KB repos | Minda (decide), Eugene can raise on the Hub |
| Delete redundant Anna side branches | Minda |
| Revoke unused Composio CLI sessions (11+) | Minda |
| AWT-0090 Entra ID revoke (due today); AWT-0123 creation | Tenant admin; Victoria/Alex |
