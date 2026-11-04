# RND-34 — "Asset Desk": replace EZOfficeInventory on our own machines (spark, lab mode)

**Date:** 2026-11-04 · **Status:** spark · **Asked by:** Minda (lab mode: "Another app. EZOffice")
**Not yet known (ask Minda):** what Fishbone tracks in EZOffice (site tools / plant / IT / vans?), how many assets and users, which features are used, the monthly cost, who owns it (Anna for site kit? Alex for ops?). No mention of EZOffice in Eugene's KB before today.

## What EZOfficeInventory does (general product knowledge)
Asset register with custom fields + photos; QR / barcode labels; check-out / check-in to people, sites or vehicles; reservations / bookings; locations; maintenance and service schedules; audits (scan everything at a location); depreciation; consumables / stock levels with reorder alerts; mobile app with camera scanning; reports and alerts.

## Don't build from scratch — self-host an open-source one
**Snipe-IT** (open source, AGPL-3.0; PHP/Laravel + MySQL) covers most of it: asset register, custom fields, QR labels, check-out/in to people / locations / other assets, audits, maintenance records, depreciation, consumables / accessories / components, licences, email alerts, REST API, works in a phone browser. Runs comfortably in a small Proxmox container (Gen9 now, any box later).
Gaps to check against what Fishbone actually uses: **reservations / booking calendar** (Snipe-IT has no proper booking feature as far as I know — confirm), **native mobile app with offline scanning** (Snipe-IT is web-first; third-party apps exist).
Other open-source options if Snipe-IT misses something: **Shelf.nu** (has bookings, modern UI), **GLPI** (IT-heavy), **Odoo maintenance / inventory** (bigger system).

## The AI layer (what EZOffice doesn't do)
- **Talk to it:** "I've taken the SDS drill and the laser level to plot 4" in the site chat (RND-21) → drafts the check-out → one-tap confirm.
- **Photo in, record out:** photo of a new tool and its rating plate → Eyes (Qwen3-VL) fills make / model / serial → asset created as a draft.
- **Ask it:** "where is the Hilti breaker?", "what's due a PAT test or service this month?", "what has been out more than 30 days?" via the staff chat page.
- **Tie-ins:** delivery notes / invoices (RND-33 Ledger Desk) create the asset record when kit is bought; Eugene's own `Infra-Inventory/` (servers, firewalls, UPS) could live here too.
All writes stay drafts until a person confirms; no secrets in the system (Minda holds the admin login).

## Smallest honest test
1. Minda exports the EZOffice asset list (CSV) — the export stays in the group's Drive, not in git.
2. Eugene writes the Snipe-IT container steps; Minda runs them on the Gen9 (Tailscale-only, no internet exposure).
3. Import the CSV, print 10 QR labels, run one real check-out / check-in and one audit on a phone.
4. Compare with EZOffice for a month side by side; cancel only when nothing is missed.

## Risks
- Low stakes compared with finance — the worst case is a lost record, and EZOffice stays live during the trial.
- We own hosting, backups (into PBS like everything else) and updates.
- Staff habit: the phone flow must be as quick as EZOffice's app or people stop scanning.
