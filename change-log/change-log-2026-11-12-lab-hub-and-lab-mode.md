# 2026-11-12 — Lab hub, Raw notes, Lab mode v1.0 in the charter

## Later: "R&D ideas should go to lab" (Minda) — OI-36 resolved
- Added the remaining 22 ideas to the Lab index (rows 24-45). All 34 RND ideas are now covered (RND-1 is the pool itself; RND-2 is "Master core Lab server").
- Status mapping: ideas already built before Lab mode existed (RND-3, 4, 5, 23, 26, 30) → **Approved**, with "Released to" pointing at where they became real; RND-20 → **Superseded** (by RND-23); RND-31 exo → **Parked**, review 1 Feb 2027. Everything else kept its spark/exploring status.
- `R&D/ideas-log.md` frozen (header note, nothing deleted); `R&D/README.md` re-headed as the working copy for Lab items.
- Charter §5: "Creative mode" now = the estate one-to-one Creative mode (chat only, nothing written). Judgement: Minda's line settles where ideas live; the old Creative mode's only job was writing ideas to `R&D/`, so keeping it would contradict her ruling. Easy to reverse if she wants the old posture back.
- Hook `.claude/hooks/creative-mode.sh` rewritten: "Lab mode on/off" and "Creative mode on/off" each inject their own posture (before, "lab mode" triggered the old R&D posture, and "Lab mode off" would have switched it ON). Tested with 5 prompts.

**Session:** attended, Minda. **Trigger:** "I think we need a lab hub to log all research" → Eugene: use the existing Lab index, not a new hub → "do all, please".

## Done
- **Lab index (not a new hub).** The master core already has one: "00 Models & Proposals Index" (Smartsheet 4471351379363716, workspace Master Core – Lab). Added 10 rows for the live R&D ideas (RND-6, 8, 13, 14, 16, 21, 29, 32, 33, 34), owner Eugene, each labelled "LAB item - not evidence, not a Hub result". Refreshed my existing row "Master core Lab server" (pve-ai built 9-12 Nov, gpt-oss).
- **Raw notes (byte-verified):**
  - Laima Raw/ `1yzp2yto4LAnJdiwV3MpLMFfRGrH_jZvN` — my rows; suggest a "Research" Kind; AWT-1147 v0.2 location.
  - Sarah Raw/ `1dunV9S-Dz79LqKhLdOPUODKAnEEJrVim` — D v0.2 answers her 7 gaps; ready for re-test.
  - Victoria Raw/ `1Gsn1MwjEY89qdJFhpAR_tNYV1FME-fpm` — "Eugene 2026-11-12: DONE - charter s5 updated" (AWT-1102).
- **Charter:** `CLAUDE.md` §5 Lab mode v1.0; `Charter-History.md` entry.

## Judgement calls
- **No Hub rows** for the Raw notes: Lab mode v1.0 rule 5 forbids Hub rows from Lab work, and the raw-handoff skill's usual Hub row would break it. The Lab mode reply went to Victoria's Raw (as Darius did), since AWT-1102 is not an Eugene row.
- **Creative mode not changed.** My Creative mode (writes to `R&D/`) differs from the estate's one-to-one Creative mode. Not mine to settle: raised as OI-36 with a recommendation (rename mine "R&D mode").
- Did not touch the Kind picklist (Laima's sheet design).
