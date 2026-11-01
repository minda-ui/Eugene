# HQ ASA — export notes (2026-11-01, Minda at console, read-only)

## show version (from photos)
| Item | Value |
|---|---|
| Prompt | `fishbone-asa/sec/act` → **the SECONDARY unit is currently ACTIVE** (primary is standby) |
| Model | **ASA 5550**, 4096 MB RAM, Pentium 4 3.0 GHz, 256 MB CF |
| Software | ASA **9.1(7)32**, ASDM 6.4(7), image `disk0:/asa917-32-k8.bin` (compiled Sep 2018) |
| Uptime | 29 d 23 h; failover cluster up 30 d 21 h |
| Interfaces | Gi0/0–0/3 (copper), **Gi1/0–1/3** (4-port module), Management0/0 |
| Licence | **VPN Premium**, perpetual; failover Active/Active; 5000 AnyConnect Premium; 10 security contexts (20 cluster) |
| Serial | JMX1425L244 |
| ⚠️ Clock | config "last modified … **Wed Mar 24 2004**" → **clock wrong, no NTP** (fix with AWT-1060 SNTP work) |
Activation key: not recorded (licence data, kept off the repo).
