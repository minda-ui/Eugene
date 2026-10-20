# Change log — 2026-10-10 — OI-8 inbound rebuild EXECUTED: inbound now reaches the desk (ring pending)

_Guide-only live session (Minda executing at the ASA console / FusionPBX GUI / Proxmox / PuTTY; Eugene
guiding and verifying). Empty office = the planned off-hours window. Ran the staged runbook from the
same morning (`Runbooks/Runbook-OI8-Inbound-External-Calls-Rebuild.md`). No secret held by Eugene.
**Big day: inbound WebMate calls now reach extension 1001 — first inbound traffic since 21 July.**_

## Pre-flight (all green before any change)
- Snapshot VM 105 `pre-oi8-inbound-rebuild-2026-10-10`. Internal + outbound confirmed working first.
- **`Local_Extension` present** — but its real name/context differs from the runbook assumption: it is
  **`local_extension`**, Number `[ext]`, **Context = `global`**, Order 890, Enabled True (the ext-to-ext
  bridge). The earlier domain-context filter hid it; internal calls working proved it existed. **Never
  delete/edit it.** ASA config backup `asa-pre-oi8-2026-10-10.cfg` (`[OK]`, cksum `17eb1e63…`, 23342 B).

## Step A — ASA inbound NAT: PROVEN + PERSISTED (the firewall core, closed for good)
- `show run nat | include PBX-HOST` → the Section-1 twice-NAT was still present (never reloaded since
  10-10 morning): `nat (outside_fttb,telephony) source static any any destination static interface
  PBX-HOST service SVC_UDP_5080 SVC_UDP_5080`.
- **packet-tracer** `input outside_fttb udp 52.28.7.189 5060 62.105.119.118 5080 detailed` → **Action:
  allow**; Phase 3 UN-NAT (static) `Untranslate 62.105.119.118/5080 → 10.224.13.9/5080`, egress
  `telephony`; all 11 phases ALLOW; final `Action: allow`, output-interface telephony, up/up.
- **`write memory`** → `[OK]`, replicated to both ASAs. **The ASA inbound forward is now permanent.**
  (Closes the "running-config only, not write-mem'd" loose end from the morning.)

## Step B — FusionPBX trunk: verified good, no change needed (survived the restore)
- Providers ACL already `52.28.7.189/32 = allow` (+ old `93.95.124.106`), Default deny. `Reload ACL` run.
- External profile: `ext-rtp-ip = 62.105.119.118` (public), `ext-sip-ip = $${local_ip_v4}` (private) —
  both correct. SIP Status: external profile RUNNING on `10.224.13.9:5080`; gateway `WebMate-SIPTrunk`
  **REGED**.

## Step C — DID-rewrite dialplan: built, XML-verified, working
- Added **one** dialplan `webmate_inbound_did` — Domain=**Global**, Context=`public`, Order=**5**,
  Continue=True, Enabled=True. XML confirmed:
  ```
  <extension name="webmate_inbound_did" continue="true">
    <condition field="${sip_to_user}" expression="^\+?44(\d{10})$">
      <action application="export" data="call_direction=inbound" inline="true"/>
      <action application="set" data="destination_number=0$1" inline="true"/>
      <action application="set" data="ignore_early_media=true" inline="true"/>
    </condition>
  </extension>
  ```
- Inbound Routes list: our rule at Order 5 (first), `caller-details` 10, the DID routes `945/946/947/948`
  at 100, `not-found` 999. The `01916052945` route's final action is `transfer → 1001 XML 10.224.13.9`
  (plain extension, **no external forward**). Extension 1001: Call Forward / On Busy / No Answer / Not
  Registered / **Follow Me** / DND all **Disabled**. (Note: duplicate `947` + a `946 (Copy)` route exist —
  harmless clutter, left alone; tidy later.)
- **Result:** inbound WebMate calls now **reach FreeSWITCH and route to `sofia/internal/1001`** — the
  rewrite fires (`sip_to_user=+441916052945` → `destination_number=01916052945`), the DID route matches.
  **First inbound traffic since 21 July.**

## Step D — what's left: the inbound RING (early media), deferred (well-characterised)
- The 1001 leg **pre-answers** instead of ringing: debug log shows `sofia/internal/1001 Callstate Change
  RINGING → EARLY`, `[NOTICE] Pre-Answer sofia/internal/1001`, `switch_ivr_originate … Sending early
  media`. Cause: WebMate's **Oracle vSBC early media** on the inbound leg makes FreeSWITCH pre-answer the
  extension, so the desk never audibly rings → caller lands in voicemail (mobile test: 7s wait → ~6 rings
  → connects). **1001 handset confirmed healthy** — internal `1002→1001` rings with clean two-way audio.
- Tried `ringback`/`transfer_ringback` `local_stream://default → ${us-ring}` on the DID route — **no
  change; reverted** to `local_stream://default`. So it's not the ringback; it's genuine early-media
  pre-answer. `set ignore_early_media=true` in our dialplan also didn't resolve it.
- **The fix is early-media handling on the external profile / inbound leg** — candidates for a focused
  session: `enable-100rel`/PRACK on the `external` profile, `sip_ignore_183nosdp`, or a scoped
  early-media override — tried **one at a time with fs_cli to verify**, snapshot before each.
  **Not iterated live** per the Oct-10 outage lesson. Runbook:
  `Runbooks/Runbook-OI8-Inbound-Ring-EarlyMedia-Fix.md`.

## Other findings
- **Different phone → "call failed" before connecting.** A call to the DID from a second phone failed
  *immediately* (pre-ring), while Minda's mobile reaches the PBX. Every inbound hits the ASA from
  WebMate's single IP (`52.28.7.189`), so if the mobile gets through, our side accepts all — a
  pre-connect failure is **carrier/WebMate-side** (call not arriving at the trunk from that network) →
  **WebMate ticket T02530-15072026**, not an ASA/PBX change.
- **CDR not logging** today's calls (newest entry 17 Sep) → **OI-19**.
- **No PBX OS/SSH access** — root password expired (forced-change), root SSH denied; needed `fs_cli` for a
  clean live trace → **OI-18** (set a usable admin login on the internal LAN, record in 1Password).
- Snapshots: `pre-oi8-inbound-rebuild-2026-10-10`, `pre-did-rewrite-2026-10-10`,
  `oi8-inbound-reaches-1001-ring-pending-2026-10-10`.

## State at end
**Internal ✓ · Outbound ✓ · Inbound reaches desk-1001 → voicemail (ring pending ✗).** ASA inbound NAT
permanent on both units. Config standard (ringback reverted). Nothing broken; all reversible via
snapshots.

## Lessons / confirmations
1. **The staged runbook worked** — one change at a time, verify each, snapshot before each; no outage this
   time (contrast 10-10 morning). packet-tracer is the ASA proof; the live FreeSWITCH log is the PBX proof.
2. `local_extension` (global, order 890) is the ext-to-ext bridge on this box — the thing the morning
   outage deleted. Runbook updated to the correct name/context.
3. Early-media inbound ring is a genuine SIP-tuning task — defer and do it focused, don't iterate live.

## Follow-ups
- **OI-8 (D)** — early-media ring fix (focused session, per the new runbook).
- **OI-18** — PBX OS/SSH access + credential in 1Password.
- **OI-19** — restore CDR logging.
- **OI-17** — automated Proxmox backups (still open).
- **WebMate ticket** — why some networks' calls fail before reaching the trunk.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
