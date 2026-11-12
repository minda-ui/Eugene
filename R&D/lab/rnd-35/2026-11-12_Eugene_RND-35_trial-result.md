# RND-35 — DeepSeek Harness trial: result (Stage 2)

**LAB item — not evidence, not a Hub result. Advice only.** Eugene, 2026-11-12, Lab mode (Minda: "Yes, have a go").

## Set-up as run
- CT 220 `dsh-lab` on pve-ai (Debian 13, 4 cores, 16 GB, 10.224.10.36), unprivileged, not on boot.
- dsh at commit `e8f7b93a3`, built from source (10/10 build gates passed), run as user `dsh`, web UI
  bound to 10.224.10.36:3080 with dsh's own login token.
- Telemetry off (`DSH_TELEMETRY_MODE=DISABLED` — dsh refuses this in its `.env`, it must be exported
  in the launching shell), sandbox **read-only** (`DSH_PERMISSION_MODE=read-only`).
- Model: our gpt-oss-120b via llama-swap, reached through a socat door in CT 200
  (`lab-llama-fwd.service`, 10.224.10.31:9001, accepts only 10.224.10.36). No Open WebUI key needed
  (this Open WebUI version gives API keys to admins only).
- Network locks: hq-fw-a MGMT rule "dsh-lab no outbound" (block 10.224.10.36 → any, logged) + a pass
  rule for web replies to Minda's PC (sloppy state, **TCP flags any** — needed for the asymmetric
  Beverley path); nftables in the CT (in: 3080 from Minda's PC only; out: 10.224.10.31:9001 only).
  Tested: internet blocked, pve-ai GUI blocked, model reachable, others refused.
- Workspace `/home/dsh/estate`: plan v5.1 + framework v0.5 (pdftotext) + Eugene's estate-facts pack.

## Result (same 3 questions as the 12 Nov plain gpt-oss review in Fishbone AI)
| Measure | Plain Fishbone AI (morning) | dsh + facts pack |
|---|---|---|
| Systems invented and treated as existing | several (ACL API, provisioning service, tool team, Postgres/Airtable) | **0** — 20 assumptions listed, all true to the pack |
| Recommendations labelled honestly (exists / new + effort) | no | **yes, all** |
| Unsupported numbers | 60 % / 40 % / 85 % in 4–6 weeks | ~20 % now → ~80 % (still unsupported) |
| Invented citation | — | 1 ("framework point 73" — framework has no numbered points) |
| Recommendations that break our rules | custom gate app, signed tickets | R1 drive the claude.ai routine form with a headless browser (only Minda creates routines); L5 view-only Drive sharing for secondary cores (framework: copies, never access); S8 PGP signing still proposed though Smartsheet approval requests exist (A20) |
| Real gaps found | revocation, findings register, SSAS contradiction | per-seat identities (#1), untested restore, no monitoring, config backups, least-privilege, connector isolation |
| Missed | identity root cause, Minda bottleneck | **DEFAULTs firing automatically**, delegating routine decisions (38 open items was in the pack), revocation process, 1Password already exists (not in pack) |
| Time / speed | ~1–2 min | **26 min 36 s**, ~3 tok/s, 47 K tokens, 6 tool steps |

## Verdict
- **The facts pack + "list your assumptions" fixed the main failure**: no invented infrastructure, honest
  labels. Most of the gain is the prompt/pack, not the harness itself — the harness's value was reading
  the files reliably with tools inside a locked sandbox.
- **Still needs a human check**: 2 rule-breaking recommendations and 1 invented citation in ~25 items.
  Good as a first reviewer, never as a decider.
- **Too slow for interactive use** (26 min). Fits the night-shift idea (RND-15): batch reviews overnight.
- **dsh itself behaved**: read-only held, no outbound attempt seen in tests, telemetry off.

## Next (Minda decides)
1. Retest the same task in plain Fishbone AI **with the facts pack attached** — separates "pack effect"
   from "harness effect" (cheap, 5 min).
2. Add to the pack: 1Password, the DEFAULT mechanism, Smartsheet approvals as decision proof, the
   "copies, never access" rule — then rerun.
3. Between tests: stop CT 220 and the CT 200 socat door (both off unless a test is running).
