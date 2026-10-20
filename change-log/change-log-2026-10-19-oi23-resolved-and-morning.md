# Change log — 2026-10-19 — OI-23 resolved (Beverley link + phone), morning

Guide-only (§3): Eugene read the dashboards Minda shared from HQ and confirmed status; Minda did all the
on-site/live steps. No credential held.

## OI-23 RESOLVED — Beverley↔HQ airFiber link + phone ext 1006
The inter-site link (down since 17 Oct: Beverley dish lost power + its data cable had been mis-plugged
into `Gi1/0/2`, an ASA `Po1` member — moved to the correct AirFiber port `Gi1/1/2`) is back and stable.
From the airFiber dashboard (`192.168.5.20`, link name FISHBONE):
- **RF Link Status: Operational**, link uptime ~4h24m (stable, not flapping).
- Modulation **9x (512QAM MIMO)** — top rate; signal **−57/−59 local, −57/−55 remote dBm**
  (chain imbalance 2 dB); capacity **415 / 437 Mbps**; 5765/5810 MHz, 40 MHz, ETSI, TX 39 dBm EIRP.

Phone: FusionPBX (`10.224.13.9`) → Registrations shows **ext 1006** (Yealink T48S, Beverley
**`10.224.111.10`**) **Registered UDP-NAT** — it re-registered on its own once the link came back.
**Test call confirmed two-way audio.** HQ phones 1001/1002 registered on `10.224.13.14`/`.13`.

Non-blocking notes recorded on OI-23: airFiber device **clock wrong** (`2020-03-18`, no NTP on the
`192.168.5.0/24` mgmt subnet); a **v4.1.0 firmware-update** prompt — leave firmware alone on a live link.

Inventory already had the PBX correctly at `10.224.13.9` (an earlier chat mis-statement of `.10` was
mine, not the inventory). Ledger 129; `open-issues.md` OI-23 → Resolved.

## Still open for today
- Seat-settings Composio-MCP rollout: Minda to merge Peter#3 + paste the 9 full-file replacements
  (`Runbooks/Seat-Settings-Full-Replacements-ComposioMCP-2026-10-18.md`); Eugene then verifies origin/main.
- Monday 08:05 work runs live — confirm none stalled.
- AWT-0843 tail (v1.1 re-upload + scheduled-run proof); AWT-0859 (due 23 Oct); SC-8 build.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
