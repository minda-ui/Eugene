# Reference — HPE ProLiant DL380 Gen9 manuals (HQ Proxmox host)

_Infra-Inventory reference note. Created 2026-10-31. The PDFs themselves are **not** stored in git (large
binaries); they are fetched from HPE's permanent document URLs below and checked against the SHA-256.
Charter §1 "External binary documents" rule. Box: DL380 Gen9, S/N `CZJ64905NP`, Product ID `843556-425`._

## The documents

| Doc | HPE doc id | Permanent URL (direct PDF) | Pages | Bytes | SHA-256 (as fetched 2026-10-31) |
|---|---|---|---|---|---|
| **DL380 Gen9 Server User Guide** (2018-04 rev.) | `c04436966` | https://support.hpe.com/hpesc/public/api/document/c04436966 | 228 | 16,349,434 | `08caa12639e53770ea0a0b24df7190ac771007dbfaad2db1c64e1aea41b32a57` |
| **DL380 Gen9 QuickSpecs** (options, part numbers, GPU support rules) | `c04346247` | https://support.hpe.com/hpesc/public/api/document/c04346247 | 57 | 1,211,442 | `dd76f95acb9d1d0c47f58444e6558fa22199fcb31be929819a51d1846a2838ca` |

Viewer pages (human, browser): https://support.hpe.com/hpesc/public/docDisplay?docId=c04436966 and
`?docId=c04346247`. Parts lookup: https://partsurfer.hpe.com (search by part number or S/N).

**Fetch in any session** (`support.hpe.com` is allowed in the environment network policy; `www.hp.com`
via the `*.hp.com` allow, but the bare `hp.com` is not):

```bash
mkdir -p /tmp/hpe && cd /tmp/hpe
curl -sSL -o dl380g9-user-guide.pdf https://support.hpe.com/hpesc/public/api/document/c04436966
curl -sSL -o dl380g9-quickspecs.pdf https://support.hpe.com/hpesc/public/api/document/c04346247
sha256sum *.pdf      # QuickSpecs is revised by HPE now and then — a new hash there is expected, not alarming
pdftotext -layout dl380g9-user-guide.pdf ug.txt      # searchable text
pdftoppm -f 95 -l 95 -r 110 -png dl380g9-user-guide.pdf p95   # render a diagram page to look at
```

## User Guide — page index (PDF page = printed page)

| Topic | Page |
|---|---|
| Front panel LEDs / Systems Insight Display | 10, 16 |
| **System board components** (connector map — use this before plugging anything) | **20** |
| System battery location, System maintenance switch | 21 |
| PCI riser slot definitions | 23 |
| Remove / install the PCI riser cage | 35–36 |
| Remove / install the air baffle | 38–39 |
| Fan options; High-performance fan option | 47; 61 |
| Redundant power supply option | 60 |
| 2-slot / 3-slot PCI riser cage options | 87 / 89 |
| **GPU enablement kit — install procedure** (heatsinks, baffle clips, riser, power cable) | **92–96** |
| Expansion boards | 130 |
| Cabling (drive cages, HBA/controllers, universal media bay) | 155–186 |
| **150W PCIe power cable option** (diagram) | **186** |
| Troubleshooting; **Battery replacement (CR2032)** | 203; **204** |
| Power supply specifications | 209 |

## Board connector map (p.20) — the items that matter for us

1 FlexibleLOM · 2 Primary (CPU1) riser · 3 Optical front VGA/USB 2.0 · 4/5 x4 SATA ports 1/2 ·
6 Backplane presence detect · 7 Optical/SATA port 5 · 8 SATA port 4 · 9 Front power/USB 3.0 ·
**10 Drive backplane power** (three of them, incl. the one beside the microSD by the PSU bay — **not GPU
power**) · 11 Smart Storage Battery · 12 Location Discovery Services · 13 MicroSD slot (optional
hypervisor boot; unused on our Proxmox box) · 14 Dual internal USB 3.0 · 15 Smart Array/HBA ·
16 Secondary (CPU2) riser · 17 System battery (CR2032) · 18 TPM · 19 Serial port · X Maintenance switch.

## GPU (P40) facts established from these docs (2026-10-31, OI-30)

- **The GPU power cable runs riser → card only** (User Guide p.95 and p.186 diagrams). The riser's 10-pin
  takes its 12 V through the riser's own edge connector in the board slot; **there is no separate
  board→riser cable.** (This corrects the 2026-10-31 "missing board→riser feed" theory.)
- **Cable:** HPE spare **`805123-001`**, *"GPU power cable, 8-pin to 10-pin — connects between the GPU
  board and the GPU riser board"* (PartSurfer), part of the **Graphics Enablement Kit `719082-B21`**.
  `755742-001` (8-pin to 2×6-pin Y) is in the same kit but is for other cards. `728539-B21`/`687955-001`
  is a general power cable kit (drive cages, fans + a GPU cable) and isn't the part to order for the P40.
- **QuickSpecs P40 (`Q0V80C`) requirements:** primary GPU riser `719076-B21` (slot 1) / secondary GPU riser
  `719073-B21` (slot 2, CPU2 needed); **≥1× 1400 W PSU per card**; **High Performance Fan Kit
  `719079-B21`**; **E5-2600 v4 CPUs only**; enablement kit `719082-B21`. All met on our box.
- The 10-pin riser connector **pin-out is not published** by HPE — measure, don't assume.
