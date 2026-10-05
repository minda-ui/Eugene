# Change log — 2026-10-05 — OI-8: external calls DOWN BOTH WAYS (honest correction + night-shift plan)

_Guide-only: Minda at the ASA console (`fishbone-asa/sec/act#`) and FusionPBX GUI; Eugene read the
screenshots and guided. No credential held or written down. The WebMate gateway Username was visible on
the gateway edit page; the password was masked and **deliberately not recorded** — it stays Minda's._

## Headline — no win today, and an honest correction
Live re-test of external telephony with Minda showed the **2026-10-02 "inbound rings and connects"
result did not hold**. Today: **no inbound ring AND no outbound dial** — Minda can neither receive nor
make external calls. This is **both-directions failure**, not the one-way-audio (RTP) we had expected to
be the last leg. Internal calls (restored since ~Thursday 10-01/02) remain fine throughout.

Nothing we touched tonight fixed it. We did, however, **rule things out cleanly** and narrow the cause
to the **provider path**, not the firewall. Paused deliberately with internal phones working.

## What we did (guide-only, Minda executing)
1. **Changed running NAT** on both WANs from `service udp 5080 5060` → `service udp 5080 5080`
   (object `PBX-SIP-BT` / `PBX-SIP-FTTB`, `host 10.224.13.9`), chasing the external profile that was
   advertising `public:5080`. **This is unsaved — startup-config still holds the 2026-10-02 known-good
   `5080 5060`**, so a reload reverts it.
2. **Restarted the FusionPBX `external` profile** (Status → SIP Status → Restart; office phones 1001/1002
   untouched). Log (today, `2026-10-05 08:45`):
   ```
   [NOTICE] sofia_reg.c:3722 Added gateway 'b015f2fa-…' to profile 'external'
   [NOTICE] sofia_reg.c:463  Registering b015f2fa-…
   [DEBUG]  sofia.c:2115 nua_i_outbound: unknown event 8: 101 NAT detected
   ```
   Gateway → **REGED**. After restart the external profile advertises **private `10.224.13.9:5080`**
   (reverted from the previously-stuck public `62.105.119.118:5080`).

## What we ruled out / confirmed (read-only)
- **SIP ALG is OFF.** `show run policy-map` → `global_policy / class inspection_default` lists dns, ftp,
  h323, ip-options, netbios, rsh, rtsp, skinny, esmtp, sqlnet, sunrpc, tftp, xdmcp, pptp, icmp —
  **no `inspect sip`.** So the firewall is not mangling SIP. Hypothesis eliminated.
- **The `:5080` static forward is catching nothing.** `show nat | include PBX-SIP`:
  ```
  1 (telephony)→(outside_bt)   PBX-SIP-BT    translate_hits = 0, untranslate_hits = 0
  2 (telephony)→(outside_fttb) PBX-SIP-FTTB  translate_hits = 0, untranslate_hits = 0
  ```
  Both zero, both directions. No inbound INVITE has landed on `:5080` (untranslate 0), and the PBX isn't
  sourcing SIP from `:5080` (translate 0). The trunk registers out via the **general telephony dynamic
  PAT** (the `~1997`-hits rule at the top of the NAT table), on an ephemeral high port — not `:5080`.
- **FreeSWITCH uptime = 6 years** (SIP Status footer). The PBX itself hasn't changed; what changed
  recently was the **2026-10-02 failover to the recovered Secondary ASA** — worth keeping in frame.

## Diagnosis
Not a one-toggle firewall fix. **Healthy REGISTER (REGED) + calls failing BOTH ways + no SIP ALG**
points hardest at the **provider rejecting the actual calls** (account / IP-auth at WebMate), or an
egress-WAN / source-IP mismatch. The one datum that would name it is the **provider's SIP response code
to an outbound INVITE** — which we have not yet captured.

**Flagged risk:** today's `5080→5080` change moved the *running* config off the 2026-10-02 state that
reportedly had inbound ringing. Whether inbound regressed on its own since 10-02 or today's change
contributed is unknown. Startup-config is untouched (`5080 5060`), so the known-good is recoverable.

## Night-shift plan (nothing poked further tonight)
0. **Re-establish baseline** — revert running NAT to startup's known-good `service udp 5080 5060` on both
   WANs (or reload, which restores it), re-test **inbound**. Confirm whether 10-02's inbound-ring is
   reproducible before changing anything else.
1. **One outbound call with `siptrace on`** on the external profile → read WebMate's **response code**
   (401/407 = auth; 403 = IP not allowlisted → WebMate ticket; 488 = codec; no-answer = signalling not
   reaching them). **This single code is the decisive datum.**
2. Confirm **which WAN** the trunk egresses and that WebMate sees the IP it expects (`62.105.119.118`,
   the FTTB public set in `external_rtp_ip`).
3. **WebMate ticket T02530-15072026** — "trunk REGED, calls fail both ways, no SIP ALG our side, need the
   rejection reason / confirm our calling IP is allowlisted."

## State
- **OI-8 remains Open** — external calls down both ways (was mis-stated as "audio-only remaining").
- Internal phones fine; ASA healthy (`sec/act#`, failover Normal); startup-config intact.
- No credential held. No live change persisted tonight (running NAT edit is unsaved).
