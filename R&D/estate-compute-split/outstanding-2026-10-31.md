# Outstanding items — end of 31 Oct 2026 (after today's orders)

## 🔴 This week
- **HQ refurb UPS (SUA2200, Oct 2024) warranty ends ~early Nov** → self-test + runtime on both HQ UPSs (AWT-1065).
- **Bargain Hardware reply (Mon):** 12× High-Performance fans, GPU-ready risers + baffle, rails fit for Gen10 — before the build starts.
- **530T seller reply:** swap to 530SFP+/546SFP+ or cancel/return.
- ✅ **Rack space HQ:** HP 42U rack, ~50–60 % used (Minda, 2026-10-31) → ~17–21U free; needs 4U (2U server + 2× 1U firewalls). ✅ **Beverley:** 2U spare for the server; the new firewall takes the old ASA's slot (straight swap).
- **Check stock:** 4× C13–C14 leads.

## 📦 Arriving
| When | What |
|---|---|
| 2–3 Nov | 4× boot SSD, Mellanox card (R710) |
| 3–4 Nov | 12× RAM, 4× ASA 5525-X, 2× AP9631, 3× iLO keys, GPU cables (Compuwyze) |
| 4–9 Nov | Cisco 3 m DAC, 530T/replacement |
| **9 Nov** | **2× DL380 Gen10** |

## 🔧 On arrival (Minda does, Eugene guides)
1. ASA ×4: bench check, SSD present?, fresh OPNsense from the official image (AWT-1068 → runbooks AWT-1069).
2. AP9631 ×2: reset, management VLAN, change password (Minda holds), alerts.
3. HQ Gen10: 12 RAM per HPE slot order, 2 boot SSDs (mirror), E208i-a HBA mode, BIOS (Above-4G, max cooling), iLO setup + licence, burn-in.
4. **Gen9 planned shutdown (phones down — quiet window):** P40s out → HQ Gen10 (**one-probe check each cable, HL-0110**); 4 RAM sticks out → Beverley Gen10; 10G card in.
5. R710: Mellanox card in; server-triangle cabling (3 DACs).
6. UPS A/B rebalancing (AWT-1064) once the new server is racked.

## 🟡 Open Hub tasks
AWT-1060 (ASA DHCP + iLO static/NTP) · AWT-1062 (Eugene: map addressing, blocked on 1060) · AWT-1063 (Beverley Loxone + printer
fixed IPs) · AWT-1066 (iLO power/temp + VAM) · AWT-1067 (3850 read-only checks) · OI-24 (BT Business line: extend, keep the 5 IPs).

## 🧭 Decisions waiting on Minda
Pilot staff + folders · what never leaves the building · monthly cloud-AI spend limit · log retention · public IPs for firewall
Step B · Gen9 driver 535→580 · security friend's feedback (after the call).

## 📝 Eugene's own
Map: fix "3× V100" wording in the two-site diagram · VAT invoices: reply to Compuwyze (Minda) · monitoring plan: add AP9631/NUT.
