# Change log — 2026-10-10 — OI-8 inbound attempt: ASA fix worked, PBX edit caused an outage, recovered

_Honest record of a live-hours production telephony outage I (Eugene, guiding; Minda executing) caused on
the PBX, and the recovery. Guide-only throughout; no secret held. **Lesson at the end — read it.**_

## Goal
Resume OI-8: get **inbound external calls** (WebMate DDIs → desk phones) working. Minda at the ASA
console + FusionPBX GUI + Proxmox; Eugene guiding.

## What genuinely worked — the ASA inbound NAT fix (keep this)
Captured a live inbound call on the Active ASA (`fishbone-asa/sec/act#`). Proof chain:
- **capwm** (outside_fttb): WebMate sends INVITEs to `62.105.119.118:**5080**`, retransmitting (no answer).
- **cappbx** (telephony): the INVITE was **not** reaching `10.224.13.9` — only the REGISTER keepalive was.
- **packet-tracer** `input outside_fttb udp 52.28.7.189 5060 62.105.119.118 5080`: **DROP, (acl-drop)**, no
  UN-NAT phase — the ASA treated `:5080` as its own identity IP. Root cause: the existing object NAT was a
  **source-PAT** (pins PBX:5080 outbound), **not** an inbound destination forward, so unsolicited INVITEs
  to `:5080` were never untranslated.
- **Fix applied** (backup `asa-pre-oi8-inbound-2026-10-10.cfg` first): a Section-1 manual twice-NAT —
  `nat (outside_fttb,telephony) 1 source static any any destination static interface PBX-HOST service
  SVC_UDP_5080 SVC_UDP_5080` (objects `PBX-HOST` = host 10.224.13.9, `SVC_UDP_5080` = udp dest 5080).
- **Proven**: packet-tracer then showed UN-NAT → `10.224.13.9:5080`, output telephony, **ALLOW**; a real
  call's `cappbx` showed the INVITE **reaching FusionPBX** with **two-way RTP** to WebMate media
  `46.31.171.144`. The firewall inbound-delivery bug — the OI-8 core — was solved.
- ⚠️ **NOT yet `write memory`'d** — the rule is in the ASA **running-config only**; a reload reverts it.

## What broke it — PBX DID-rewrite on a live system (my mistake)
With the call reaching FusionPBX, FreeSWITCH returned **404 UNALLOCATED_NUMBER**: on this registration
trunk WebMate puts the **trunk username in the Request-URI** (`destination_number = CUP…`), and the real
**DID in the To header** (`sip_to_user = +441916052945`). So the inbound routes didn't match. The right
fix is a small `public` dialplan rewriting `destination_number` from the To header. **But** iterating on
that dialplan **on the live PBX** — multiple copies, domain/continue/field mistakes, Flush Cache + reloads
— ended with **`Local_Extension` deleted** from the domain context. That dialplan does the
extension-to-extension bridge, so **internal + outbound calls went down** (every call 480; `${user_exists}`
empty → no bridge). A VM reboot didn't fix it (the deletion was in the DB). FusionPBX "App Defaults" didn't
recreate it.

## Recovery
- Only backup was **Oct-1 07:10** (9 days old). Restored **VM 105** from it → **internal calls back**.
- The Oct-1 restore **reverted the Oct 2–5 PBX trunk fixes**: outbound `caller-id-in-from`, the providers
  ACL `52.28.7.189`, external-IP settings, and the DID-routing work.
- **Outbound restored** by re-setting the one reverted gateway param: `WebMate-SIPTrunk` **Caller ID In
  From = true** → restart `external` profile → outbound connects, clean audio. (Single gateway setting, not
  a dialplan edit; persists in FusionPBX's DB.)

## Telephony state at end of session (confirmed by Minda)
**Internal ✓ · Outbound ✓ · Inbound external ✗ (OI-8 still open).** Snapshots now taken of VM 105
(`internal-working` before the outbound fix; a second after).

## Lesson (baked in — do not repeat)
1. **Never push unproven dialplan edits on a live PBX.** Build the logic, then verify against a real/
   simulated call **before** relying on it; keep each change minimal and reversible; one change at a time.
2. **Take a Proxmox snapshot of the VM before any dialplan/config surgery** — instant rollback point.
3. **The only VM backup was 9 days old.** Set up **regular automated Proxmox backups of VM 105** (new OI).
4. FusionPBX gotchas confirmed: `public` dialplans are hidden from the domain-filtered Dialplan Manager
   list (filter by context `public`); a deleted default dialplan (`Local_Extension`) is **not** restored by
   a reboot or "App Defaults"; registration trunks put the DID in the To header, not the R-URI.

## Follow-ups
- **OI-8 inbound** — a **planned, off-hours, tested** session: re-apply the PBX inbound config lost in the
  restore (external_sip_ip private / external_rtp_ip public, providers ACL `+52.28.7.189`), add the
  To-header→destination_number rewrite **tested first**, and `write memory` the ASA inbound NAT fix. Prep a
  runbook before touching anything live.
- **New OI** — automated Proxmox backup schedule for VM 105 (and the other HQ VMs).

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
