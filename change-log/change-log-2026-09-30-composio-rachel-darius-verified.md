# Change-log — 2026-09-30 — Composio Connect verified for Rachel and Darius

_Newest note at the top. Append-only._

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
