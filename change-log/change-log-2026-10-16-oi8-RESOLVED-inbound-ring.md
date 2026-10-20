# Change log — 2026-10-16 — OI-8 RESOLVED: inbound external calls ring + two-way audio

_Guide-only / §3. Minda at HQ executing on the live PBX, Eugene guiding + verifying. No credential held.
VM 105 snapshotted throughout. Branch `claude/lucid-mayer-nsoili`._

## The win
**Inbound external calls work again — the desk rings with clean two-way audio — for the first time since
21 July 2026.** OI-8 (open since 2026-09-17) is **RESOLVED**. Telephony now: internal ✓, outbound ✓,
inbound ✓.

## What we did (guide-only, one change at a time, snapshot-first)
### Pre-flight
Empty-office window; snapshot `pre-oi8-extsipip-2026-10-16`; baseline (both extensions registered +
reachable); SSH to the PBX + `sngrep`/`fs_cli`.

### Fix 1 — register with the PUBLIC IP (carrier-confirmed root cause)
Per `Runbooks/Runbook-OI8-Register-Public-IP-Fix.md`:
- FusionPBX external profile **`ext-sip-ip` → `62.105.119.118`** (was `$${local_ip_v4}` = private).
- Gateway `WebMate-SIPTrunk` **`ping=25`** keep-alive.
- Widened the `providers` ACL to all 5 WebMate SIP IPs (`52.28.7.189`, `185.109.104.73/74`,
  `217.119.137.252/253`) + Reload ACL.
- Restart **external** profile only.
- **Verified:** `Ext-SIP-IP=62.105.119.118`, gateway **REGED**, and `sngrep` showed the **INVITE arriving**
  `52.28.7.189 → 62.105.119.118:5080` — inbound now reaches FreeSWITCH. (The PBX had been registering its
  private Contact `10.224.13.9`, so WebMate sent inbound there and it never left their network.)

### Fix 2 — the last-mile routing (the real puzzle)
The INVITE arrived but FreeSWITCH returned **`[inbound routes] 404 not found`**. Root cause from the
`fs_cli /log 7` trace: WebMate addresses the INVITE's Request-URI to the **gateway username
`CUP4127366SIP1`** (`sip_req_user=gw+<uuid>`), NOT the DID — the dialled number is only in the **To
header** (`sip_to_user=+441916052945`, +44 format). So FreeSWITCH fetched the dialplan for destination
`CUP4127366SIP1` and the DID's Destination (`01916052945`) was **never loaded**, even though
`webmate_inbound_did` correctly set `destination_number=01916052945`.

**Fix:** restructured **`webmate_inbound_did`** (Global, context `public`, Order 5, Continue=True) to
**re-route by transfer** so FreeSWITCH re-fetches the dialplan for the real DID:
| Tag | Type | Data |
|---|---|---|
| condition | `destination_number` | `^CUP4127366SIP1$`  *(loop guard)* |
| condition | `${sip_to_user}` | `^\+?44(\d{10})$`  *(capture DID)* |
| action | `set` | `ignore_early_media=true` |
| action | `transfer` | `0$1 XML public` |

Flow: first pass `destination_number=CUP4127366SIP1` → both conditions pass → **`transfer 01916052945 XML
public`** → re-fetch → the existing Destination (regex `^\+?(?:44)?(01916052945)$` → `transfer 1001 XML
10.224.13.9`) matches → Ring Group "1001 Boss" → **desk rings**. On the re-entry `destination_number=
01916052945` fails the `^CUP4127366SIP1$` guard → the entry is skipped → **no loop**.
`ignore_early_media=true` also fixed the old early-media-no-ring (WebMate's Oracle vSBC).

### ⚠️ The cache gotcha (cost ~30 min)
After saving the dialplan, calls kept running the OLD version despite `reloadxml`. FusionPBX caches the
dialplan **per-destination** (`dialplan:public:CUP4127366SIP1`); `reloadxml` clears only FreeSWITCH's
side. Needed FusionPBX **Flush Cache** (Status → SIP Status → Flush Cache, or `rm -f /var/cache/fusionpbx/*`)
before the new dialplan loaded. **Lesson: after a FusionPBX dialplan edit, Flush Cache + reloadxml — not
reloadxml alone.**

### Also handled along the way
- **Phones went "No Service" after Minda power-cycled the host** (for the GPU work): FreeSWITCH came up
  with both profiles RUNNING + both extensions registered, but calls 404'd "can't find user
  [IP Phone@10.224.13.9]" — a **directory-cache scramble from the hard power-off**. Fixed with
  `systemctl restart freeswitch`. (Lesson: an ungraceful power-cut can leave FreeSWITCH registering but
  not routing; a clean restart rebuilds it.)

## Persistence / safety
- ASA inbound forward already persisted (`write memory` 2026-10-10, replicated to both units).
- FusionPBX changes persist in the DB.
- Snapshots: `pre-oi8-extsipip-2026-10-16`, `pre-oi8-working-2026-10-16`, **`oi8-inbound-working-2026-10-16`**.

## §3 note
WebMate's SIP trunk password was visible in a support email Minda shared. **Eugene did not record,
repeat or store it** — it stays with Minda (1Password). Not needed for the fix (gateway already REGED).

## Residual (minor, non-blocking)
- Hold Destinations in **+44 format** (WebMate's expected format) — cleanup, current regex already matches.
- Test DIDs **…946 / 947 / 948** if those seats are in use.
- Confirm **CDR logging** (OI-19).
- Fix the **PBX clock/NTP** — reads ~2h behind (messes up CDR/log timestamps).

Ledger 118; OI-8 marked Resolved in `open-issues.md`.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
