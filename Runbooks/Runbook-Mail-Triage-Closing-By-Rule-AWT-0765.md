# Draft v0.1 — Mail-triage "closing by rule" prompt changes + weekly closed list (AWT-0765)

> **Status: DRAFT for dry-run + Victoria review (2026-10-16).** Guide-only (§3): **Minda pastes the prompt
> changes** into the routine form; Eugene drafts/verifies and never edits the routines or another KB
> directly. Source of truth = group Raw owner note `2026-10-15_owner-note_closing-by-rule-and-90-day-plan.md`
> (Minda "Yes, accept that rule", 15 Oct). Hub: **AWT-0765**, due **22 Oct** (moved earlier via AWT-0805).
> Requested by Victoria, Minda approved 15 Oct. Unblocks AWT-0766.

## What this delivers
1. A **close-by-rule decision block** to add to the mail-triage routine prompt(s) — paste-ready.
2. The **weekly closed-list** design (group Outputs folder).
3. A **dry-run (shadow) procedure** — prove it on one day's rows and show Victoria *before* anything is
   actually closed.

Scope note: the rule only decides what would **otherwise escalate to Minda**. Seat-owned mail still routes
to its seat first — closing by rule never diverts a seat's mail.

---

## 1. Close-by-rule decision block (paste-ready prompt text)
> Insert this into the mail-triage routine prompt **after** classification/seat-routing and **before** any
> "escalate to Minda" step. (The exact routine prompt(s) that receive it are confirmed at hand-off — see §4.)

```
## CLOSING BY RULE — decide before escalating anything to Minda
First route seat-owned mail to its seat as normal. Then, for each item that would otherwise reach Minda,
decide: CLOSE BY RULE, or ESCALATE.

CLOSE BY RULE only when BOTH are true:
 (a) the item clearly fits ONE of these four classes, and
 (b) NONE of the Never-Close conditions below apply.

  Class 1 — Marketing: newsletters, promotions, marketing campaigns, surveys, unsolicited sales / cold
            outreach (bulk, not addressed personally; no reply expected).
  Class 2 — Auto-acknowledgements: automatic acknowledgements and auto-replies ("we received your
            message", ticket-opened confirmations, out-of-office).
  Class 3 — Automated notifications needing no action: system/service notices that require nothing from
            anyone (e.g. "backup completed", routine status mail).
  Class 4 — Information-only: a message with NO question to Minda, NO deadline, and NO money.

NEVER CLOSE BY RULE — always escalate or route, even if it looks like a class above:
  - MONEY: payments, invoices, failed/declined payments, loans, HMRC or tax deadlines, or anything stating
    an amount owed, due, paid or refunded.
  - REAL correspondence to/from OUTSIDE the group: a person outside the group writing in, or a message
    going out of the group (see tie-break 1 — bulk marketing is Class 1, not "real correspondence").
  - SHARING / PERMISSIONS / SECURITY alerts: new sign-in, password, MFA, access granted or requested,
    file/calendar sharing.
  - AUTHORITY, LEGAL or CONTRACT matters.
  - UNKNOWN SENDER asking for any action.
  - ANYTHING you are not sure about. In doubt = escalate.

TIE-BREAKS:
  1. External + marketing: unsolicited BULK marketing from outside is CLASS 1 (close it). The "outside the
     group" never-close rule protects genuine one-to-one correspondence, not bulk/automated mail. If an
     external message is a real person expecting a reply → NEVER close; route/escalate.
  2. Mixed signals: if an item fits a class BUT also touches money / security / legal / authority / an
     external reply → NEVER close; escalate.
  3. Seat mail: if it belongs to a seat, route it to the seat; do not close it.

WHEN YOU CLOSE BY RULE:
  - Mark the row closed (resolved), with a one-line reason naming the class (e.g. "Closed by rule — Class 1
    marketing").
  - Append one line to this week's closed list (see the closed-list format).
  - Do NOT send any reply and do NOT notify the sender.
```

