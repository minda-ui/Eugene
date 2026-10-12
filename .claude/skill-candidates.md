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
| SC-2 | 2026-10-11 | `tailscale-subnet-router` | Stand up (or verify) a Tailscale subnet router on a Proxmox host for a site: install one-shot that survives the Proxmox enterprise-repo 401, enable IP-forward, `tailscale up` advertising that site's LAN /24s (CCTV excluded), then the admin-console checklist (approve routes + disable key expiry) and the mandatory off-network (4G) verify. | Ran the identical sequence twice today (HQ + Beverley, RND-5) and it's due again for the 2nd-node-per-site lockout safeguard and any future site — same steps, same gotchas each time. | adopted → `.claude/skills/tailscale-subnet-router/` (2026-10-11) |
| SC-3 | 2026-10-12 | `raw-handoff-to-employee` | Deliver a §1 cross-KB hand-off end-to-end: find the target employee's KB `Raw/` folder in Drive, byte-verify-upload the note (archive-then-recreate), allocate the next free `AWT-####` by re-reading the live Hub max at write time (so the duplicate-guard doesn't fire), and add the Tasks & Requests row naming the hand-off + pointing at the note. | Did it twice today (Anna `AWT-0589`, Alex `AWT-0594`) and it's the standing §1 mechanism for every hand-off to another assistant; hit the AWT duplicate-guard once when a concurrent session had moved the max — the skill would bake in the re-check + the folder-lookup + the byte-verified upload. | proposed |
