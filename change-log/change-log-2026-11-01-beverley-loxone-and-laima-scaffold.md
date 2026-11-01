# Change log - 2026-11-01 (evening) - Beverley Loxone fixed IPs recovered; Laima Vance seat scaffolded

## Beverley (AWT-1063) - DONE, guided (Minda executed every live step)
- Printer 10.224.111.5; per-print tray prompt fixed (Tray 2 paper type "HP LaserJet 90g" -> Plain; A4/Letter override on; PC defaults A4/auto).
- Loxone: changing Network Address before the device had its new IP broke Intercom + Audio Server; both were then deleted from the project and saved (lost links). Minda saved Loxone manuals to the Loxone KB Raw/Manuals; from them: Local/Network Address only tells the Miniserver where to connect; static IP via Configure Device or device web UI; pairing mode red/green/orange; SD-card format = factory reset.
- Final: Miniserver .2, Audio Server .3 (SD reset + re-pair), Intercom .4 (re-paired), Tree Turbo speakers re-paired; music, doorbell, internet radio (custom stream Медляк FM) working.
- **Eugene error:** told Minda DNS = 10.224.111.1; the Beverley ASA is not a DNS server (dhcpd dns 1.0.0.1 8.8.8.8). Symptom: radio list failed. Corrected to 1.0.0.1 on all three.
- Downstairs WC: motion did not light - "Night Ground Floor" mode active ~17:00 selected Night mood with Lc1 Off; set On. Night Ground Floor schedule still to check.
- Loxone KB Raw/ notes (Raw-only cross-KB): attempt + repair, outcome + correct procedure, WC night-mood fix. Process for wiki is the Loxone KB's own.

## Laima Vance (AWT-1082) - scaffolded on Minda's go
- Drive home `Laima Vance - Business Development and Entities Overview` (1kw5TlXDINwn4bpDCOGFkA-RUGTihqzwz); 9 files byte-verified (CHARTER 6234, Charter-Rules 1520, Charter-History 553, current-state 943, open-issues 798, external-source-register 1010, ledger 303, opportunities-log 386, routine prompt 3429).
- Charter written from Victoria's brief + character notes v0.1 (group repo branch claude/awesome-knuth-p1ll7w); **v1.0-draft - Minda approves the text**.
- Roster + Authority Register -> Alex: Hub AWT-1084 + Raw note (1me4AbCMHqYurJPqQhrpG83LMbSJ8xUeU).
- Guide-only remaining: approve charter; create repo minda-ui/Laima-Vance; connectors; Hub access/picklists; paste routine; open seat.

## Hub (own rows)
- AWT-1062 -> In Progress (ASA exports exist now). AWT-1069 -> unblocked for b-d (still need: which ASA 5525-X are spares; ROMMON USB result).
- AWT-1082 -> In Progress (scaffold done, not live).