---

## 2. Weekly closed-list design (the record)
- **Where:** group **Outputs** folder (confirm exact folder id with Victoria at hand-off).
- **Name:** match Victoria's existing file pattern **`YYYY-MM-DD_List_Closed-By-Rule_vN.md`** (she's already
  producing these by hand, e.g. `2026-10-16_List_Closed-By-Rule_v1.md`). Owner note says "weekly"; Victoria
  is doing per-sweep — **confirm with her: one file per week** under that same name pattern.
- **One line per closed item**, four fields, pipe-separated, newest at the bottom:
  ```
  | Date | Sender | Subject | Class |
  |------|--------|---------|-------|
  | 2026-10-20 | news@supplierX.com | Autumn catalogue out now | 1 Marketing |
  | 2026-10-20 | noreply@service.io | Your backup completed | 3 Automated |
  ```
- **Review cadence (from the owner note):** Minda reviews the **first four weekly lists**. The rule is
  reviewed **monthly**; **a wrongly-closed item removes its class** from the rule (tighten, don't patch).
- Keep the list human-skimmable — one line each, no bodies, no attachments.

---

## 3. Dry-run (shadow) procedure — prove it before it closes anything
**Do NOT enable live closing first.** Run the rule in shadow mode so Victoria/Minda see exactly what it
would do:
1. Take **one representative day** of the mail-triage rows (a normal weekday).
2. For each row, apply the §1 logic but **don't close** — instead record into a preview:
   - **WOULD CLOSE** — with the class + the one-line reason.
   - **WOULD ESCALATE / ROUTE** — with why not (which never-close condition, or "doesn't fit a class").
3. Produce a **two-column preview** (would-close vs would-not) and **show Victoria**.
4. Victoria/Minda confirm the would-close list is safe (special attention to tie-break 1 — external
   marketing — and any money/security near-misses).
5. Only after sign-off: Minda pastes the §1 block into the routine(s) so closing goes **live** (Phase 1).
6. The first four weekly closed lists are the ongoing safety net (§2).

**Success = no item in the would-close list should have reached Minda, and nothing that needed her is in it.**

---

## 4. Hand-off (how this reaches the routines — AFTER the dry-run)
Guide-only + cross-KB: Eugene does **not** edit the mail-triage routines or Peter's/Victoria's KB directly.
After the dry-run is signed off:
1. Confirm with Victoria **which routine prompt(s)** carry mail triage and own the escalate step (likely
   Peter's inbox-triage routine; possibly per-seat routines).
2. Assemble the **full paste-ready routine prompt(s)** (current prompt + the §1 block integrated) per the
   delivery convention (whole prompt, not a delta), filed in the owning employee's KB **via a Raw/ note +
   Hub row** (§1 hand-off), for **Minda to paste** into the routines form.
3. Reply on **AWT-0765** with the dry-run result + the hand-off reference; AWT-0766 then goes Active.

## Dry-run 1 done (2026-10-16)
Applied this rule to Victoria's 15 Oct hand-closures (28 rows):
`Runbook-Mail-Triage-Closing-By-Rule-DryRun-2026-10-15.md`. Result: **23 agree, 5 the rule would escalate
(safer), 0 over-close.** It surfaced two policy gaps → proposed rule refinements **R1–R3** (internal
colleague's own outbound/FYI; legal stays never-close; "unknown sender" closes only once a seat has fully
handled it). **Minda/Victoria to rule on R1–R3 + the 5 flagged rows**, then this §1 becomes v0.2.

## Open points for Victoria/Minda (surface at the dry-run)
- **Tie-break 1** (external bulk marketing = close; external real correspondence = never close) — confirm the
  boundary on real examples.
- Exact **group Outputs folder** for the weekly lists.
- Which **routine(s)** get the block, and whether per-seat routines each need it.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
