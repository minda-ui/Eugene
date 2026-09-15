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

**Next.** §2 is fully answered for Waste. Outstanding: (1) Minda confirms the Holdings MX resolution
herself, or Eugene retries DNS verification from an environment with egress; (2) Minda decides where
the Waste mailbox archive should live and whether `info@`/`sales@` stay live post-migration (§4 open
decisions); (3) once those two are settled, §4 can be executed; (4) OI-5 is the owner's call, not
time-sensitive.
