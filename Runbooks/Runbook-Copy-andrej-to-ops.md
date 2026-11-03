# Runbook - copy andrej@fishboneconstruction.co.uk mail to ops@fishboneconstruction.co.uk

**Asked by:** Minda, 2026-11-03. **Decision:** COPY (Andrejus keeps getting all his mail; ops@ gets a copy for Peter's triage). Same tenant (Construction). Guide-only: Minda does it in the Admin console; Eugene verifies afterwards.

## Before you start
- Tell Andrejus: from now on a copy of mail to his address goes to the shared ops@ mailbox, which Peter (AI) triages and other seats read. His mail stays in his own inbox as before.
- Loop check: ops@ must NOT forward anything back to andrej@.

## Method A (recommended) - per-user email routing in the Admin console
1. admin.google.com (super admin) -> Directory -> Users -> Andrejus (andrej@fishboneconstruction.co.uk).
2. User information -> Email routing -> Add another destination.
3. Enter ops@fishboneconstruction.co.uk -> Save.
4. Leave his normal Gmail delivery ON (that is the "copy").
5. Takes effect in minutes (up to an hour).

## Method B (fallback) - Gmail routing rule
Admin console -> Apps -> Google Workspace -> Gmail -> Routing -> Routing -> Configure:
- Description: copy andrej to ops; Messages to affect: Inbound + Internal - receiving.
- Envelope filter: Only affect specific envelope recipients -> single recipient andrej@fishboneconstruction.co.uk.
- Also deliver to: Add more recipients -> ops@fishboneconstruction.co.uk (original delivery kept).
- Save.

## Test
Send a test email to andrej@ from another address -> it should arrive in BOTH his inbox and ops@. Eugene then checks ops@ (read-only).

## Follow-up
Peter's triage will now see Andrejus's mail in ops@ - Peter may need a routing rule for it (Hub row to Peter if wanted).

## Added 2026-11-03 - also copy SENT mail (Minda)
Per-user Email routing only covers mail he RECEIVES. For mail he SENDS, add a Gmail routing rule:
Admin console -> Apps -> Google Workspace -> Gmail -> Routing -> Routing -> Configure (or Add another rule):
- Description: copy andrej SENT to ops.
- Messages to affect: Outbound + Internal - sending.
- Envelope filter: Only affect specific envelope senders -> Single email address -> andrej@fishboneconstruction.co.uk.
- Also deliver to: tick "Add more recipients" -> Add -> ops@fishboneconstruction.co.uk (Basic). The copy is hidden from the people he writes to (like a Bcc).
- Save. Test: Andrejus sends one email to anyone -> a copy appears in ops@.
Note: emails he sends to ops@ itself, or internal mail, will also arrive in ops@ (possible duplicates - harmless).

## Decision 2026-11-03 (Minda)
Purpose: evidence check. Eugene advised Google Vault hold / private mailbox instead of shared ops@; **Minda chose copies to ops@ only.** Both rules above (received: per-user Email routing; sent: outbound routing rule). Suggested: Peter never closes/archives these copies.
