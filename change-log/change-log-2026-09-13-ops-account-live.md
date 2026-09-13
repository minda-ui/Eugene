# Change log — 2026-09-13 — ops account live + verified; info@ runbook to v0.2

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4. (Fifth dated file for 2026-09-13.)_

## 2026-09-13 — `ops@` created + connector repointed (verified); `info@` routing pending

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Owner action.** Minda created `ops@fishboneconstruction.co.uk` (least-privilege, no admin roles,
2FA, own mailbox) and **repointed Peter's Gmail connector to it**.

**Eugene verified (read-only Gmail, permitted under group §6a).**
- The connector now reads **`ops@`**: recent mail is only the account's own setup messages, all
  addressed to `ops@` — so Peter no longer reads minda@'s personal mailbox. ✅
- **`info@` is its own separate Workspace user/mailbox** (owner-confirmed; not an alias on minda@), and
  its mail does **not** yet reach `ops@` — `deliveredto:info@fishboneconstruction.co.uk` in the ops
  mailbox returns zero. So Peter currently reads an empty ops inbox.
- Cosmetic: the Construction Workspace **org display name still reads "Fishbone Drylining Ltd"** (the
  pre-2024 name) — flagged for a later rename; no routing impact.

**Produced / updated.**
- `Runbooks/Runbook-Dedicated-info-Inbox-and-Ops-Account.md` bumped to **v0.2**: ops account marked
  done/verified; §2–§3 rewritten for the real setup — `info@` is a separate user, so the step is to
  **forward/route `info@` → `ops@`** (Option A, keeping info@'s own copy; user-level forwarding or
  admin routing), with Option B (read `info@` directly) as the alternative. v0.1 archived.
- `Infra-Inventory/Workspace-and-Email-Inventory.md`: added the **identity/workforce-accounts** table
  (`ops@` agent identity live; `info@` separate user, routing pending; `minda@` out of scope).
- `current-state.md` refreshed.

**Remaining to close Peter OI-5:** deliver `info@` mail into `ops@` (runbook §3), then Eugene
re-verifies with a test email and drafts Peter's updated inbox-triage routine prompt.

**Governance.** Read-only verification only; no live-system change by Eugene; no password/key recorded.
