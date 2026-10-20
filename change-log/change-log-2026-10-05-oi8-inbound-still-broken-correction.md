# Change log — 2026-10-05 (late, correction) — OI-8: premature "Resolved" RETRACTED; inbound external calls still never reach the PBX

_Guide-only: Minda at the FusionPBX GUI / ASA console; Eugene guided and verified from screenshots. No
credential held. This entry **supersedes the conclusion** of
`change-log-2026-10-05-oi8-inbound-ring-RESOLVED.md` — that file is left in place as an honest record of
what was believed at the time (same principle as OI-9/OI-12), but its "OI-8 RESOLVED / all three
directions" headline is **wrong** and is corrected here._

## Headline
**OI-8 is NOT resolved.** Outbound, internal and the fibre WAN are genuinely fixed and confirmed. But
**inbound external calls from the WebMate trunk still do not reach FusionPBX at all** — and the earlier
"inbound rings 1001 / all three directions working" claim was a misread on my part, retracted here.

## What I got wrong (and how it was caught)
- I interpreted Minda's "all good" as *inbound working*. It only confirmed two *internal* things: the DID
  `01916052945` was routed to extension `1001`, and an **internal** test call (1002→1001) rang the desk
  phone after the handset power-cycle. Neither is a real inbound call from the trunk.
- I then wrote OI-8 up as **Resolved**, committed, pushed and synced. Minda corrected it at once:
  "Inbound still no work… 10s delay and no ring on 1001," then decisively, with CDR screenshots:
  **"Incoming calls is not registering here. Last Incoming call was registered on 21 July."**

## The real, still-open problem
- **No inbound CDR since 21 July 2026.** Every call that "rang" during today's testing was **internal**
  (1002→1001) or an **outbound loopback** (Minda calling in *from* her own mobile, which the stale DID
  forward sent straight back out to that same mobile). None was a genuine inbound call landing in the
  dialplan.
- **The INVITEs reach the ASA but are not forwarded to the PBX.** Earlier capture on `outside_fttb`
  showed **581 pkts `52.28.7.189:5060 → 62.105.119.118:5080`** (WebMate's Oracle vSBC sending our DDI
  calls to the fibre public IP). But the ASA object-NAT rules `PBX-SIP-FTTB` / `PBX-SIP-BT`
  (`host 10.224.13.9`, `service udp 5080 5080`) show **`translate_hits=0, untranslate_hits=0`** — the
  inbound leg matches **nothing**, so it never reaches FusionPBX `10.224.13.9:5080`. Zero inbound CDR is
  the exact expected symptom.
- So the OI-8 core is an **inbound firewall / NAT delivery** problem (and possibly a FusionPBX
  external-profile Contact / registration-path nuance), **not** the early-media / handset / DID issues we
  chased. `inspect sip` (SIP ALG) is already off, so that's not it.

## What genuinely IS fixed (stands)
- **1Gb fibre** = primary WAN again (track6 Up, `62.105.119.118`, ~561/153); office off StarLink/CGNAT.
- **Internal** calls ✓.
- **Outbound** calls ✓ with **clean two-way audio** (gateway `caller-id-in-from`=True stopped WebMate
  403-ing the From). This is real and confirmed by Minda.
- ASA + switch configs saved (`write memory`); FusionPBX persists to its DB.

## Plan for Minda's 5-day absence (reliability is the whole point)
Minda is away 5 days with **no rack access**, and cannot be left with dead inbound. Two paths:

1. **PREFERRED — finish it properly over the existing remote-access VPN.** The 10-01 recovery notes show
   remote-access infrastructure **already exists**: the ASA holds a **VPN Premium licence** and accounts
   **`vpn2` / `vpn-user-1`** ("one likely Minda's phone"); OPNsense (VM 101) also has an **IPsec
   remote-access** instance. If Minda can VPN onto the LAN from off-site, she can SSH to the Proxmox host
   → FusionPBX (live FreeSWITCH logs / `sngrep` / `tcpdump` — far better diagnostics than the GUI) and
   reach the ASA inside interface, and we finish the inbound NAT/ACL fix with me guiding, exactly as at
   the rack. **Critical de-risk: TEST the VPN from 4G (off the office LAN) BEFORE she leaves**, while the
   rack is still a safety net. **Do NOT** open a new external SSH / port-forward on the perimeter, and
   **do NOT** re-enable VM 104 `ssh-gateway` (the contractor's old backdoor, deliberately shut down 10-01).
2. **FALLBACK — WebMate provider-level divert.** If the VPN can't be made to work in time, ask WebMate
   (ticket **T02530-15072026**) to divert all four DDIs at their end to a mobile for the 5 days — zero
   equipment risk — then fix inbound for real when she's back. Draft request:
   ```
   Ref: trunk CUP4127366SIP1, DDIs 01916052945–948
   Please apply a DIVERT / call-forward AT YOUR END on all four of our DDIs
   (01916052945, 946, 947, 948) to the mobile number: <MOBILE TO ANSWER>.
   We have an inbound-delivery issue our side and need incoming calls routed
   to that mobile while we resolve it. Please confirm when active.
   ```

## For the clean fix when there's console/SSH time
1. On the ASA: `show nat` (read the Section-2 `PBX-SIP-FTTB` hit counters — **not** `| include`, which
   hides them), `show access-list`, and **`capture` on `outside_fttb`** during a live inbound call to see
   whether the INVITE is translated toward `10.224.13.9:5080` or dropped.
2. On FusionPBX (via SSH): tail the FreeSWITCH log / `sngrep` during an inbound call — confirm whether the
   INVITE ever arrives at the PBX at all. If it doesn't arrive, it's purely the ASA NAT; if it arrives and
   is rejected, it's the external profile / ACL.
3. Likely fix: correct the inbound static NAT so `62.105.119.118:5080` (what WebMate actually targets) is
   untranslated to `10.224.13.9:5080`, and confirm the FusionPBX external profile Contact matches.

## OI-8
**OPEN.** Outbound + internal + fibre fixed; **inbound never reaches the PBX (no inbound call since
21 July; `untranslate_hits=0`).** Premature "Resolved" retracted. No credential held throughout.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
