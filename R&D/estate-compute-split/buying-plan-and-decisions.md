# Estate AI + network build — phased buying plan, open decisions, gaps

_R&D roll-up (creative mode, 2026-10-31). Prices are rough used-UK estimates from today's research — quote
before buying. Guide-only (§3): Minda buys and fits. Pulls together RND-23…28._

## Buying plan by phase
| Phase | Item | ~£ | Status / gate |
|---|---|---|---|
| **0 · Fix + firewall** | 4× Cisco ASA 5525-X (OPNsense) | ~200–260 | ✅ **ordered** |
| | Cisco console cable + up to 4× 2.5" SSD | ~70–90 | on arrival, if not fitted |
| | 2× genuine HPE `805123-001` (Gen9 P40 power) | ~50 | AWT-1061 — **skip if the AI server is coming soon** (P40s move to Beverley) |
| | UPS rebalancing (A/B) | 0 | AWT-1064 |
| | UPS batteries | 0–500 | only if AWT-1065 shows old batteries |
| **1 · Server triangle (start)** | 2-port 10G card for Gen9 + one for R710 + 1 more DAC | ~55–85 | after lid-off slot checks |
| **2 · Staff-questions pilot** | nothing (runs on the Gen9) | 0 | runbooks ready |
| **3 · HQ AI server** | DL380 Gen10 8SFF build (2× Gold 6252, 384 GB, 2× 1600 W, perf fans/heatsinks, GPU + tertiary risers, baffle, 10G FlexibleLOM, boot SSDs, rails) | 1,250–2,000 | ✅ **ordered 2026-10-31** (Bargain Hardware, ×2 incl. Beverley, £1,194.52 ex VAT, est. 9 Nov) — fans/SSDs/RAM still to add |
| | 2× V100 32 GB PCIe (+ 2× `871829-B21` cable kits) | **~1,400** (Minda: ~£700 each) | quotes; one-probe cable check |
| | 3rd V100 later | ~700 | after HPE Power Advisor check |
| **4 · Beverley node** | DL380 Gen10 replica + failover (reuses the HQ **P40s**) + 2× Gen10 GPU cables | 1,350–1,850 | ✅ chassis **ordered** with the HQ one (same build); needs RAM, fans; GPU cables ✅ ordered (4× 869820-001) |
| **If measurements say so** | own UPS for the AI server (3 kVA) | 300–800 | power readings (AWT-1066/1067) |
| | rack-area extract fan / portable AC / split AC | 100–3,000 | warm-day inlet temperature |
| | 16 A circuit (electrician) | quote | only with a 3 kVA UPS |

**Rough totals:** phases 0–2 ≈ **£375–1,000** · AI server (2 cards) ≈ **£2,300–3,300** · Beverley ≈ **£1,350–1,850** ·
contingencies £0–4,000+.
**Dropped from earlier plans (saved):** HQ storage Gen10 (~£650–845) · 2 new Beverley P40s (~£390) · NM-4-10G modules (~£160–260).

## Decisions waiting on Minda
1. ~~V100 or V100S, and a GPU budget ceiling.~~ **Decided 2026-10-31: V100 32 GB**; refresh ~2028.
2. ~~Skip the Gen9 P40 cables (AWT-1061)?~~ **Decided 2026-10-31: skipped** — P40s go to Beverley with Gen10 cables.
2b. **AI server: DL380 Gen10 chosen (2026-10-31)** over DL385 Gen10 Plus; reuse 6× 900 GB SAS as the model library.
3. Staff pilot: which 2–3 staff, which folders, Tailscale on their phones?
4. What must never leave the building (sovereign list)?
5. Monthly spend limit for frontier (cloud) AI calls.
6. Firewall Step B: public IP block (/29) or router-in-front.

## Gaps not yet planned
- **Security of the AI setup:** staff logins/roles, audit logs, Composio scopes per worker.
- **Monitoring:** model servers, radio link, UPS on battery, temperatures, backups → the silent-failure alarm (RND-6).
- **Software stack:** NVIDIA driver line that covers Volta (V100) + Pascal (P40) long term; container layout; update routine.
- ✅ **Rack space HQ:** HP 42U rack ~50–60 % used → plenty (needs 4U). Beverley: 2U spare + firewall replaces the old ASA in place ✅.
