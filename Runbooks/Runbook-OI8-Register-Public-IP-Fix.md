# Runbook — OI-8 inbound fix: register the trunk with the PUBLIC IP (external_sip_ip)

> **Status:** READY 2026-10-13. This is the **root-cause fix** for OI-8 inbound, confirmed by the carrier.
> Guide-only (§3): **Minda executes on the live PBX/ASA, Eugene guides + verifies.** Planned, phones-free,
> snapshot-first — we've had live-PBX outages before; one change at a time.

## Root cause (WebMate / Charlie, 2026-10-13 — ticket T02530-15072026)
> "All calls are reaching our network correctly, but our platform could not get a response back from the
> PBX's registered address. The PBX is registering with us using a **private, internal network address**
> rather than its public internet address… when we try to send the inbound call to the address it
> registered with, it never leaves our network and never reaches the PBX… The fix needs to happen on the
> PBX or the router/firewall: it needs to **register using its public IP address**, with a **keep-alive
> (or STUN)** enabled and any **SIP ALG** on the router **switched off**."

This matches our own `sngrep` finding exactly (**no inbound INVITE ever arrives**). The PBX's SIP **Contact**
advertises `10.224.13.9` (private), so WebMate sends inbound calls there and they never leave their network.

## The fix (one setting is the heart of it)
1. **FusionPBX external profile `external_sip_ip` → the public IP `62.105.119.118`** (currently the private
   `$${local_ip_v4}` = `10.224.13.9`). Then the trunk registers its Contact as `62.105.119.118:5080`.
2. **ASA NAT already forwards `62.105.119.118:5080 → 10.224.13.9:5080`** (persisted 2026-10-10,
   untranslate_hits≈469). ✅ nothing to do.
3. **SIP ALG off** on the ASA — already confirmed (no `inspect sip`). ✅ nothing to do.
4. **Keep-alive** on the WebMate gateway so the NAT pinhole stays open (`ping`).

### Why this is safe NOW (the old "don't set it public" lesson is superseded)
On 2026-10-02/05, setting `external_sip_ip` public stopped calls — **but** the ASA NAT then forwarded
`:5060→:5080`, so a Contact of `:5080` had no matching rule. Since the **2026-10-10 fix the NAT is
`:5080→:5080`**, so advertising `public:5080` now lines up with the NAT. This is exactly what the carrier
is asking for. **Leave `external_rtp_ip` = `62.105.119.118` (public) as it is** (audio).

## 0. Pre-flight
1. Phones-free window.
2. **Proxmox snapshot VM 105** → `pre-oi8-extsipip-2026-10-13`.
3. Baseline: internal **1002↔1001** works; one **outbound** call works.
4. SSH to the PBX ready over Tailscale (`ssh root@10.224.13.9`); `fs_cli` + `sngrep` available.

## 1. Point the registration at the public IP (FusionPBX GUI)
- **Advanced → SIP Profiles → `external`** → find the setting **`ext-sip-ip`** (the `external_sip_ip` var).
  Change value `$${local_ip_v4}` → **`62.105.119.118`**. Confirm **`ext-rtp-ip`** stays **`62.105.119.118`**.
  Save. (Only the **external** profile changes — internal phones are on the `internal` profile, untouched.)

## 2. Keep-alive on the gateway
- **Accounts → Gateways → `WebMate-SIPTrunk`**: set **`ping` = 25** (seconds) for a NAT keep-alive;
  confirm `register = true`, `expire-seconds` ≈ 120–300 (shorter refresh also keeps the pinhole fresh).
  Save.

## 2b. Widen the FusionPBX "providers" ACL to ALL WebMate SIP IPs (important)
WebMate sends SIP from **several** source IPs (Charlie, 2026-10-13), but our `providers` ACL (Advanced →
Access Controls, default **deny**) currently allows only `52.28.7.189`. Add the rest or a call from another
IP gets 403'd even after the register fix. Add these (UDP 5060 signalling), then **SIP Status → Reload ACL**:
```
52.28.7.189/32        (proxy — already present)
185.109.104.73/32     (SIP)
185.109.104.74/32     (SIP)
217.119.137.252/32    (SIP)
217.119.137.253/32    (SIP)
```
RTP/audio sources (no SIP-ACL entry needed; ASA is already `permit ip any any`): **`46.31.171.144`** and
**`185.109.104.111`**, UDP 20000–50000. (Note `.111`, correcting the earlier `185.109.104.11`.)

## 3. Restart the external profile only
- **Status → SIP Status → `external` → Restart** (NOT internal). Wait for the gateway to show **REGED**.

## 4. Verify the Contact is now public (before any call)
Over SSH:
```sh
fs_cli -x "sofia status profile external" | grep -i ip        # Ext-SIP-IP should be 62.105.119.118
fs_cli -x "sofia status gateway WebMate-SIPTrunk"              # State REGED; Contact/From → 62.105.119.118:5080
```
If the Contact still shows `10.224.13.9`, the setting didn't take — recheck step 1, flush cache + rescan.

## 5. Test ONE inbound call (the proof)
Over SSH, start the capture, then place one call to **`01916052945`** from a mobile:
```sh
sngrep host 52.28.7.189        # or run unfiltered
```
- **Expected now:** an **INVITE arrives** `52.28.7.189 → 62.105.119.118:5080`, matches DID `01916052945`,
  routes to ext **1001**, desk **rings**. (First genuine inbound since 21 July.)
- Watch `fs_cli` for the leg: `sofia/internal/1001` should go `RINGING` (not straight to voicemail).

## 6. If it arrives but mis-routes to the mobile
The greedy `webmate_inbound_did` rewrite (`^\+?44(\d{10})$`) can re-dial a mobile-number To-header back out.
Only if you see that: **tighten `webmate_inbound_did` to match ONLY the real DIDs** (e.g.
`^\+?(?:44|0)?(1916052945|…94[5-8])$`). One change, Reload XML, one test, revert if no help. Snapshot first.

## 7. Audio + close
- Answer → **two-way audio** (inbound RTP from `46.31.171.144` / `185.109.104.11`, ports 20000–50000).
- Internal + outbound still fine.
- **Snapshot VM 105** `oi8-inbound-working-2026-10-13`.
- Mark **OI-8 Resolved** only after a genuine external inbound call **rings + connects both ways**, ideally
  with the **CDR logging it** (OI-19 — may need fixing first for the record).

## Guardrails / rollback
- One change at a time; **restart only the `external` profile**; never `.*`; never delete `local_extension`.
- **Rollback:** set `ext-sip-ip` back to `$${local_ip_v4}` → restart external; or roll back the VM snapshot.
- Recovery card (phones Forbidden/all-down): **SIP Status → Flush Cache → Reload XML → Restart internal**.

## Related
`open-issues.md` OI-8 (Charlie's finding + this fix), OI-19 (CDR), OI-18 (SSH — now available),
`Runbooks/Runbook-OI8-PBX-SSH-Recovery-and-Diagnosis.md`, WebMate ticket **T02530-15072026**.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
