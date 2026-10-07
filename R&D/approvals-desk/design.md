# RND-9 — Estate Approvals Desk (design)

_Status: exploring (2026-10-07). Creative-mode R&D; stays out of the control files until graduated.
Guide-only (§3): Eugene builds the scaffolding; **Minda approves and applies** the real-world step; no
secret held; cross-KB changes via `Raw/`; Hub shared-space changes are broadcast (Rule F)._

## The problem
The same pattern is being rebuilt ad-hoc in five corners of the estate:
- **Helen** — a Change Request so Minda approves ad spend.
- **Rachel** — a Gmail guard so sends are gated (Dext-only exception).
- **Anna** — a RAMS goes out only when a human sends it.
- **Eugene** — guide-only; Minda executes every live infra change.
- The model's **"Real-World Transactions"** guardrail — insisting a human commits the money/irreversible step.

Five costumes, one idea: **AI proposes → Minda approves → the action is applied → the outcome is logged.**
Today it's inconsistent, invisible (no single place to see what's waiting), and only partly audited.

## What the Desk is (and is NOT)
- **It IS** the uniform *request → approval → record* layer for any real-world/irreversible action, plus one
  inbox for Minda and a full audit trail.
- **It is NOT** a way to let AIs *execute* money/irreversible actions. **§3 is unchanged**: the human still
  applies the irreversible step. The Desk standardises the ask, the sign-off, and the record — not who clicks.

## Core object — an "Action Request" (AR)
| Field | Meaning |
|---|---|
| **AR-ID** | `AR-<employee>-<n>` |
| **Opened / by** | timestamp · which AI employee |
| **Company / account** | e.g. Amfa Furniture Ltd · Google Ads |
| **Action type** | from the taxonomy below |
| **Target** | what/where it lands (campaign, mailbox, DNS record, DDI, file) |
| **Exact change** | the precise thing to do — unambiguous, bounded |
| **Rationale / metric** | why, and how success is judged |
| **Cost / budget impact** | £ and the cap that bounds worst case |
| **Reversibility** | how to undo (every AR must be reversible or say why not) |
| **Risk** | low / medium / high + flags |
| **Status** | Draft → **Pending** → Approved / Rejected / Needs-info → **Applied** → Done / Expired |
| **Decision / by / note** | Minda's call + comment |
| **Applied by / when** | who executed + where |
| **Outcome** | result vs metric, at review |

## Action-type taxonomy (and who applies by default)
| Type | Examples | Default apply-by | Note |
|---|---|---|---|
| **ad-spend** | add keywords, change bid/budget | **Minda** | Helen; broad match = always flag |
| **payment** | pay/authorise an invoice | **Minda** | Rachel; AI never pays (§3) |
| **outbound message** | email/forward to a new recipient | **Minda** | Rachel (Dext is a standing pre-approval) |
| **document send** | RAMS to signers; a letter out | **Minda** / the eSign flow | Anna |
| **infra change** | DNS/MX, firewall, prod config | **Minda executes** | Eugene stays guide-only |
| **data delete** | delete files/records | **Minda** | archive-never-trash is the default answer |
| **provisioning** | create/remove an account | **Minda** | |

Default = **human applies**. A *specific* action type could later be marked "employee may apply the exact
approved item" (narrow, reversible, logged) — Minda's call per type, off by default.

## Lifecycle
1. **Draft** — the employee fills the Action Request template (one per change set), bounded + reversible.
2. **Pending** — employee writes the AR as a row on the Hub **Approvals** sheet and (P2+) a Telegram ping
   fires to Minda.
3. **Decision** — Minda sets Approved / Rejected / Needs-info + a note (in the sheet, or P3 one tap in
   Telegram that writes back).
4. **Applied** — Minda (default) applies the exact approved action; records applied-by/when.
5. **Outcome** — at the review date the employee records the result vs the metric; durable lessons → that
   employee's KB / Help & Lessons.
6. **Expired** — a Pending AR past its window auto-lapses (no silent spend).

## Where it lives
- **System of record:** a new **"Approvals — Action Requests"** sheet in the AI Workforce Hub (Smartsheet,
  "Fishbone AI Workforce" workspace) — the estate's existing coordination home. **Minda creates/owns it**
  (shared-space change → broadcast per Rule F); Eugene supplies the exact column design.
- **Notification/approval surface:** **Telegram** to Minda's phone — the request as a card, tap
  Approve/Reject where she already works. Ties to the RND-7 Telegram worker.

## How it folds in the existing guards (not a replacement)
The technical guards stay and *enforce at the tool level*; the Desk is the human-visible governance layer on
top:
- Rachel's `gmail-recipient-guard` hook still blocks non-Dext sends; a new recipient becomes an AR.
- Helen's Change Request **is** an AR (ad-spend type) — she's already using it.
- Eugene's guide-only infra changes become AR rows too (so there's one audit trail, not scattered runbooks).

## Build phases (guide-only; each stands alone)
- **P0 — the template + taxonomy.** Ship the standard **Action Request** template (companion file) and the
  action-type list. Employees use it immediately (Helen already does). **Zero infra.**
- **P1 — the Hub sheet.** Minda creates the Approvals sheet (Eugene gives the column spec); employees write
  Pending rows; Minda approves in-sheet; a weekly "pending approvals" digest.
- **P2 — Telegram notify (one-way).** A ping to Minda when an AR goes Pending (via the RND-7 Telegram worker).
- **P3 — Telegram tap-to-approve (two-way).** The bot writes Minda's Approve/Reject back to the sheet.
- **P4 — auto-raise + close the loop.** RND-6 (silent-failure alarm) *raises* an AR when a failure needs a
  decision ("trunk down — approve failover?"); outcomes flow back to each employee's KB.

## Safety / governance (unchanged by this)
- **§3 holds:** AI never applies a money/irreversible action — Minda does. The Desk adds structure + audit,
  not execution rights.
- **No secrets** held or typed by Eugene; the Telegram bot token is Minda's (RND-7).
- **Cross-KB** via `Raw/`; **Hub** sheet is a shared-space change Minda owns and broadcasts (Rule F).
- **Archive-never-trash**; a rejected/expired AR stays on the record.

## Open questions for Minda
1. **First surface:** start with the **Hub sheet** (audit-first) or a **Telegram** card (fast on your phone)?
   (I'd do the sheet first — it's the record — then add Telegram.)
2. **Approvers:** only you, or a delegate per company?
3. **Per-type "employee may apply":** keep everything human-applied (safest), or allow it for a named
   low-risk, reversible type later?
4. **Expiry window** for a Pending AR (e.g. 48 h) before it lapses.

## Why this is worth graduating
It turns five ad-hoc guards into one coherent, auditable governance spine — the thing every AI employee and
every real-world action already needs — and it's the natural backbone under RND-2/6/7. It's also exactly
Eugene's remit (§2b, workforce infrastructure). Graduates to: a Hub sheet + the shipped template + a note in
each employee's `Raw/` to adopt it.
