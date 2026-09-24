# Change log — 2026-09-24 — AWT-0090: Rachel's M365/OneDrive connector scope review

Minda asked directly: "Eugene can you help me with 'Rachel — Microsoft 365 / OneDrive connector grant'"
— the title of an Authority Register row (RA-22, Rachel's log).

**Found the live context.** Hub Tasks & Requests already carries **AWT-0090** (Assigned to Eugene,
Priority High, Status Open, no due date — explicitly flagged in the row itself as "Eugene's or Victoria's
to set, not Rachel's"). Rachel had, on 2026-09-24, verified the real grant at source (`get_granted_scopes`,
`get_me`) rather than trusting the old RA-22 text: the connector holds **29** delegated Microsoft Graph
scopes, not the 4 originally logged. Eugene made no Microsoft 365 tool calls himself — he carries no M365
connector of his own (charter §1 Connectors list) — everything used here came from Rachel's own relayed
findings on the Hub row.

**Reviewed the scope list against Rachel's charter-stated authority and RA-20(3):**
- **Keep** — `Files.Read`, `Files.Read.All`, `Files.ReadWrite.All` (justified: write-to-retire on OneDrive
  for financial-document consolidation).
- **Drop** — 9 mail/mailbox scopes including `Mail.Send` (Rachel's charter never grants a send
  capability), 6 Teams/chat scopes, 5 online-meeting scopes, and `Sites.Read.All` (every SharePoint site
  in the tenant — not currently in scope).
- **Flagged highest-priority** — `Mail.Read.Shared` and `Calendars.Read.Shared`, since these reach other
  people's data, directly against Minda's standing company-documents-only rule.

**Surfaced an open question rather than assuming:** the connector signs in as
`info@fishbonedrylining.onmicrosoft.com`, a different tenant from `fishboneconstruction.co.uk`. Plausibly
just the tenant's pre-rename `.onmicrosoft.com` default domain (Construction was formerly Fishbone
Drylining Ltd), but flagged for Minda to confirm before anyone acts, since it decides who has the
authority to touch the grant.

**Wrote `Runbooks/Runbook-M365-Connector-Scope-Narrowing-Rachel.md` (v0.1)** — two independent narrowing
paths: **Path A** (`claude.ai/customize/connectors` per-tool permission toggles — fast, no tenant-admin
role needed, but only restricts what Claude calls, not the underlying Microsoft consent) and **Path B**
(Entra ID app-consent revoke/narrow on the `fishbonedrylining` tenant — the real fix, needs a tenant
admin, exact console steps flagged as needing confirmation at execution time since Eugene has no way to
verify the live Entra ID UI himself). Recommended doing both, A first.

**Updated Hub AWT-0090:** Status → In Progress, Due date → 2026-09-29, Response/result recorded with the
full findings and the two open decisions for Minda.

**Entirely guide-only** (charter §3) — this is a live, credentialed connector/tenant-consent change;
Eugene produced the analysis and the runbook, execution is Minda's/IT's.

**Files:** `Runbooks/Runbook-M365-Connector-Scope-Narrowing-Rachel.md` (new), `processed-items-ledger.md`
(row 30), `current-state.md`, Hub AWT-0090. All to be synced/byte-verified to Drive.
