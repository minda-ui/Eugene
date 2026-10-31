# Option A — upgrade the HQ 3850 network modules to C3850-NM-4-10G

_R&D research (creative mode, 2026-10-31). Guide-only (§3): Minda buys/fits and runs every switch command;
Eugene plans + verifies. Nothing bought. Purpose: give the future AI server 10G ports on the HQ 3850 stack._

## Facts (Cisco docs + listings)
- **Compatible with our switches:** Cisco's 3850 hardware guide and datasheet list **WS-C3850-48F** as
  supporting C3850-NM-4-1G, NM-2-10G and **NM-4-10G**. No licence restriction found for **LAN Base (-L)** —
  not explicitly confirmed; low risk, check `show version` / Cisco Feature Navigator before buying.
- **Hot-swappable** (all 3850 network modules); don't leave the bay empty.
- **All 4 slots do 10G** (or 1G with a 1G SFP). Ports are named **TenGigabitEthernet x/1/1–4** even at 1G.
  On today's NM-2-10G, slots 1–2 are **1G only** (named `Gi x/1/1–2`), slots 3–4 do 1G/10G (`Te x/1/3–4`).
- **Used price (UK):** roughly **£80–130 each** (eBay sold listings); refurbished with warranty ~£130–200.
  Two needed → **~£160–260**.

## The catch — it doesn't add slots
The NM-4-10G has the **same 4 slots**; it only makes all of them 10G-capable. Today's use (Minda, 2026-10-31):

| Switch | Slot users | After NM-4-10G |
|---|---|---|
| 3850 #1 | Starlink · ASA-1 · ASA-2 · Gen9 | **still full** |
| 3850 #2 | ASA-1 · ASA-2 · Gen9 | **1 free 10G** |

So on its own, option A gives the AI server **one** 10G port (no cross-switch redundancy). To get **two**
(one per switch, a bundle like the Gen9's), also **move Starlink off its SFP slot onto a normal copper port**
(the 48F has 48 copper ports; Starlink's adapter is Ethernet/RJ45 — confirm how it's wired today).

## How the swap would go (one switch at a time, phones-free window)
Each server and both ASAs are cabled to **both** switches, so swapping one switch's module leaves
everything running on the other.
1. **Before (read-only):** `show interfaces status | include /1/` · `show etherchannel summary` ·
   `show running-config | section /1/` (save the output) · on the ASA `show failover`. Label every cable by slot.
2. **Switch 2 first** (no Starlink there): pull the NM-2-10G, fit the NM-4-10G, put each SFP/DAC back in the same slot.
3. **Re-apply config:** anything that was on `Gi2/1/1–2` moves to `Te2/1/1–2` (channel-group, trunk VLANs,
   description). `Te2/1/3–4` keep their names. Eugene writes the exact lines from the saved output.
4. **Verify:** `show etherchannel summary` (all members bundled), ASA `show failover`, phones register, internet up.
5. **Switch 1** the same way, plus move Starlink to a copper port + its VLAN.

## Compare with option B (2nd 10G card in the Gen9 + direct cable to the AI server)
| | A: NM-4-10G (+ move Starlink) | B: Gen9 2nd 10G card + direct DAC |
|---|---|---|
| Cost | ~£160–260 | ~£30–80 (card) — DAC already on hand |
| Work | switch + ASA-link reconfig, phones-free window | card swap in the Gen9 (needs a free slot with the P40s) |
| Risk | touches the firewall uplinks | no switch/firewall change |
| Result | AI server on the switches at 10G, both switches | AI server ↔ Gen9 storage at 10G direct; AI server to the rest of the LAN at 1G |
| Bonus | whole stack 10G-ready for the future | none |

## Steer
B is cheaper and touches nothing live; A is the tidier long-term network. If the Gen9 has a free slot for a
second 10G card, start with **B**; do **A** later as a planned upgrade if more 10G devices arrive.

Sources: Cisco Catalyst 3850 Hardware Installation Guide (network modules chapter); Cisco 3850 datasheet;
Cisco Community "C3850-NM-4-10G"; UK eBay sold listings; Renewtech / Comtek (UK refurb).
