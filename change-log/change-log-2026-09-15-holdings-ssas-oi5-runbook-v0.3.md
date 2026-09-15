# Change log — 2026-09-15 — Holdings reported migrated, SSAS drops out, OI-5 raised, runbook v0.3

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4. (Second dated file for 2026-09-15; the first bumped the runbook to v0.2.)_

## 2026-09-15 — §2 answers received; consolidation runbook updated to v0.3

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Context.** Eugene drafted a §2 prerequisites checklist for
`Runbooks/Runbook-Workspace-Consolidation-into-Construction.md`. Minda answered items as the session
went, starting with item 1 (super-admin identity per subscription).

**Answers received and clarified (AskUserQuestion used for genuine ambiguity — the answer format
could have meant either "the admin login" or "the current contact address," and "Holdings now under
Construction" could have meant anywhere from "fully migrated" to "just a restated decision"):**
- Item 1 (super-admin): each subscription's super-admin login **is** the shared business mailbox
  itself — Construction `info@fishboneconstruction.co.uk`, Properties `info@fishboneproperties.co.uk`,
  Waste `sales@` (domain tbc), Amfa `info@` (domain tbc). Not a separate named admin account.
- Holdings: **already fully migrated** — added as a secondary domain under Construction, verified, MX
  cut over, mail flowing. Not merely a decision or a partial step.
- SSAS: **has no domain or Workspace of its own** — nothing to migrate; drops out of the plan.
- Item 2 (Construction hub headroom), supplied mid-turn: **Business Standard** edition, 0 free seats,
  up to **3 more licences** can be added.
- Item 3 (exact domains), supplied mid-turn: Holdings = `fishboneholdings.co.uk`, SSAS = confirmed no
  domain, Waste = `fishbonewaste.co.uk`, Amfa = `amfa.uk`.
- Item 4 (DNS control), supplied mid-turn: Minda holds registrar access for both
  `fishboneholdings.co.uk` and `fishbonewaste.co.uk` (SSAS n/a). This closes out every §2 item for
  Waste except mailbox count/mail volume (§2.5) — the one thing still blocking §4.
- Item 5 (mailboxes/volume), supplied mid-turn: Waste has **2 mailboxes** — `info@` and `sales@`.
  Owner added an explicit precaution: **archive the historical mail/Drive data before migrating**,
  not just re-point and move on. **§2 is now fully answered — nothing left blocking §4 on
  prerequisites.** Rewrote §4 step 1 from an optional "inventory + export" into a required
  archive-first step, and flagged two open decisions for Minda rather than assuming an answer: where
  the archive should live (no visibility into a Waste KB, if one exists), and whether `info@`/`sales@`
  stay live under Construction post-migration or the archive alone suffices — the precaution answers
  "don't lose history," not "do these inboxes keep receiving mail."

**Verification attempted, blocked.** Tried to independently confirm the Holdings migration via DNS —
first without a domain name (`dig`/`nslookup` not installed; `python3 -c "import dns.resolver"` also
unavailable), then a DNS-over-HTTPS fallback via `dns.google`, rejected by the session's egress proxy
(organisation policy — the same restriction that originally blocked Peter's Companies House access).
Retried once the exact domain (`fishboneholdings.co.uk`) was supplied — same result, still blocked.
**Could not verify.** Recorded Holdings' migration as owner-reported, not yet Eugene-verified, and
flagged the outstanding check rather than silently accepting or silently dropping it.

**Advisory raised.** A shared business mailbox acting as the super-admin login (rather than a
dedicated named admin account) means anyone with inbox access has full Workspace admin rights, with no
separate break-glass identity. Not blocking anything — recorded as **OI-5** (open, advisory) for the
owner's awareness; Eugene took no action (guide-only for live systems, charter §3).

**Produced/updated.**
- `Runbooks/Runbook-Workspace-Consolidation-into-Construction.md` **v0.2 → v0.3**: §1 target
  architecture updated (Holdings done, SSAS removed); §2 prerequisites annotated with the answers
  received and what's still outstanding (Waste's domain, DNS control, mailbox volume); §3 rewritten
  from a forward plan into a verification checklist for Holdings, with the blocked-DNS note; §7/§8
  updated — Waste is now the only remaining migration track.
- `open-issues.md`: OI-4 updated with the 2026-09-15 development; **OI-5** added (advisory, open).
- `Infra-Inventory/Workspace-and-Email-Inventory.md`: Holdings and SSAS rows rewritten; target
  architecture section updated; super-admin identity table added; "to confirm next" list narrowed to
  what Waste and the Holdings DNS check still need.
- `processed-items-ledger.md`: row 2 added.

**Governance.** All documentation-only; no live-system change, no credential touched, no console step
taken by Eugene. The DNS check was an attempted **read-only verification** (charter §2a), not a change
— its failure is reported, not worked around.

**Later same day — Holdings MX verified via screenshot; SPF loose end found.** Minda shared a
screenshot of `fishboneholdings.co.uk`'s DNS records from the 1&1/IONOS panel (Domains & SSL → DNS).
Eugene's own DNS tooling stayed unreachable all session, so read the screenshot directly: **MX record
points to `smtp.google.com`** — Google Workspace's current single-record MX target — confirming mail
for this domain genuinely routes to Google. This closes the outstanding Holdings verification the
runbook had flagged as blocked.

Also visible in the same screenshot: the **SPF TXT record still references IONOS's mail servers**
(the 1&1 SPF include), not Google's. MX governs incoming mail (now confirmed fixed); SPF governs
whether outgoing mail sent through Google's servers is authenticated — left as-is, mail sent from this
domain via Google Workspace risks failing SPF at the receiving end. Not urgent (matters once the
domain actively sends via Google), but flagged as a follow-up: add `include:_spf.google.com` to the
SPF record in the 1&1 panel. Also clarified: `fishboneholdings.co.uk` is still DNS-managed at
1&1/IONOS — normal for a Workspace secondary domain, no registrar move required; "off 1&1" in earlier
notes meant off 1&1's *mail hosting* specifically.

**Governance note on the screenshot itself.** Per the runbook's own rule ("no secret — password, TXT
value, token — is ever written into this file"), recorded the *findings* (MX target, SPF still
IONOS-pointed) in plain text; did not transcribe or store the screenshot's Google site-verification TXT
value or any other literal DNS record value. The image itself was not committed to the repo.

