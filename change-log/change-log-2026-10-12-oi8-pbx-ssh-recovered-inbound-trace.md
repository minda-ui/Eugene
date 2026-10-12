# Change log — 2026-10-12 — OI-8 deep trace: PBX SSH recovered (OI-18 solved), config proven clean, inbound not arriving

_Guide-only (§3): Eugene guided, Minda executed on the live PBX; no secret held (new PBX root pw +
DocuSeal/ASA secrets all Minda-held, 1Password). Follows the DocuSeal public go-live earlier today._

## What we set out to do
Fix OI-8's "inbound calls don't ring the desk." Earlier today I wrongly flagged a NAT-shadow as the cause
(corrected — the inbound NAT already works, 469 untranslate hits). Then chased an early-media/ring-group
theory in the GUI.

## What we actually found (the honest result)
1. **The mobile `447855463292` is NOT in any FusionPBX config.** Verified every GUI screen — DID
   `01916052945` → Action `1001 Boss` (ring group); `webmate_inbound_did` dialplan = `${sip_to_user}`
   `^+44(\d{10})$` → `set destination_number=0$1` + `ignore_early_media=true`; Boss ring group members
   **1001 + 1002**, Ring Group Forward disabled, follow-dropdowns empty; extensions **1001 and 1002** —
   call-forward / on-busy / no-answer / not-registered / follow-me / DND **all disabled**. Then, over SSH,
   searched the **Postgres DB**: `su - postgres -c "pg_dump --inserts fusionpbx" | grep 7855463292` → only
   `v_event_guard_logs` (security blocks from an old Voiceflex IP), **no config rows**. So the number is
   **computed from the live call**, not stored.
2. **Right now, no inbound INVITE reaches the PBX at all.** `sngrep` (filtered to WebMate `52.28.7.189`,
   then unfiltered) on a live test call to `01916052945` showed **no INVITE** — only REGISTER keep-alives.
   `fs_cli -x "sofia status gateway"` → the WebMate gateway is **REGED**, Inbound/Outbound 0/0. So inbound
   is a **WebMate-delivery / ASA-path** problem, not a PBX-config one.
3. The earlier **10:38 FS log** (from a call that *did* arrive earlier today) showed the inbound call being
   bridged **out to `447855463292`** via the gateway — so when a call lands, there's also a mis-route (the
   greedy `webmate_inbound_did` rewrite re-dialling a mobile-number To-header). Both the delivery and the
   mis-route need an actual inbound INVITE to debug — which we can't get until WebMate delivers one.

## The real win: OI-18 solved — PBX SSH recovered
The whole reason we couldn't debug this properly was no OS/SSH access to the PBX (OI-18). Fixed today:
- Proxmox console → VM 105 reboot → UEFI → Continue → GRUB (`normal` from the `grub>` CLI) → `e` on the
  Debian entry → removed `quiet`, appended `init=/bin/bash` → Ctrl-X → `#` shell.
- `mount -o remount,rw /` → `passwd root` (new pw, 1Password) → `sed PermitRootLogin yes` → `exec /sbin/init`.
- **`ssh root@10.224.13.9` now works** — and `10.224.13.0/24` is on Tailscale, so the PBX is debuggable
  **remotely, including while Minda is away.** `fs_cli` + `sngrep` confirmed working. **OI-18 Resolved.**
- Recommendation: **keep root SSH enabled** (strong pw; box is internal-only, behind the ASA, Tailscale
  only) so OI-8 can be traced the moment WebMate delivers a call; harden to key-auth later (OI-18 tidy-up).

## Lessons
- When a value isn't in any GUI screen, `pg_dump | grep` the FusionPBX **DB** settles it in one command —
  should have gone to SSH sooner instead of ~15 GUI screenshots. (Hence prioritising OI-18.)
- `init=/bin/bash` needs GRUB's **menu** (`e`), not the `grub>` CLI — type `normal` to get the menu back.
- OI-8's "no ring" had layers; the current blocker is **carrier delivery**, confirmed by sngrep showing no
  INVITE. That's a WebMate ticket item, not a config change.

## Next session (OI-8, when WebMate delivers a call)
On the PBX over SSH: `sngrep host 52.28.7.189`, place one inbound call, read the INVITE's Request-URI/To →
if WebMate sends the mobile/main number there, **tighten `webmate_inbound_did` to match ONLY the real DIDs
(0191605294x)** so it can't re-dial a mobile-number To-header outbound. Snapshot VM 105 first, one change,
revert if no help. Chase WebMate (T02530-15072026) on why inbound isn't being delivered now.

## Artefacts
`Runbooks/Runbook-OI8-PBX-SSH-Recovery-and-Diagnosis.md` (executed — Part A done, OI-18 closed),
`Wiki/FreeSWITCH-EarlyMedia-RingGroups.md`, `open-issues.md` (OI-8 update, **OI-18 Resolved**), ledger row
103, `current-state.md`.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
