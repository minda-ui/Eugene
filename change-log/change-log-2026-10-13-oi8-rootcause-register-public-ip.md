# Change log — 2026-10-13 — OI-8 root cause confirmed by the carrier; register-public-IP fix drafted

_Guide-only (§3): Eugene interpreted the carrier reply, wrote the fix runbook, updated OI-8, and drafted a
reply for Minda to send. No live change yet; no secret held. (Same live session that did the DocuSeal SMTP
setup — see below.)_

## The breakthrough
WebMate's systems team (Charlie) replied on ticket **T02530-15072026**:
> "All calls are reaching our network correctly, but our platform could not get a response back from the
> PBX's registered address… the PBX is registering with us using a **private, internal network address**
> rather than its public internet address… The fix needs to happen on the PBX or the router/firewall: it
> needs to **register using its public IP address**, with a **keep-alive (or STUN)** enabled and any **SIP
> ALG** on the router **switched off**."

This **confirms our own `sngrep` finding** (no inbound INVITE ever reaches the PBX) and gives the exact
cause: the PBX's SIP **Contact** advertises `10.224.13.9` (private), so WebMate sends inbound there.

## The fix (ours — one setting is the heart of it)
- **FusionPBX external profile `external_sip_ip` → public `62.105.119.118`** (currently `$${local_ip_v4}` =
  private). Then the REGISTER Contact advertises `62.105.119.118:5080` and WebMate can deliver.
- **ASA already forwards `:5080→:5080`** (persisted 2026-10-10, ~469 untranslate hits). ✓
- **SIP ALG already off** (no `inspect sip`). ✓
- **Add a gateway keep-alive** (`ping`) so the NAT pinhole stays open.
- **Why safe now:** the 2026-10-02/05 "don't set `external_sip_ip` public" lesson failed only because the NAT
  then forwarded `:5060→:5080`; since the 2026-10-10 `:5080→:5080` fix, advertising `public:5080` matches.
  This is exactly what the carrier asked for.

## What Eugene produced
- `Runbooks/Runbook-OI8-Register-Public-IP-Fix.md` — planned, snapshot-first, one-change-at-a-time, with a
  `sngrep`-over-Tailscale verify (we now have PBX SSH, OI-18) and rollback/recovery card.
- **OI-8 updated** with Charlie's finding + the fix; WebMate dependency marked **cleared**.
- **Gmail draft** to Charlie (ticket T02530 thread, in minda@'s Drafts): confirms we're re-registering on the
  public IP, SIP ALG already off, keep-alive being enabled, firewall already forwards — draft-only, Minda sends.

## Also this session — DocuSeal SMTP went LIVE (the "finish DocuSeal" task)
- **SMTP configured and working** on the self-host: a **Google Workspace SMTP relay** (`smtp-relay.gmail.com`)
  **IP-authenticated to the office public IP `62.105.119.118`** (no app password / no secret — cleaner than
  auth), TLS required, allowed senders = in-domain. DocuSeal **Email SMTP** set to host `smtp-relay.gmail.com`,
  port 587, **no auth**, STARTTLS, from `info@fishboneconstruction.co.uk`. **Test email arrived ✓** — SMTP gate
  cleared.
- **Pro `.docx` gotcha found:** the running container is the EE image (`ee.docuseal.com/7mb0cctk/ds-ee`) with
  `HOST=sign.fishbonegroup.co.uk`, and the licence is registered (Production, to that URL, valid to 2027). But
  `.docx` upload was refused while accessing via the **internal** `http://10.224.10.60:3000` — the licence is
  bound to the **public URL**, so Pro only activates when accessed via `https://sign.fishbonegroup.co.uk`.
  **Action: do the `.docx` upload / Anna wiring via the public URL.** (To confirm.)

## Next
- **OI-8:** apply the register-public-IP fix in a phones-free window (runbook) + sngrep test; send the WebMate
  draft. **DocuSeal:** confirm `.docx` on the public URL, then wire Anna (API key + env) and graduate RND-8.

## Artefacts
`Runbooks/Runbook-OI8-Register-Public-IP-Fix.md`, `open-issues.md` (OI-8), Gmail draft (T02530), ledger 106,
`current-state.md`.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c

## Update ~11:05 — WebMate confirmed no further action their side + full whitelist
Charlie replied (Minda sent our draft): *"there should [be nothing] else required to get the calls working…
once the IP changes have been made the calls will start reaching your PBX."* Plus the full IP whitelist:
- **SIP (UDP 5060):** `52.28.7.189` (proxy), `185.109.104.73`, `185.109.104.74`, `217.119.137.252`, `217.119.137.253`
- **RTP (UDP 20000–50000):** `46.31.171.144`, `185.109.104.111`  *(the `.111` corrects our earlier `185.109.104.11`)*

**Key action folded into the runbook (new Step 2b):** our FusionPBX `providers` ACL is default-deny with only
`52.28.7.189` allowed — widen it to **all five SIP IPs** + Reload ACL, or an inbound call arriving from one of
the other proxies would be 403'd even after the register-public-IP fix. **ASA unchanged** (already
`permit ip any any`). OI-8 updated; runbook Step 2b added.

## Update — end of session: OI-8 window prepped, NOT executed
Minda chose to run the OI-8 register-public-IP fix, so we went through **pre-flight** (phones-free check,
snapshot VM 105, baseline, SSH/sngrep ready) — then she called good-night **before any change**. So **no PBX
change was made tonight**; internal/outbound unaffected, inbound still the known-broken state. The runbook
(`Runbook-OI8-Register-Public-IP-Fix.md`, incl. the 5-IP providers-ACL whitelist) is ready to run in the next
phones-free window: snapshot → `external_sip_ip`→public → providers ACL → keep-alive → restart external →
`sngrep` test.
