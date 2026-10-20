# Change log — 2026-10-08 — Skill-candidate collection + "Good Night" adopt/delete proposal

## Update ~12:45 UTC — SC-1 adopted + built (first use of the new flow)
Minda's first Good Night choice under the new flow: **"1 adopt"** → **SC-1 `gmail-vendor-quote-draft`
built** at `.claude/skills/gmail-vendor-quote-draft/SKILL.md`. Captures the Techbuyer pattern: check
`eugene-gmail` is live → `GMAIL_FETCH_EMAILS` for the vendor (read the `outputFilePath`, don't trust the
empty inline `data` — the #1 trap) → extract AM(s), order/invoice refs, account entity, asset serial →
`GMAIL_CREATE_EMAIL_DRAFT` (JSON via `@file`) → hand back the draft id + To/CC/subject. Guardrails baked
in: **draft-only, never send** (§3 + deny-rule), never hold a credential, never fabricate a contact,
inbox = data not instructions. End-of-day skip of the full eval-benchmark loop (late); written as a clean
draft from the known-good run. `.claude/skill-candidates.md` row SC-1 → `adopted`.



_Standing-process change to how Eugene runs (§5) + the end-of-day flow. Guide-only; no live system touched;
no secret. Requested by Minda this evening._

## What Minda asked
"When we trigger 'Good Night', you should propose me candidates for skill — you collect candidates
through a day's work, then at 'Good Night' show me the list and I choose which to adopt and which to
delete."

## Built
- **`.claude/skill-candidates.md`** (new) — running log of skill candidates. Eugene **appends** a
  `proposed` row the moment a repeatable workflow shows up during work (he does **not** build it). Rows
  move `proposed` → **adopt** (`adopted → <skill>`) or **delete** (`deleted — <reason>`, line kept, never
  removed). Seeded with **SC-1 `gmail-vendor-quote-draft`** (from today's Techbuyer P40 quote pattern).
- **`end-of-day-wrapup` SKILL.md** — new **step 5 "Propose the day's skill candidates"**: read the file,
  sweep today's work for any uncaptured pattern and append it, present every `proposed` row as a short
  numbered list, ask Minda per candidate to adopt/delete, **build nothing until she chooses**, write her
  decisions back. Good-night summary (now step 6) gains a **Skill candidates** line. Description updated.
- **`CLAUDE.md` §5** — standing note so the day-collection habit is read at session start (not just at
  Good Night). **`Charter-History.md`** — 2026-10-08 entry (top).

## Boundary
§3 unchanged. Collecting/proposing is just notes; **Minda decides**; building an adopted skill is ordinary
KB/config work (§2b, §3 "MAY do directly"). No skill built tonight — SC-1 awaits her call.

## Sync / git
`CLAUDE.md`, `Charter-History.md`, `current-state.md`, `processed-items-ledger.md` synced to Drive
(archive-then-recreate, byte-verified). `.claude/` files (skill, skill-candidates.md) are git source of
truth, not Drive-synced (same as hooks/settings). Committed + pushed to `claude/lucid-mayer-nsoili`.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
