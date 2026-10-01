# Runbook: HQ network core, regain admin access (Cisco ASA 5550 pair, Catalyst stack) (v0.1)

_Eugene runbook, 2026-10-01. Guide-only (charter §3): **Minda performs every step**, Eugene guides live
and checks from her photos. Owner recovery on Fishbone's own hardware, because the contractor who built
the network is unreachable. **No password is ever written here, in chat, in Drive or in git.** New
passwords go straight into 1Password. Related: OI-7, OI-8,
`Infra-Inventory/Fishbone-HQ-Physical-Network-Inventory.md`,
`change-log/change-log-2026-10-01-hq-server-access-regained.md`._

---

## 0. Before you start (do this first, even if it feels slow)

| ✔ | Item |
|---|---|
| ☐ | Laptop charged, **USB-to-RJ45 console cable**, **PuTTY** saved session: Serial, COMx, **9600**, 8N1, flow control **None** |
| ☐ | PuTTY **logging on** (Session → Logging → *All session output*) to a file **on the laptop only** (the configs it captures contain password hashes and VPN keys) |
| ☐ | **Photograph every cable** on both ASA units, front and back, close enough to read the port labels |
| ☐ | **Label each cable** with tape: unit (TOP or BOTTOM) and port name (e.g. `TOP Gi0/1`) |
| ☐ | Note which unit is **Active**: front LED *ACTIVE* **green = active** (bottom on 2026-10-01), **amber = standby** (top) |
| ☐ | Staff told: **internet off for about 10 minutes** during step A5 |
| ☐ | 1Password open, with an entry ready for *Cisco ASA enable* and *Cisco ASA admin user* |

**Stop rules:**
- If anything offers to **erase the configuration** or says *password recovery is disabled*, answer
  **NO** and stop. Send Eugene a photo.
- If the screen shows something different from this runbook, stop and send a photo. Don't guess.

---

## A. Cisco ASA 5550 failover pair

**Approach:** recover the **standby (top)** unit **while it is disconnected**, so the live (bottom) unit keeps
the internet up. Then swap it in as active. The bottom unit then rejoins and **copies the new settings
from it automatically**.

### A1. Disconnect the top (standby) unit
1. Check the photos and labels are done (§0).
2. On the **TOP** unit: unplug **every network cable**, including the failover link. Leave **power** and
   the **console cable** connected.
3. Internet and phones keep running on the bottom unit. Nothing visible changes for staff.

### A2. Get to ROMMON on the top unit
1. Plug the console cable into the TOP unit's **CONSOLE** port and open the PuTTY session.
2. Switch the TOP unit **off and on** with the **power switch on the back**.
3. Watch PuTTY. When it shows **`Use BREAK or ESC to interrupt boot`**, press **Esc** straight away.
4. You should see **`rommon #0>`**. **Photo to Eugene.**

### A3. Start it without its saved settings
At `rommon #0>` type (each line, then Enter):
```
confreg 0x41
boot
```
It starts up **ignoring its saved settings** (they are not deleted). Wait for **`ciscoasa>`**.

### A4. Load the settings back, set your own passwords
```
enable
```
At `Password:` just press **Enter** (it is blank in this mode). The prompt becomes `ciscoasa#`.

```
copy startup-config running-config
```
Press **Enter** to accept the filename. The real settings load, and the prompt changes to the firewall's
real name. **Photo to Eugene**, then:

```
show running-config username
```
**Photo to Eugene**: it lists the admin accounts (names plus scrambled passwords, safe to share). Eugene
will then tell you exactly which lines to type to:
- set a new **enable** password,
- give **your** admin account a new password (or create one),
- change or remove the **contractor's** account(s).

Then, once Eugene confirms:
```
config-register 0x1
write memory
```
`config-register 0x1` makes it use its saved settings again next time. `write memory` saves your new
passwords.

### A5. Swap it in (internet off for about 5–10 minutes)
1. Switch the **BOTTOM** (currently active) unit **off** at its power switch.
2. Plug every cable into the **TOP** unit exactly as labelled, **failover cable included**.
3. In PuTTY on the TOP unit, check it says it is **Active**:
   ```
   show failover
   ```
   **Photo to Eugene.** Internet should return within about a minute.
4. Check internet and phones from a PC.

### A6. Bring the bottom unit back as standby
1. Switch the **BOTTOM** unit back **on**.
2. It finds the active top unit, becomes **standby**, and **copies the configuration from it**,
   including your new passwords.
3. On the TOP unit run `show failover` again. You should see *This host: Active*, *Other host: Standby
   Ready*. **Photo to Eugene.**
4. Optional, after a few minutes: log in to the bottom unit's console with the **new** password, to prove
   the sync.

### A7. Save a copy of the configuration
On the active unit: `show running-config`, and let PuTTY's log capture it. The log file stays **on the
laptop only**.

**Afterwards (later, not tonight):** these ASA 5550s are **end of support** (no security updates).
Plan their replacement as part of the rebuild.

---

## A-RESULT (2026-10-01): standby ASA recovered; swap blocked on the switch

Part A was run on the **secondary/top** ASA and worked up to the swap: new enable + admin passwords set,
admin SSH key removed, saved (`config-register 0x1`, `write memory`), verified. **But the swap could not
complete:** the ASA uplinks are an **LACP Port-channel to the Catalyst stack**, and the switch would not
bundle the top unit's ports (switches still locked), so Port-channel1 stayed **down** and the top unit
could not pass traffic. Rolled back to the bottom unit; internet restored; the top unit's new config
survived.

**Therefore the order is: Part B (switches) FIRST, then re-run Part A's swap (A5–A7).** When re-running
A5, confirm `show interface ip brief` shows **Port-channel1 up** on the top unit before trusting it.

## B. Cisco Catalyst 3850 switch stack (2x WS-C3850-48P, stack "Catalyst")

Confirmed 2026-10-01: front label "Catalyst 3850 48 PoE+", 2 switches stacked, console asks for a
username (locked). The ASA uplink Port-channel terminates on this stack, so the stack must be recovered
before the ASA swap can complete.

**Eugene does not script the 3850 recovery.** Follow **Cisco's official "Recover/Reset the Password on
Catalyst 3850 Series Switches"** procedure (cisco.com) at the console (MODE button at power-on, boot with
the startup config ignored, keep the config, set new passwords), or use a Cisco-qualified engineer.
Console port is on the back of each switch; the active switch's ACTV LED is green. Effect: wired network
off ~15-20 min. Keep the config; never erase it. After recovery, confirm the ASA uplink Port-channel is
bundled before re-running Part A's swap.

## C. Then fix the phones (OI-8)
With ASA access: check the inbound rule and NAT for SIP (UDP 5060) and RTP. They are believed to allow
only the old provider (`93.95.124.106`). Add the new provider's ranges once known (WebMate ticket
T02530-15072026). Eugene words the exact lines with Minda at the console.

---

## Version history
- **v0.1 (2026-10-01):** ASA section written (model confirmed: ASA 5550 pair, bottom active). Catalyst
  section pending the model label.
