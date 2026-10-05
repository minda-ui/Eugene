# Runbook — OI-8 inbound RING fix + telephony cleanup (night-shift)

**Status:** ready to execute. Everything else in OI-8 is fixed and saved as of 2026-10-05 (fibre primary,
internal, outbound, inbound-reaching-the-PBX). This runbook finishes the **last** item — the handset
*ringing* on an inbound call — plus three small cleanups. Guide-only: Minda executes; Eugene verifies.

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
