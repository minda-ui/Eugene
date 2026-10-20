# Runbook — OI-8 inbound RING fix + telephony cleanup

**STATUS: OI-8 NOT resolved — inbound external calls still never reach the PBX.** A premature "Resolved"
on 2026-10-05 was retracted the same session: **the CDR shows no inbound call since 21 July 2026**, and the
ASA PBX-SIP NAT shows `untranslate_hits=0` — WebMate's INVITEs reach the ASA (`52.28.7.189:5060 →
62.105.119.118:5080`) but are **not forwarded** to FusionPBX (`10.224.13.9:5080`). Everything that "rang"
during testing was **internal** (1002→1001) or an **outbound loopback** from Minda's own mobile.
**Genuinely fixed and still true:** internal ✓, outbound ✓ (clean audio, `caller-id-in-from`=True), 1Gb
fibre primary. The desk-ring internal fixes below were real but are NOT inbound: (1) a **stale handset**
(1001 could call out but not receive; clock stuck Oct 01) fixed by a **power-cycle**; (2) a **stale DID
forward** to Minda's own mobile (`447855463292`) that made every self-test loop — fixed by setting the DID
`01916052945` Action to plain **`1001`**. **Authoritative account:**
`change-log/change-log-2026-10-05-oi8-inbound-still-broken-correction.md` (the `-inbound-ring-RESOLVED`
change-log is retracted). The real inbound fix needs ASA console / SSH work (see that change-log's
"clean fix" steps) — reachable remotely over the **existing remote-access VPN** (test it from 4G before
leaving); WebMate DDI-divert is the 5-day fallback. The `ignore_early_media` material below is kept for
reference (harmless, DDI-scoped), plus a RECOVERY CARD.

---

## 🚑 RECOVERY CARD (if telephony misbehaves)
- **All phones "Forbidden" / all calls fail (403):** FusionPBX → `Status → SIP Status` → **Flush Cache →
  Reload XML → Restart the `internal` profile**. (Phones stay registered; this clears the bad state. This is
  what recovered the mid-session outage caused by a catch-all `.*` dialplan — **never use `.*`; scope to the
  exact DDIs.**)
- **A handset won't RECEIVE calls** (rings out from it fine, but calling it does nothing; its clock looks
  wrong): **power-cycle that handset** — pull its LAN/PoE cable ~10s, replug, wait ~2 min to re-register.
- **ASA / switch:** configs are saved (`write memory`); FusionPBX persists to its DB — all survive a reboot.
- **A FusionPBX `public`-context dialplan is invisible in the Dialplan Manager list** — that's normal; search
  by name won't find it either. Use the `public` Context filter / `SHOW ALL`, or just leave it.

---

## (Reference) original inbound-ring notes

**Guide-only: Minda executes; Eugene verifies.**

Context: inbound calls from WebMate now reach FusionPBX, pass the "providers" ACL (`52.28.7.189` allowed),
match DID `01916052945`, and route to extension/ring group — but the **handset doesn't ring**. WebMate's
**Oracle vSBC sends early media**; FreeSWITCH goes `Callstate RINGING -> EARLY` and **pre-answers** the
extension, handing it early media instead of a ring. The caller hears early media and eventually hangs up
(`487 / ORIGINATOR_CANCEL`).

---

## Step 1 (PRIMARY) — make the phone ring: `ignore_early_media=true`

Goal: tell FreeSWITCH to ignore WebMate's early media so the inbound call **rings** the extension normally.

**Option A — Destination action (try first, simplest):**
1. FusionPBX → `Dialplan → Destinations` → open **`01916052945`**.
2. In the **Actions** list, add a **new FIRST action** (above `1001 Boss`):
   - In the action-type dropdown choose **`set`** (it's under a "Tools"/"Other" group in the list).
   - Value / data: **`ignore_early_media=true`**
   - Keep **`1001 Boss`** as the action *below* it (the order matters — set first, then ring).
3. **Save**, then `Status → SIP Status → Reload XML`.
4. Call `01916052945` from a phone **other than** the number in the ring group → the desk phones should ring.

**Option B — Dialplan Manager (if the `set` action isn't offered in A):**
1. FusionPBX → `Dialplan → Dialplan Manager` → find the inbound dialplan named for the DID
   (`01916052945`, context `public`) → Edit.
2. Add, as the **first action** inside the matching `<condition>` (before the transfer/ring-group line):
   ```xml
   <action application="set" data="ignore_early_media=true"/>
   ```
3. **Save**, `Reload XML`, and test as above.

**Verify:** FreeSWITCH log on the inbound call should now show the `sofia/internal/1001` leg staying in
**`CS_RINGING`** (not flipping to `EARLY`/`Pre-Answer`), the Yealink physically rings, answer → two-way audio.
If audio is one-way after answer, note the RTP peer (`46.31.171.144`) and we tune RTP NAT separately — but
with the fibre carrying a real public IP and the static PAT in place, two-way audio is expected.

---

## Step 2 — fix extension 1001's caller ID (remove the `+`)

WebMate rejects a `+`-prefixed CLI on any **external** leg (this is what broke outbound before the
`caller-id-in-from` fix, and it breaks any ring-the-mobile follow-me). Extension 1001 currently shows
`+441916052945`.

1. `Accounts → Extensions → 1001`.
2. Set **Effective Caller ID Number** and **Outbound Caller ID Number** to **`441916052945`** (no `+`).
   (Leave Emergency Caller ID `01916052945` as-is.)
3. **Save.** Re-test an outbound call from 1001 (should still connect — this just makes the format WebMate-safe).

---

## Step 3 — revert the DID destination to the ring group

During testing the DID `01916052945` was temporarily pointed at plain extension `1002` to isolate the ring
group. Put it back:
1. `Dialplan → Destinations` → `01916052945` → **Action = `1001 Boss`** (plus the Step-1 `set` action if
   using Option A).
2. **Save**, `Reload XML`, confirm an inbound call rings 1001 **and** 1002.

---

## Step 4 (optional, non-urgent) — BT backup WAN

BT (VLAN 4, gateway `81.143.32.198`) is **down** — `track 4` Timeout, and `Gi1/0/46` is `notconnect` (the BT
circuit isn't plugged into the switch). Fibre is primary and StarLink is the live reserve, so this is not
urgent. When convenient: find the BT handoff, connect it to a switch port set to **access VLAN 4**, confirm
`ping outside_bt 81.143.32.198` succeeds and `track 4` goes **Up** → BT returns as a second backup.

---

## Save when done
- FusionPBX changes persist in its database automatically (no `write memory` needed there).
- No ASA/switch change in this runbook — those were already saved 2026-10-05. If you do touch the ASA or
  switch, `write memory` on each afterward.

## Done =
Inbound calls **ring** the desk phones with two-way audio; outbound uses a WebMate-safe CLI; the DID points
back at the ring group. Then OI-8 can be marked **Resolved**.
