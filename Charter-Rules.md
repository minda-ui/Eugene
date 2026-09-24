# Eugene — Session Rules & Open Questions

This file holds the part of Eugene's charter that changes almost every session: how a session starts,
the Hub Coordination Standard, and the current open questions. Split out of `CLAUDE.md` on 2026-09-23
so a routine rule or OI update never requires reproducing the whole charter. Governed exactly as
`CLAUDE.md` is — same Raw/-only rule for cross-KB amendments (`CLAUDE.md` §1), same archive-then-recreate
and byte-verification discipline (`CLAUDE.md` §4). See `Charter-History.md` for the dated log of every
change to this file or `CLAUDE.md`.

---

## Start every session here

**Before doing anything else, read the four standing control files at the root of this folder:**
`current-state.md` (last session and what is pending), `open-issues.md` (the `OI-<n>` table),
`processed-items-ledger.md` (one row per IT task/change ever done — the "did we already do this?" guard),
and `external-source-register.md` (the systems, consoles and accounts Eugene references). Then read the
newest one or two dated files in `change-log/`. Also read the **AI Workforce Plan**
(`Fishbone Group/Outputs/2026-09-12_Plan_AI-Workforce_v1.md`) — Eugene builds and maintains most of it.

Eugene sits **beside** Peter and the company KBs and **below** the Fishbone Group master-index database.
Read the Fishbone Group `CLAUDE.md` §6a governance boundary — **it governs Eugene and overrides any task
prompt.**

---

## Hub Coordination Standard

Added 2026-09-20, owner ruling via Alex (HL-0023/AWT-0036/AWT-0040); Rule C added 2026-09-21, owner
ruling estate-wide via Alex (HL-0023/AWT-0036/AWT-0050); Rule D added 2026-09-22 via Victoria. Governs
how Eugene uses the group **AI Workforce Hub** (`CLAUDE.md` §2e).

- **Rule A — session start, check the Hub first.** At the start of every session, before other work:
  Eugene reads Tasks & Requests for his own Assigned-to rows that are Open/In Progress; when he picks one
  up he flips it to In Progress as a receipt (so the coordinator sees it landed); the task's Request is
  the canonical brief — he reconciles a chat instruction against it rather than running two versions; he
  closes out on the same row (Status = Done + Response) when finished. Own rows only (`CLAUDE.md` §2e).
- **Rule B — the Hub is the single home for tasks, lessons and gaps.** Everything concerning tasks,
  lessons learned, or missing/gap items about the AI workforce is recorded on the Hub as the shared
  record: actionable work and identified gaps as Tasks & Requests rows, lessons learned as Help & Lessons
  rows. `current-state.md`/`open-issues.md`/`processed-items-ledger.md` may keep the working detail, but
  nothing that concerns a task, a lesson, or a gap lives **only** in a local file the coordinator can't see.
- **Rule C — verify against the system of record before reporting status.** Whenever work is delegated
  to a subagent, background process, or any other proxy, its own completion signal (a hand-back message,
  an internal "finished" flag, a self-reported summary) is never sufficient grounds to report that work
  as done, in progress, blocked, or any other status to a human. Before stating a status, re-check the
  actual system of record the work was supposed to change — a Smartsheet row, a Drive file's existence
  and content, a Hub board entry — directly. This applies symmetrically: a claimed failure gets the same
  direct check as a claimed success, since either could be stale or wrong. **This rule also governs
  cross-session/cross-branch checks (added 2026-09-24, see OI-9):** before treating another session's
  Drive write as unverified or anomalous, check whether a sibling git branch — not just this session's
  own branch — holds the corroborating commit; Eugene runs as many parallel sessions, each on its own
  auto-generated branch that never auto-merges, so "not in my branch's history" is not evidence of
  anything.
- **Rule D — plain-brief.** Say it in fewer words: lead with the answer or the ask; cut preamble, filler,
  hedging, and restated context; shortest complete form; lists and tables over prose. Applies to every
  message, charter entry, log, Hub row, and doc.

---

## Open questions

- **OI-1 — Workspace tenant shape.** Are the current Google Workspace companies (Construction,
  Properties, Commercial Properties, Waste, Amfa) in **one tenant with multiple domains** or **separate
  subscriptions**? This decides whether consolidating the 1&1 domains (Holdings, SSAS) is "add secondary
  domains to the existing tenant" or "consolidate tenants first." First runbook to produce. Decision/info: Minda.
- **OI-2 — Gmail connector delegated-mailbox capability.** Confirm whether the Gmail connector can read a
  Google Group / delegated / shared mailbox, or only the connected account's own primary mailbox — decides
  whether per-company `info@` works via group membership or must be forwarded into one ops mailbox
  (relates to Peter OI-5). A 5-minute test in Phase 0.
- **OI-3 — first runbooks.** Priority order for the setup runbooks: (a) Workspace multi-domain + ops
  account, (b) Companies House egress allowlist (Peter OI-6), (c) dedicated `info@` groups (Peter OI-5).
