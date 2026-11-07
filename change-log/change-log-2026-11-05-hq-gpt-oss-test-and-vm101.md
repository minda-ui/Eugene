# Change log — 2026-11-05 (Thu, Minda at HQ) — gpt-oss CPU test, VM 101 stopped

_Guide-only (§3): Minda ran every command; Eugene read outputs. No credential held._

## VM 101 (OPNsense VM, OI-33)
- Read-only: `qm config 101` → 4 cores / 2 GB / 24 GB, net0 VLAN 11 (fw=1), net1 VLAN 30, onboot=1, created 2025-01-17.
- Counters over 3.9 days uptime: inside tap sent **458 B** (no VPN traffic into the office); DMZ tap ~8.8 MB out / 12 MB in (internet scanning + own updates). Hour graph: CPU ~2 %, net spikes ≤ ~650 B/s.
- **Minda stopped VM 101** and set **onboot 0** (reversible: `qm start 101`, `qm set 101 --onboot 1`). Review 12 Nov → then remove ASA UDP 500/4500 forwards, archive VM.
- Watch: UniFi Cloud Key (Beverley ACL 'wmc' references 10.224.11.11) — check APs still managed.

## gpt-oss CPU test (RND-32)
- CT 120 `ai-test` created (unprivileged Debian 12, 16 cores at low priority, 96 GB, 150 GB, VLAN 10, 10.224.10.58, onboot 0, no password).
- llama.cpp 3259ab6e5; gpt-oss-20b MXFP4 sha256-verified; **20.1 t/s generation, 67 t/s prompt on CPU**; quality **6/8** (details in `R&D/local-models/gpt-oss-test-plan.md`). 120b download started.
- Side finding: `pbs-nas` / `pbs-tank` active, 02:00 backup job ran → OI-27 may be fixed (to confirm).
