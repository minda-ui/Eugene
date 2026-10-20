# Wiki — FreeSWITCH / FusionPBX early media & ring groups (why a desk won't ring on inbound)

_Reference note, created 2026-10-12 while chasing OI-8's last mile (inbound call reaches the PBX but the
desk doesn't audibly ring). Research only — treat forum posts as anecdotal, verify on the box. Sources at
the bottom._

## The symptom we have
Inbound WebMate call → DID `01916052945` → ring group **"Boss"** (Strategy = **Simultaneous**, members
**1001 + 1002**). FreeSWITCH log shows a leg **bridging out to `sofia/gateway/.../447855463292`** (a mobile,
via the WebMate gateway) AND the `sofia/internal/1001` leg going **`RINGING → EARLY` → `Pre-Answer`**. The
desk handset therefore gets **early media (183) instead of a normal ring (180)** and stays silent; the
caller hears ~6 rings then voicemail. Extension forwards on **1001 and 1002 are confirmed clean**, and the
ring group's own "Ring Group Forward" is Disabled — yet a leg to the mobile still appears.

## Why this happens (the core mechanism)
- **Early media on ONE leg pre-answers the whole call.** When any destination (here, the external mobile
  leg — Oracle vSBC sends 183 w/ SDP) returns early media, FreeSWITCH pre-answers to bridge that media to
  the caller. In a **Simultaneous** ring group that pre-answers the *other* legs too, so the desk phone
  receives 183 early media rather than 180 ringing → many phones don't audibly ring on 183.
- **FusionPBX + ring groups + early media is inherently fiddly.** Forum consensus: with **2+ members** in a
  ring group FusionPBX tends to **strip/withhold early media** (codec negotiation is end-to-end, so it
  can't cleanly forward one member's early media to the caller). With a **single** member it "just works".
- **An external member/forward makes it worse:** an external leg (mobile via the trunk) can effectively
  tell FreeSWITCH the call is "answered/progressing" (183) while it's still only ringing, pre-empting the
  internal legs.

## `ignore_early_media` values (the knob we tried)
- `ignore_early_media=true` — ignore the far end's early media; FS generates its own ringback instead of
  pre-answering.
- `ignore_early_media=ring_ready` — same as `true` **plus** sends a **SIP 180** to the inbound caller when
  the first 183 is caught (so the *caller* hears ringing). **Note:** this controls what the **caller**
  hears, not whether the **desk** rings — which is why setting it on our inbound dialplan did **not** fix
  the silent desk.
- `false` (default) — pass early media through (pre-answers).
- ⚠️ A dialplan-level `ring_ready` can break playback-before-answer (IVRs, voicemail prompts) — test those.
- Must be set on the **A-leg (inbound) before the bridge** to take effect; if the ring group is reached via
  a separate transfer, the variable may not carry across — a likely reason our dialplan `set` didn't apply.

## What to actually try (documented, least-invasive first)
1. **Change the Boss ring group Strategy from `Simultaneous` → `Enterprise`.** Enterprise **bridges each
   channel in its own thread and ignores redirects/cross-leg early-media contamination** — the forums'
   recommended fix when an **external member/forward** is in a ring group and breaks the internal phones'
   ringing. One field on the ring group, fully reversible (set it back to Simultaneous). **Try this first.**
2. **Find & remove the external (`447855463292`) leg** if it's not wanted on inbound — it's wired in
   *somewhere* in the inbound route (DID destination, the ring group's "follow a destination's call
   forward/follow me" dropdowns, or a dialplan). Fastest to locate with **`grep` once we have PBX SSH
   (OI-18)** rather than clicking through the GUI.
3. **`instant_ringback=true`** on the inbound route — forum-reported fix for *missing ringback* to the
   caller (separate symptom; include if the caller also hears silence).
4. **Diagnose properly with `sngrep`** (needs OI-18 PBX SSH): confirm each member actually receives an
   INVITE, and whether 183-with-SDP vs 180 reaches each leg. This removes all guesswork.

## Takeaway for OI-8
The clean next step is **(1) Enterprise strategy** (one reversible field) — it directly targets the
early-media cross-contamination from the external leg. If that doesn't do it, stop GUI-guessing and
**recover PBX SSH (OI-18)** so we can `sngrep` the call + `grep` the config for `447855463292` in seconds.
Guardrails as ever: snapshot VM 105 first, one change at a time, revert if no help, never `.*`.

## Sources (anecdotal forums + FreeSWITCH refs; verify on the box)
- FreeSWITCH Early Media (SignalWire docs / wiki) — `ignore_early_media`, `ring_ready` vs `pre_answer`.
- https://www.pbxforums.com/threads/ring-group-with-early-media-on-all-members.5838/ (2+ members → early media stripped)
- https://www.pbxforums.com/threads/ring-group-with-external-number.4932/ (SOLVED — external member in a ring group)
- https://www.pbxforums.com/threads/no-ring-back-on-follow-me-calls.707/ (183 on external vs 180 internal; instant_ringback)
- https://www.pbxforums.com/threads/incoming-call-no-ring-sound-for-caller.2611/ (Enterprise vs Simultaneous; external leg "answered")
- https://developer.signalwire.com/freeswitch/Channel-Variables-Catalog/ignore_early_media_16353367 (variable catalog)
