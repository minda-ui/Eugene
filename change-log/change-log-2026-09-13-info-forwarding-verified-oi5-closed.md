# Change log — 2026-09-13 — info@ → ops@ forwarding verified; Peter OI-5 closed

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4. (Sixth dated file for 2026-09-13.)_

## 2026-09-13 — `info@` → `ops@` forwarding live and verified (Peter OI-5 closed)

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

Minda set `info@fishboneconstruction.co.uk` (its own Workspace user) to **forward incoming mail into
`ops@`**. First attempt didn't deliver — the Gmail forwarding radio was left on "Disable forwarding";
once switched to "Forward a copy…" and saved, a test to `info@` arrived in `ops@` (verified read-only:
from minda@, to info@, 07:43; `ops@` shows no personal mail). **Peter OI-5 is closed** — Peter reads a
dedicated business inbox, not minda@'s personal mailbox.

**Updated.**
- `Runbooks/Runbook-Dedicated-info-Inbox-and-Ops-Account.md` — Status flipped to ✅ forwarding
  verified; added the "Disable forwarding" gotcha; v0.2-with-verified-status uploaded (prior archived).
- `current-state.md` — Peter OI-5 closed; runbook (2) marked DONE + verified.
- **Peter's KB** (maintained from here): `open-issues.md` OI-5 Resolved; `current-state.md`
  Inbox-wiring row (read `ops@` directly, retire the to/cc proxy); dated change-log added.

**Follow-through (Minda):** update Peter's inbox-triage **routine prompt** to read the `ops@` inbox
directly — Eugene's draft handed over. Next Eugene item on request: the Companies House runbook
(allowlist + CH API key to `ops@`) to close Peter OI-6.

**Governance.** Read-only Gmail verification only; no live-system change by Eugene; no secret recorded.
