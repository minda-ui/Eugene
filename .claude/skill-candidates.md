# Skill candidates — Eugene

_Running log of **skill candidates** Eugene spots during the day: repeatable workflows that could become
a reusable skill (like `drive-sync-verified`, `end-of-day-wrapup`, `composio-routine-setup`). Eugene
**appends** a candidate the moment a repeatable pattern shows up during work — he does **not** build it.
At **"Good Night"** the `end-of-day-wrapup` skill shows Minda every `proposed` candidate; **she** decides
which to **adopt** (Eugene then builds it via the skill-creator) and which to **delete** (dropped, kept
as a record). Added 2026-10-08 at Minda's instruction._

## How a row moves
`proposed` → Minda's call at Good Night → **adopt** (build next session, status `adopted → <skill name>`)
or **delete** (status `deleted — <one-line reason>`). Never delete a row outright; mark it, keep the line.

## Candidates

| ID | Spotted | Candidate skill | What it would automate | Seen / why | Status |
|----|---------|-----------------|------------------------|------------|--------|
| SC-1 | 2026-10-08 | `gmail-vendor-quote-draft` | Search minda@ for a named vendor, pull contacts + prior order/invoice refs, and draft a quote/enquiry email that references the existing account — draft-only, never send. | Done ad-hoc for the Techbuyer P40 quote (2026-10-08); the "find the vendor, cite past orders, draft to the right AM" shape will recur for any parts/supplier request. | adopted → `.claude/skills/gmail-vendor-quote-draft/` (2026-10-08) |
