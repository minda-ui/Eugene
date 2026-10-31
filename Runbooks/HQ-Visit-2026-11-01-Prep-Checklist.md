# HQ visit — Sun 1 Nov 2026 (3–4 h) — prep checklist

**Goal:** collect everything we need *before* the new kit arrives (firewalls 3–4 Nov, servers 9 Nov).
Mostly **read-only**. Anything that touches the phones is marked ☎️ and is optional (Sunday = quiet day, so it's the best window).
**Secrets rule:** never send me a password, key or community string. Where a config shows one, replace it with `*****`
before sending. Save outputs as text files and drop them in **Eugene's `Raw/` folder** on Drive (or paste them into the chat).

---

## Block 1 — Quick wins (≈ 30 min)
### ☐ 1. UPS health — both HQ UPSs (AWT-1065) ⚠️ warranty on the Oct 2024 unit ends early Nov
For each UPS, from the front display, write down (or photograph):
- model, **load %**, **estimated runtime**, **battery install/replace date**, any alarms
- run the **self-test** (menu → Test & Diags → Self-test). It switches to battery for a few seconds — normal.
- note **which UPS is the refurbished Oct 2024 one** (serial label on the back) and whether it's "UPS 1" (the one that drains first).
- photo of the **back of each UPS** (which sockets are free).

### ☐ 2. Rack photos + spare leads (2 min each)
- Photo: rack **front** and **back**, top to bottom.
- Count spare **C13–C14 power leads** (need 4 for the two new servers).
- Note roughly which **U positions** are free low down near the UPSs (AI server goes there, 2U).

### ☐ 3. iLO readings — Gen9 (AWT-1066)
iLO web page → **Power & Thermal**: screenshot **present power (W)** and **inlet/ambient temperature**. Also note if the Daikin
VAM is running.

---

## Block 2 — ASA config export (≈ 45 min) — the big one (AWT-1068)
Console or SSH to the **HQ active ASA**. First:
```
terminal pager 0
```
Then run each and save the output (one text file per ASA is fine):
```
show version
show inventory
show running-config
show interface ip brief
show nameif
show route
show nat detail
show access-list
show run dhcpd
show dhcpd binding
show failover
show vpn-sessiondb summary
show run crypto
show clock
```
- Use **`show running-config`** — it masks most passwords as `*****`. **Do not** use `more system:running-config` (that shows them in clear).
- Before sending, scan for anything not masked (keys, SNMP community, `pre-shared-key`) → replace with `*****`.
- If reachable, also do **`show running-config`** + `show failover` on the **standby** ASA.
- **Beverley ASA** too if you can reach it remotely (SSH over Tailscale) — same list. Optional.

This gives us: every VLAN, DHCP pool, NAT/port-forward, firewall rule, VPN, route — the full recipe for the OPNsense build, and
the DHCP pools for the iLO/Loxone/printer fixed IPs.

---

## Block 3 — Internet / public IPs (≈ 20 min) — for Step B
- From the ASA output above: the **outside** interface IP/mask tells us if we have a single IP or a block.
- **Wavenet router:** model (label), and on its admin page (if you have the login): WAN IP, LAN side towards the ASA, any
  "routed subnet / IP block". Screenshot (mask passwords).
- **Starlink:** how it's connected (router or bypass mode), which 3850 port.
- If unsure, a recent **Wavenet bill** often lists "IP block /29" or similar.

---

## Block 4 — Switch checks (≈ 30 min) (AWT-1067)
On the 3850 stack:
```
terminal length 0
show version
show switch
show inventory
show interfaces status
show etherchannel summary
show vlan brief
show interfaces transceiver
show cdp neighbors
show power inline
show spanning-tree summary
show running-config
```
In `show running-config`, replace any `secret` / `password` / `snmp-server community` values with `*****` before sending.
This confirms which SFP slots are free and how much PoE headroom there is.

---

## Block 5 — Server inventory (≈ 20 min) — read-only, from the Proxmox shell
On **Gen9** and on **R710 (pve-nas)**:
```
pveversion
qm list
pct list
pvesm status
zpool status -x
ip -br a
cat /etc/network/interfaces
lspci | grep -i -E 'net|ethernet|nvidia|sas|raid'
free -g
```
Gives us the VM list, storage and network names for moving the AI work to the new server.

---

## Block 5b — Wi-Fi signal map (≈ 30–40 min) — are the 3 UniFi APs in the right places?
**Tool:** free **WiFiman** app (Ubiquiti) on your phone — shows signal (dBm), which AP you're on, and has a speed test.
**You need:** the HQ floor plan (printed or a photo you can draw on).
1. Note where each AP is (2 indoor + 1 outdoor at the loading bay) — mark them on the plan, photo of each AP's position.
2. Walk the building on the **`Fishbone`** SSID. At each spot — every desk area, meeting room, kitchen/break area,
   corridors, stairs, toilets, loading bay, yard/car park edge — stand still ~10 s and write on the plan:
   **signal (dBm)** + **which AP** you're connected to. Aim for ~20–30 spots.
3. Run a **speed test** in WiFiman at 4–5 key spots (your desk, the furthest office, loading bay).
4. Screenshot WiFiman's **channel / nearby networks** view once (neighbours on the same channels).
**How to read it:** −30 to −60 dBm great · **−67 dBm** = good for calls/video · −70 to −75 = OK for basic use ·
worse than **−75** = weak spot (that's where an AP is too far or blocked).
Send me the marked plan + screenshots → I'll make the coverage map and say whether to move an AP, change power/channels, or add one.
(If the UniFi controller login works, a screenshot of each AP's **channel + transmit power** helps too — optional.)

---

## Block 6 — ☎️ Optional, only if quiet (≈ 45 min) — lid-off checks
Sunday is the best time. **Phones go down while the Gen9 is off.** Do a clean shutdown from Proxmox (not the power button).
### ☐ 6a. Gen9 lid off (photos only — no changes)
- Photo of **both risers and all PCIe slots** — is the slot with the old **331T** card x8 and clear of the P40s?
  (Decides whether the Gen9's 10G card fits now.)
- Photo of the **DIMM slots** (we'll take 4 sticks out for Beverley later).
- Close, power on, check **phones register** and `zpool status -x` is healthy.
### ☐ 6b. R710 lid off (it's the backup box — fine to stop on a Sunday)
- Photo of the **PCIe slots** — is there a free **x8** slot next to the CP400e for the Mellanox card?
- Power on, check PBS datastore mounts.

---

## Block 7 — If time is left
- ☐ **iLO fixed IP + NTP (AWT-1060)** — only once the ASA DHCP pool is known (Block 2); I'll pick the address live.
- ☐ Label check: are the 3850 ports / cables labelled? Photo of the patch area.

---

**At the end:** send me the files/photos. I'll turn them into: the OPNsense migration plan (rules, NAT, VLANs, DHCP), the
network map addressing layer (AWT-1062), the fixed-IP list (HQ + Beverley), and the build sheet for 9 Nov.
