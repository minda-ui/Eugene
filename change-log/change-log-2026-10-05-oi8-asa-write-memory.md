# Change log — 2026-10-05 — OI-8: ASA config persisted (`write memory`), both units

_Guide-only: Minda at the ASA console; Eugene confirmed from the screenshot. No credential held._

## Headline
Minda ran **`write memory`** on the Active ASA (`fishbone-asa/sec/act#`). The OI-8 SIP-trunk inbound NAT
fix is now saved to **startup-config** and replicated to **both** failover units — it survives a reload
on either ASA. Closes the 2026-10-02 "config not yet saved" loose end.

## Evidence (console)
```
fishbone-asa/sec/act# write memory
Building configuration...
Cryptochecksum: 9577329b e1c527d6 53643938
23065 bytes copied in 3.670 secs (7688 byte...)
[OK]
```

## What this persists
The OI-8 object NAT static PAT on both WANs — `PBX-SIP-FTTB`/`PBX-SIP-BT` → `host 10.224.13.9`,
`nat (telephony,outside_fttb|outside_bt) static interface service udp 5080 5060` (public:5060 ↔ PBX:5080).
Applied 2026-10-02; now in startup-config on both the Active (Secondary) and, via replication, the
Standby (Primary).

## State / remaining
- **Signaling: done + persisted.** Inbound external calls ring and connect; config now survives reloads.
- **OI-8 remaining: external-call AUDIO (RTP).** Re-test an inbound call; if one-way/silent, capture
  inbound RTP from `46.31.171.144`/`185.109.104.11` by dst port, check ASA RTP port preservation, and
  consider a 1:1 static NAT on a spare FTTB public IP (check the `outside_fttb` mask for spares).
- Optional/unchanged: decide whether to leave the Secondary Active or `no failover active` to hand back
  to the Primary (pair is redundant either way).
