# Change log — 2026-10-05 (late) — OI-8 RESOLVED: inbound ring fixed; telephony fully restored all 3 ways

_Guide-only: Minda at the FusionPBX GUI (and a handset power-cycle); Eugene guided/verified from screenshots.
No credential held. Continuation of the same 2026-10-05 session that restored the fibre + outbound + inbound-to-PBX._

## Headline
**External telephony is now fully working in all three directions** — internal, outbound, and **inbound
calls ring the desk phone (945 → 1001)** — on the 1Gb fibre, all saved. This closes OI-8. The last mile
(the handset not ringing on inbound) turned out to be **two separate, mundane causes**, not the SIP/early-media
rabbit hole we chased for a while: (1) a **stale handset** that could register but not receive calls, and
(2) a **stale DID forward** to Minda's own mobile that made every self-test loop.

## What the final stretch actually was (and the red herrings)
- We spent a long time on **`ignore_early_media`** (WebMate's Oracle vSBC sends early media). A **scoped**
  public-context dialplan (`destination_number ^(\+?44|0)?191605294[5-8]$` → `set ignore_early_media=true`,
  continue=true, order 10) was built — it was fine and didn't touch internal/outbound. But it was **not the
  real blocker** for the desk ring.
- **Real cause #1 — stale handset.** Phone 1001 could *make* calls but not *receive* them (even an internal
  1002→1001 did nothing). The tell was its clock stuck on **Thu Oct 01** — it had rebooted around then and
  come back with a dead registration contact (registered in the UI, but unreachable). **Power-cycling 1001
  (pull LAN cable 10s, replug) fixed it** — it re-registered and now rings on incoming calls.
- **Real cause #2 — stale DID forward.** The CDRs showed every "inbound" attempt going **out to
  `447855463292`** (Minda's own mobile) presenting the DDI `441916052945`. The DID had earlier been pointed at
  the `1001 Boss` ring group / a mobile forward; since Minda was **testing from that same mobile**, every call
  was a self-loop (ring the number that's busy calling in) → 10s wait, beeps, no desk ring. **Fixed by setting
  the DID `01916052945` destination Action to plain `1001`** (no ring group, no external number).
- With the handset rebooted **and** the DID pointed straight at `1001`, an inbound test call **rings 1001**.
  Confirmed by Minda ("all good").

## ⚠️ Mid-session outage + recovery (important lesson)
Earlier in this stretch, a **first attempt used a catch-all `.*`** condition on the public-context dialplan.
Shortly after, **all phones went down with "Forbidden" (SIP 403)** — internal and external. Recovery that
worked (phones were still registered; it was a bad call-routing/cache state):
**`Status → SIP Status` → Flush Cache → Reload XML → Restart the `internal` profile.** Phones came straight
back. **Lessons:** (a) **never a catch-all `.*`** on a live PBX dialplan — scope to the exact DDIs; (b) that
Flush Cache → Reload XML → Restart-internal sequence is the standard recovery for a "Forbidden/all-down"
FusionPBX state; (c) FusionPBX **public-context dialplans don't appear in the Dialplan Manager list** (normal),
which made the stray rule hard to find — it's live but invisible.

## Final state (all saved / persistent)
- **Internal** ✓ · **Outbound** ✓ (clean audio) · **Inbound** ✓ (945 → rings 1001).
- **1Gb fibre** primary (62.105.119.118, Wavenet); ASA + switch configs saved (`write memory`); FusionPBX
  settings persist in its DB → survives reboots.
- The scoped `ignore_early_media` dialplan is left in place (harmless; invisible in the UI). It did not turn
  out to be the desk-ring blocker, but it is scoped to the DDIs only and does not affect internal/outbound.

## Handed to Minda for her 5-day absence
- **Lock it — make no further changes.** Everything survives a reboot.
- **Recovery card:** "Forbidden / all phones down" → FusionPBX SIP Status → **Flush Cache → Reload XML →
  Restart internal**. A **handset that won't receive calls** (rings out, wrong clock) → **power-cycle it**.
- Suggested she reboot **1002** and **1006 (Beverley Place)** too, so all handsets are fresh before she goes.

## OI-8
**RESOLVED** — external telephony fully restored, all three directions, on the fibre, saved. See the two
companion 2026-10-05 change-logs (`-telephony-restored-fibre-inbound`, `-external-both-ways-down`) and
`Runbooks/Runbook-OI8-Inbound-Ring-and-Cleanup.md` (now updated with the real causes + the recovery card).
