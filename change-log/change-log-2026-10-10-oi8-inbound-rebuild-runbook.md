# Change log — 2026-10-10 — OI-8 inbound rebuild runbook drafted (for the planned off-hours window)

_Minda: "Draft the OI-8 inbound runbook now." A staged, reversible, guide-only procedure that folds in
every lesson from the same-day outage so the inbound fix can be completed safely when she schedules the
window. No live change in this session — a document only._

## What was produced
`Runbooks/Runbook-OI8-Inbound-External-Calls-Rebuild.md` — the tested-rebuild procedure to get **inbound
external calls** (WebMate DDIs → desk phones) working after the Oct-1 restore, **without** risking
internal/outbound again.

## Shape (one change at a time, verify each, instant rollback for every step)
- **§0 Current state** — internal ✓, outbound ✓, inbound ✗; the three missing pieces (ASA NAT forward;
  PBX trunk inbound settings reverted by the restore; the DID To-header→destination_number rewrite).
- **§1 Pre-flight** — pick an off-hours window; **snapshot VM 105** (`pre-oi8-inbound-rebuild-<date>`);
  confirm internal+outbound work first; **confirm `Local_Extension` exists** (never delete/edit it); ASA
  config backup; FreeSWITCH log viewer open throughout.
- **§2 Step A — ASA** — verify the 2026-10-10 twice-NAT is still in running-config (`show run nat | include
  PBX-HOST`), re-apply if missing, **packet-tracer** as the decisive read-only proof (Action: allow + the
  UN-NAT phase to `10.224.13.9:5080`), then **`write memory`** to persist on both ASAs. Rollback = `no nat …`.
- **§3 Step B — FusionPBX trunk** — re-add the providers ACL `52.28.7.189/32 = allow`; set external profile
  `ext-rtp-ip`=public `62.105.119.118`, `ext-sip-ip`=private (public ext-sip-ip broke ringing on 10-02);
  restart only the **external** profile; confirm WebMate gateway → REGED. All reversible.
- **§4 Step C — the DID rewrite dialplan (the careful one)** — snapshot VM 105 again first; **ADD one**
  dialplan `webmate_inbound_did` (**Domain=Global**, Context=`public`, Order=9, **Continue=True**,
  Enabled=True) with condition `${sip_to_user}` `^\+?44(\d{10})$` → action `set destination_number=0$1`
  **Inline=true**; SAVE then re-open and VERIFY it saved correctly (yesterday a copy saved Domain-scoped +
  Continue=False and never ran); Reload XML; **VALIDATE with the log on one test call BEFORE trusting it**;
  re-confirm internal still works. Instant rollback = Enabled=False → Reload XML, else snapshot rollback.
- **§5 End-to-end test** — each DID rings the right desk + two-way audio; confirm against the CDR.
- **§6 Persist & close** — `write memory` done (A4); snapshot `oi8-inbound-working-<date>`; mark OI-8
  Resolved only after a genuine external inbound call connects both ways (CDR-verified).
- **§7 Guardrails** — never delete/edit `Local_Extension` or any existing dialplan (only ADD); never `.*`
  on a live PBX; one change at a time + snapshot before each; a `public` dialplan must be Domain=Global
  (hidden from the domain-filtered list); a deleted default dialplan is not restored by reboot/App-Defaults;
  the Flush Cache → Reload XML → Restart internal recovery card.
- **§8 Related** — the outage change-log; OI-8 and OI-17 (set up regular Proxmox backups).

## Governance
Guide-only throughout (§3): **Minda executes** each console/GUI/Proxmox step, **Eugene guides and
verifies**. No secret held. The runbook is the prep the outage record said was owed before touching
anything live again.

## Next
Run it in a planned off-hours window when Minda schedules it. OI-17 (automated Proxmox backups) should be
set up too — the 9-day-old backup is what made the outage costly.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
