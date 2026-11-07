# Change log — 2026-11-05 (later) + 2026-11-06 — gpt-oss 120b, OPNsense on ASA unit 3, HQ rack/OOB planning

_Guide-only (§3): Minda executed every step; Eugene guided and verified. No credential held (root password set by Minda → 1Password)._

## Update 2026-11-06 ~19:30 UTC — Good night
**gpt-oss (RND-32, 5 Nov, Gen9 CPU only):** 20b = 20 t/s, 6/8; **120b = 13.5 t/s, ~7/8** (better domain knowledge, flags injection; both get weekdays wrong → dates via a tool). 120b download resumed after a tab-close stall. Container CT 120 kept for Stage 2 on the Gen10.

**VM 101 (OI-33, 5 Nov):** read-only check → no VPN use; **Minda stopped it + onboot 0**. Review 12 Nov → remove ASA UDP 500/4500 forwards.

**OPNsense on ASA 5525-X — UNIT 3 (Beverley, bev-fw) DONE:**
- Unit 2 Cisco images backed up to USB (5 Nov); ROMMON `dev` → no storage; BIOS menu not reachable over console (SCO/VT100+/Xterm R6).
- **VGA via the internal 16-pin "VGA CONN" header** (DIY Dupont wiring; pin 1 position empty bottom-left on this board). BIOS = AMI Aptio, **F2**, no password; **ROMMON Boot → Disabled**, SATA AHCI sees **Micron M550 128 GB**; save F4.
- Live image booted from the SSD (pre-written) → installer refused ("corrupt"/"Device busy") → booted from USB with SSD slid out, `gpart destroy -F ada0` + zero first 10 MB → **Install UFS/GPT on ada0**, swap 8 GB.
- Port map confirmed by MAC: em3=Gi0/0, em7=Gi0/1, em2=Gi0/2, em6=Gi0/3, em1=Gi0/4, em5=Gi0/5, em0=Gi0/6, em4=Gi0/7, **em8=Management**.
- Bench config: **LAN = em8, 192.168.99.1/24**, DHCP .100–.150; GUI from the HQ desktop PC; wizard skipped (blocks on WAN) → General: **bev-fw / fishbone.local / Europe/London / DNS 1.0.0.1 + 8.8.8.8**.
- Temp **WAN em3 (Gi0/0) → office socket**, DHCP 10.224.11.72 → **updated to 26.7.8**. Cable may still be in the socket (inbound blocked) → unplug on return.
- Decisions: backup deferred to go-live (nightly config pull → PBS); root 2FA later; **Management port = admin port, Gi0/7 spare**; in the rack admin via OOB.

**HQ planning (6 Nov):** OOB management network plan (`Runbooks/Plan-OOB-Management-Network-HQ.md`): separate **TP-Link TL-SG1016** (Minda **ordered**, due 9–13 Nov), 10.224.9.0/24, 3850 Gi0/0 (already in Mgmt-vrf), firewall mgmt ports, iLOs, UPS cards, Gen9 as Tailscale jump. **HQ rack layout draft** (`Infra-Inventory/HQ-Rack-Layout.md`): HP 36U, ~10–16U free, new 5525-X at top, NVR on a wooden board (fix), old ASA 5550 pair mid, HP rack PDU, empty rails under the Gen9 for the AI server; all 4 ASAs have ears. **APC AP9631 cards fitted** in both UPS (network setup pending, OOB preferred).

**Deliveries / mail:** SSDs, RAM, 560SFP+, DAC (5 Nov); VGA kit (6 Nov); **Gen10 servers dispatched (SS207004), arriving Tue 10 Nov, DPD signature needed**. Composio 13 Nov notice — no impact expected. GitHub Claude-app permission request — Minda to review.