**Produced/updated (this addendum).** Runbook §3 rewritten from a blocked-verification note into a
confirmed-verification section with the SPF follow-up; §8 and the version header updated to match.
`Infra-Inventory/Workspace-and-Email-Inventory.md` Holdings row updated with the verified MX and the
SPF follow-up; "to confirm next" trimmed. `processed-items-ledger.md` row 5 added.

**Later still same day — SPF finding formally tracked as OI-6.** At Minda's request, promoted the SPF
finding from runbook/inventory prose into a tracked issue: **OI-6** added to `open-issues.md` (open,
task, not blocking) — the fix (`include:_spf.google.com` in the 1&1 DNS panel) and verification path
recorded there as the single source of truth; runbook §3.6/§8 and the inventory now cross-reference
OI-6 instead of just describing the finding inline. `processed-items-ledger.md` row 6 added.

**Later still same day — §4 step 2 decided: both mailboxes stay live.** Minda confirmed
`info@fishbonewaste.co.uk` and `sales@fishbonewaste.co.uk` will be **re-provisioned as live mailboxes
under Construction** post-migration, in addition to the archive from step 1 — the archive-first
precaution was about preserving history, not a signal these addresses go dormant. Closes one of §4's
two open decisions. Noted as a follow-on: `sales@` is also Waste's super-admin login (OI-5) — whether
that admin role carries over to Construction or a new super-admin gets assigned once Waste's own
Workspace is cancelled (step 5) is a separate decision, not yet asked.

**Produced/updated (this addendum).** Runbook §4 step 2 rewritten from an open question into a
decided step; §4 intro and §8 updated to reflect only one open decision left (archive location).
Inventory Waste row and "to confirm next" updated to match. `processed-items-ledger.md` row 7 added.

**Later still same day — archive destination confirmed; §4 fully decided; bumped to v0.4.** Minda
confirmed Waste has its own KB, `Fishbone Waste Ltd - Knowledge Base`. Located it via Drive search
(`mcp__Google_Drive__search_files`) — folder id `1LMVTPw4YFw9OmW7GcTjaDEfXqCIjp1ZJ`, standard group KB
shape (`CLAUDE.md`, `README.md`, `Archive/`, `Outputs/`, `Wiki/`, `Raw/`). Checked `Raw/` (id
`1TlNINqtx8JU1Qe6152uqhEPZEvt7JN_C`) and found it already holds a hand-off precedent
(`2026-09-10_handoff_group-to-waste_...`) plus the group's document-numbering/filing policy — so the
pre-migration mail/Drive archive goes there, per the group §7a hand-off rule (Eugene charter §3: may
add to another KB's `Raw/`, never edit/move/delete elsewhere in it), following the existing naming
convention rather than inventing a new one. Minda also confirmed `sales@fishbonewaste.co.uk`'s
super-admin role (OI-5) resolves itself at step 5: once Waste's own Workspace subscription is
cancelled, there's no separate Workspace left for it to be super-admin *of* — no carry-over decision
needed.

**§4 is now fully decided end-to-end, with nothing left open.** Rewrote the runbook's status header
and bumped to **v0.4** ("ready to execute"); registered the Waste KB as **SRC-9** in
`external-source-register.md`; updated the inventory's Waste row and "to confirm next" to point at the
finished decision set. `processed-items-ledger.md` row 8 added.

**Next.** Outstanding: (1) OI-6 — Minda fixes Holdings' SPF record in the 1&1 panel, low urgency; (2)
§4 (Waste) is ready for Minda to execute in the consoles whenever she chooses — archive → re-provision
→ domain move → MX cutover → cancel Waste subscription → verify; (3) OI-5 (the *other* subscriptions'
shared-mailbox admin logins) remains the owner's call, not time-sensitive.
