# Change-log — 2026-09-30 — Composio Connect verified for Rachel and Darius

_Newest note at the top. Append-only._

## Update 2026-09-30 ~19:20 UTC — John verified

| What | Result |
|---|---|
| Repo | John has no repo of his own; his git mirror is `minda-ui/Fishbone-Properties-Ltd`. PR #2 merged (`c70d8b6`): `.mcp.json` + 10 deny rules from his charter §9. |
| Environment | John's login, **Fishbone Properties Ltd**. Key + network set by Minda. |
| First test | FAIL, 0 Composio tools: it ran before the PR was merged, so `main` had no `.mcp.json`. |
| Re-test | **PASS**: `ck_`, Composio tools present, Drive via `john-googledrive` = minda@ (Eugene re-checked). |
| Raw/ note | Left in the Properties KB `Raw/` for John: charter §9 still describes the CLI + setup-script route. |

**Lesson:** merge the repo PR **before** the test; a session only loads `.mcp.json` from what's on `main` when it starts.

**Composio Connect verified:** Eugene, Anna, Rachel, Darius, Helen, Nadia, John. **Not yet:** Peter, Victoria, Alex.

## Update 2026-09-30 ~18:50 UTC — Helen and Nadia verified

| What | Result |
|---|---|
| Repos | minda-ui/Nadia#3 and minda-ui/Helen#4 merged. Nadia: `.mcp.json` + 10 deny rules (drafts allowed). Helen: group SessionStart hook (she had none) + `.mcp.json` + deny all Gmail and Drive delete. |
| Where they run | Another login, **AMFA Furniture Ltd** environment. Minda did the key + network steps and ran the test there. |
| **Nadia** | **PASS**: Drive via `nadia-googledrive-v2` = minda@ (first try hit a transient Cloudflare 502; retry OK). |
| **Helen** | **PASS**: key `ck_`, Composio tools present, Drive via `helen-googledrive` = minda@ (Eugene re-checked). |
| Composio logins | `nadia-googledrive`, `nadia-gmail` expired unused; `nadia-gdrive-test1` stuck initializing. Minda's to remove. `nadia-gmail` (enquiries@amfa.uk, read + draft) awaits her decision. |

**Lesson:** give a test prompt with the account name already filled in. A placeholder like `ALIAS` got pasted as-is and failed the Drive step.

**Composio Connect is now verified for:** Eugene, Anna, Rachel, Darius, Helen, Nadia. **Not yet:** John, Peter, Victoria, Alex.

## Update 2026-09-30 ~18:20 UTC — Microsoft 365 disconnected; other-login employees

| What | Result |
|---|---|
| Microsoft 365 connector | Checked **disconnected** in minda@'s login (status only, no M365 calls). Minda: the M365 account is being closed. |
| Hub AWT-0090 | **Done (moot)**: Rachel's 29 scopes go with the account. Reopen for the Entra revoke (Path B) if the closure is cancelled. |
| Hub AWT-0121 | Updated, still **In Progress**. Before closure: confirm Rachel's OneDrive tax archive (SRC-32) is moved; Alex's AWT-0202 still unanswered. |
| Other logins | Minda: **Helen, Nadia and John** are in another login too, like Anna. `composio-routine-setup` skill: new step 0, "which login?" (minda-ui/Eugene#15). |

## Update 2026-09-30 ~17:40 UTC — Anna verified; AWT-0060 closed

| What | Result |
|---|---|
| Where Anna runs | Her Inbox Report Routine is in **another claude.ai login**, in that login's "Fishbone Construction Ltd" environment, with `minda-ui/Anna` attached. |
| Eugene's own tests | Two tests in Eugene's login (its FC and Anna environments) showed no key and a 403. They don't apply to Anna's login. Both test sessions archived. |
| Minda's test in Anna's login | **PASS**: key `ck_`, 11 Composio tools, Drive via `anna-googledrive` = minda@. No Gmail calls. |
| Hub | **AWT-0060 → Done** (2026-09-30). |
| Runbook | `Runbook-Anna-Routine-Composio-Setup.md` → v0.3: the separate-login steps and the test prompt. |

**Lesson:** before testing an employee's routine, confirm which **login** and which environment it runs in. Environments with the same name in different logins are separate.

## Update 2026-09-30 ~17:35 UTC — Verified, tidied, folded

| What | Result |
|---|---|
| `rachel-googledrive` link | Minda approved it; checked **ACTIVE**, Drive user minda@fishboneconstruction.co.uk. |
| Environment steps (Minda) | `COMPOSIO_API_KEY` (`ck_`) and network allow for `connect.composio.dev` added to the Rachel and Darius environments. |
| **Rachel verify** | **PASS** 17:10 UTC: `verify_connect.sh rachel-googledrive`, 11 Composio tools, Drive = minda@, 11 `mcp__composio__*` tools loaded. |
| **Darius verify** | **PASS** 17:23 UTC: `verify_connect.sh darius-googledrive`, Drive = minda@, 11 `mcp__composio__*` tools loaded. |
| Darius first attempts | Two sessions failed with "Setup script failed". Cause: the Darius **environment Setup script** held a Composio CLI install (`curl … composio.dev/install`) that stopped at "Extracting bundle…". Not from any Eugene runbook. Minda cleared it; next run passed. |
| Test-session method | First round's result files couldn't be pushed (child session's permission check blocked `git commit` on `main`). Re-ran with the verdict in the child's final message instead, read via `get_session`. Use this pattern next time. |
| CLI install in KB repo hooks | Not needed with `ck_` keys (the CLI can't sign in with them; MCP needs no install). Minda reports she has already removed it from the Rachel, Darius and Anna hooks. Eugene's own hook keeps it (used by `drive-sync-verified`). |
| Tidy | All 5 test sessions archived. No scratch branches were pushed, so none to delete. |
| Fold | This morning's check-in branch `claude/intelligent-knuth-gtdn2d` (one ledger row `NEW`) merged; row numbered **54**. |

**Lessons**
- A failing environment **Setup script** stops the session before any repo hook runs. Check it first when a session shows "Setup script failed".
- KB routines on the Composio Connect route need nothing installed: key + network allow + `.mcp.json` is the whole setup.

**Open**
- Anna: attach `minda-ui/Anna` to her routine and add the `connect.composio.dev` network allow; then verify and close AWT-0060.
- Branch `claude/intelligent-knuth-gtdn2d` can be deleted once this PR is merged (Minda's call).
- Hub: AWT-0090 overdue (Entra revoke, tenant admin); AWT-0121 waits on Alex's AWT-0202.
