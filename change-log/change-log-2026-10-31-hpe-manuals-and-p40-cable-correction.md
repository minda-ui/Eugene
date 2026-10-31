# Change log — 2026-10-31 (Sat, later session) — HPE DL380 Gen9 manuals registered; P40 power theory corrected

_Fresh session after the `*.hp.com` network allow (the morning session ended "log + restart" for it).
Interactive with Minda; guide-only, no credential held (§3)._

## 1. Network check
`www.hp.com`, `partsurfer.hp.com`, `partsurfer.hpe.com`, `support.hpe.com` reachable. Bare `hp.com` is
still refused (a `*.hp.com` wildcard doesn't cover the apex; add `hp.com` separately if ever needed).
`support.hp.com` / `h30434.www3.hp.com` answer 403 (HP's own bot wall), `h20195.www2.hp.com` fails TLS
verification in-session, `www.hpe.com` times out, `community.hpe.com` is Cloudflare-walled (a headless
browser attempt to get past it was correctly blocked — not pursued). `forums.developer.nvidia.com` and
`cdn.shopify.com` aren't on the allowlist.

## 2. HPE manuals fetched + registered
Direct-PDF endpoint `support.hpe.com/hpesc/public/api/document/<docId>` works. Fetched User Guide
`c04436966` (228 pp, 16,349,434 B) and QuickSpecs `c04346247` (57 pp, 1,211,442 B). Minda asked to
"save the manual so we can use it": **not committed to git** (large binaries) and **Drive upload not
possible this session** — Composio CLI not signed in (`sync.sh` exit 2, nothing changed) and 16 MB is far
over what can be relayed through context. Per the charter §1 external-binary rule, registered by
permanent URL + SHA-256 + page index in `Infra-Inventory/Reference-HPE-DL380-Gen9-Manuals.md` (with a
copy-paste fetch command), and SRC-14 in `external-source-register.md`. A Drive copy can be added later
from a session with the CLI signed in, or by Minda dropping the PDF into `Infra-Inventory/`.

## 3. P40 aux power (OI-30) — yesterday's theory withdrawn
- HPE's GPU-install diagrams (UG p.95, p.186): power cable goes **riser 10-pin → GPU only**. No
  board→riser cable exists, so the 2026-10-31 morning "missing board→riser feed" conclusion was wrong.
  It is left as written in the morning change-log (honest record) and marked superseded in OI-30.
- PartSurfer: **`805123-001`** = "GPU power cable, 8-pin to 10-pin, GPU board ↔ GPU riser board", in kit
  `719082-B21`. `728539-B21` → `687955-001` is a general cable kit, not the P40 part.
- QuickSpecs P40 `Q0V80C` prerequisites (GPU risers 719076/719073, ≥1×1400 W per card, HP fan kit
  719079, E5-2600 v4, kit 719082) — all met.
- Minda photographed a board header next to the microSD slot: per UG p.20 it is **item 10, drive
  backplane power** — told her not to plug the GPU cable there.
- **Judgement call:** the common factor across two cards on two risers is the cables — likely
  non-genuine or mis-wired. Next step chosen: a **12 V multimeter test** at the cable's card end (cable
  left in the riser, card end loose, box powered), done in the same visit as the CR2032 swap (OI-32) so
  the BIOS reset only happens once. Riser 10-pin pin-out is unpublished, so no trial plugging.

## Files
`Infra-Inventory/Reference-HPE-DL380-Gen9-Manuals.md` (new), `external-source-register.md` (SRC-14),
`open-issues.md` (OI-30 updated), `processed-items-ledger.md` (row 152), this file.
