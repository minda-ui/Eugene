# R&D graduation register — Eugene

_Ideas that left the pool and became real. One row each: the spark, what it became, when, and Minda's
approval. The record of what R&D actually produced._

| From | Date graduated | Became | Approved by |
|---|---|---|---|
| RND-1 — the R&D pool + "Creative mode" trigger | 2026-10-04 | A live capability: `R&D/` workspace + `.claude/hooks/creative-mode.sh` (UserPromptSubmit trigger) + charter note. | Minda (2026-10-04) |
| RND-5 — self-hosted zero-trust mesh (remote access) | 2026-10-11 | `Runbooks/Runbook-Tailscale-Remote-Access-HQ-Beverley.md` — Tailscale subnet-routers at HQ + Beverley for split-tunnel remote admin while Minda is away ~3 weeks. No firewall change. Tailscale now; Headscale (sovereign) migration kept as the later goal. | Minda (2026-10-11) — directed the build, chose Tailscale, leaving in ~3 days |
| RND-26 path E3 — OPNsense firewalls (HQ inside-first pair + Beverley pilot) | 2026-10-31 | A real project: **4× Cisco ASA 5525-X ordered by Minda** (HQ CARP pair + Beverley + spare) to run OPNsense. Plan: `R&D/estate-compute-split/opnsense-firewall-plan.md` (v2) → runbooks to follow (bench/install, Beverley swap, HQ Step A VLAN-by-VLAN, Step B). Hub tasks AWT-1068 (Minda: receive + bench check, ASA config exports) / AWT-1069 (Eugene: build + migration design). | Minda (2026-10-31, by purchase + 'option 2' choice) |
