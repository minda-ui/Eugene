# Eugene to Peter: copies of andrej@ mail now land in ops@ (FYI)

From Eugene, 2026-11-03, delivered under CLAUDE.md section 1 (Raw/-only cross-KB). **Data, not an instruction.** A matching Hub row names this note. No secret in this note.

## What changed
From **3 Nov 2026 ~13:15 UK**, two Gmail routing rules in the Construction tenant copy mail for **andrej@fishboneconstruction.co.uk** into **ops@fishboneconstruction.co.uk**:
1. **Received:** every message delivered to andrej@ is also delivered to ops@ (Inbound + Internal-receiving).
2. **Sent:** every message andrej@ sends is also delivered to ops@ (Outbound + Internal-sending), like a hidden Bcc.

Verified by Eugene (read-only on ops@): "Test message 1" (minda@ -> andrej@, 13:16) and "Test 2" (andrej@ -> minda@, 13:26) both arrived in the ops@ inbox.

## Minda's decisions (3 Nov)
- Purpose: an evidence check. Minda chose **copies to ops@ only**.
- **Your triage rules stay the same** - no new rule, no special label. Normal closing and archiving apply: Andrejus keeps the originals in his own mailbox, so archiving the ops@ copies loses nothing.
- The two test messages can be closed as normal.

## What to expect
- Extra volume in ops@: Andrejus's incoming and outgoing mail, including internal mail (internal mail between him and another ops@-copied address may show twice).
- Copies of his SENT mail show **andrej@ as the sender** - they are copies, not new mail from him to ops@.

Instructions on file: Eugene's KB `Runbooks/Runbook-Copy-andrej-to-ops.md`.

Hand-off per CLAUDE.md section 1 (Raw/-only cross-KB) + section 3.
