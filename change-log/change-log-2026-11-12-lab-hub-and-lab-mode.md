# 2026-11-12 — Lab hub, Raw notes, Lab mode v1.0 in the charter

## Update 2026-11-12 ~21:35 UTC — evening: RND-35 trial, HQ line correction, /29 form, RND-36

**Lab (RND-35, DeepSeek Harness)**
| Step | Result |
|---|---|
| Desk research | code read at `e8f7b93a3`; can use our gpt-oss; telemetry ON by default (session upload on feedback) |
| Trial | CT 220 `dsh-lab` (10.224.10.36), read-only, telemetry off, no internet; 26.5 min; 0 invented systems |
| Test 1 | plain Fishbone AI + same facts pack: as good, ~20 min → **gain = facts pack, not harness** |
| Recommendation | park for reviews (Minda decides); keep facts pack current |

**Live changes made by Minda for the trial (all reversible, all off now)**
- CT 220 `dsh-lab` on pve-ai — **stopped**, not on boot.
- CT 200 `lab-llama-fwd.service` (socat 10.224.10.31:9001 → llama-swap, only from .36) — **disabled**.
- hq-fw-a/b MGMT: "dsh-lab replies to Minda PC" (pass, TCP, src port 3080 → 10.224.111.11, sloppy, flags any) + "dsh-lab no outbound" (block .36 → any, logged) — **kept**.
- Fishbone AI: "Enable API Keys" switched on, user `lab-dsh` + group `lab` created — **not needed in the end** (normal users get no keys in this version); tidy-up suggested.
- Lessons: dsh refuses telemetry vars in `.env` (export them); asymmetric Beverley path needs **TCP flags any** on the reply rule.

**HQ main line — corrected (Minda):** 62.105.119.118/30 is a **Sky 1Gb leased line supplied by RMT Technology**, 5-year contract signed 2025 — not "Wavenet" (long-standing misname). Plan, inventory, map fixed. Open: what Giacom order 5020640 is.
**/29 upgrade:** reason email sent by Minda; provider change-request form (sections I–IV) filled by Eugene and left as a **draft in minda@** (phone + company name to check). Two wrong versions (Sky-new, Wavenet) deleted.
**Mail lesson:** the Gmail MCP connector here is **ops@**; Composio's default Gmail account is now **enquiries@amfa.uk** → always use `--account eugene-gmail` (minda@). A first draft went to ops@ by mistake and was deleted.

**RND-36 Estate Library** added (Minda: "one big library … only not working together"): locked library on pve-ai + Drive work copies, tie existing pieces together. Alexey's 5 Oct "archiving" method (1983 document-flow regulation) saved as its source note.

## Later: "R&D ideas should go to lab" (Minda) — OI-36 resolved
- Added the remaining 22 ideas to the Lab index (rows 24-45). All 34 RND ideas are now covered (RND-1 is the pool itself; RND-2 is "Master core Lab server").
- Status mapping: ideas already built before Lab mode existed (RND-3, 4, 5, 23, 26, 30) → **Approved**, with "Released to" pointing at where they became real; RND-20 → **Superseded** (by RND-23); RND-31 exo → **Parked**, review 1 Feb 2027. Everything else kept its spark/exploring status.
- `R&D/ideas-log.md` frozen (header note, nothing deleted); `R&D/README.md` re-headed as the working copy for Lab items.
- Charter §5: "Creative mode" now = the estate one-to-one Creative mode (chat only, nothing written). Judgement: Minda's line settles where ideas live; the old Creative mode's only job was writing ideas to `R&D/`, so keeping it would contradict her ruling. Easy to reverse if she wants the old posture back. **Confirmed by Minda the same evening:** "'Creative mode' is mode for us to have one to one session."
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
