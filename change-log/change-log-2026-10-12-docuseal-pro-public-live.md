# Change log — 2026-10-12 — DocuSeal Pro public RAMS signing LIVE (RND-8 graduated in practice)

_Guide-only (§3): Eugene wrote every command + diagnosed; Minda executed on the live ASA, Proxmox hosts
and VMs and holds every secret (ASA creds, DocuSeal licence token + registration key, DB_PASSWORD,
SECRET_KEY_BASE, the self-host admin password, public-proxy root password). None recorded by Eugene._

## Outcome
**`https://sign.fishbonegroup.co.uk` is live on the public internet** with a valid Let's Encrypt cert,
serving the **self-hosted DocuSeal Pro** on HQ VM 106 (`10.224.10.60`). External subbies can now sign
RAMS from the open internet. Licence registered to the public URL (Production, expires 2027-10-12).
**ASA config `write memory`'d** — the forward survives a reboot.

## How it was done (Route B, after Route A hit a wall)
1. **Signing domain `sign.fishbonegroup.co.uk`** (group-wide portal). DNS **A record at IONOS** →
   `62.105.119.118` (FTTB/Wavenet static public IP); verified propagated globally.
2. **Reading the ASA before touching it (Rule C) paid off:** `:80/:443` on the FTTB public IP were
   **already NAT'd to a host `proxy` = `10.224.30.30`** (DMZ). That turned out to be **VM 102
   `public-proxy`** (Alpine + Caddy), a bare reverse proxy whose only live job was forwarding ACME for
   the **dead `vpn.fishboneholdings.co.uk` phone VPN** (replaced by Tailscale).
3. **Route A (reuse public-proxy) abandoned:** no login for VM 102 (recovered it anyway, below), and
   critically the **DMZ→mgmt path is blocked by the ASA** (ping `10.224.10.60` from the proxy = 100% loss),
   so it couldn't reach DocuSeal without a further ASA change.
4. **Route B chosen:** re-point the FTTB `:80/:443` NAT from `proxy` → **DocuSeal** (`10.224.10.60`),
   and let DocuSeal's own Caddy terminate TLS.

## The NAT-ordering bug (the hard part — ~2 hours)
Adding the DocuSeal inbound NAT (both twice-NAT and object-NAT forms) **installed but produced no
untranslate** — packet-tracer kept hitting the ASA's own interface IP ("identity") and dropping.
Ruled out WebVPN/ASDM (both off). **`show nat` revealed the cause:** the DocuSeal rule landed in
**Section 2 (Auto NAT)**, which is evaluated **after** the **Section-1 dynamic PAT**
`(mgmt → outside_fttb) source dynamic mgmt_network interface` — that rule claims the interface IP first,
so inbound to `:443`/`:80` never reached Section 2. (The working forwards — iLO, PVE1 — all sit in
Section 1 **before** the dynamic PAT.) **Fix: insert DocuSeal's static at the TOP of Section 1 with a
line number:**
```
nat (mgmt,outside_fttb) 1 source static DOCUSEAL interface service SVC_TCP_443 SVC_TCP_443
nat (mgmt,outside_fttb) 2 source static DOCUSEAL interface service SVC_TCP_80  SVC_TCP_80
```
→ packet-tracer then showed `UN-NAT … Untranslate 62.105.119.118/443 → 10.224.10.60/443`, final ALLOW.
**Big side-finding (OI-8):** `PBX-SIP-FTTB` (Section 2) also has `untranslate_hits=0` — **the inbound-SIP
failure is almost certainly the same shadow.** Same fix should get inbound calls to the PBX.

## VM 102 recovery (reclaimed, even though unused for DocuSeal)
Root password lost → recovered via Proxmox console: boot menu → `Tab` → append `init=/bin/sh` (not
`single`, which didn't drop to a shell here), `mount -o remount,rw /`, `passwd root`, hard-reboot from
Proxmox. **Lesson:** the `quiet` kernel arg hid the `/bin/sh` prompt (a blank screen *was* the shell —
press Enter); remove `quiet` or just hit Enter. New root pw in Minda's 1Password. Future of the box =
**OI-22** (decommission or repurpose as the estate reverse proxy).

## DocuSeal VM (106) — the TLS front
- Swapped to the **Pro EE image** earlier (`ee.docuseal.com/<token>/ds-ee`); EE instance **registered**
  (first to `http://10.224.10.60:3000`, then **re-registered to `https://sign.fishbonegroup.co.uk`**).
- The EE image **does not auto-run Caddy** from `HOST` (only Puma :3000), so a **dedicated `caddy:2`
  container** was added via `docker-compose.override.yml` + a `Caddyfile`
  (`sign.fishbonegroup.co.uk { reverse_proxy docuseal:3000 }`). Caddy got the cert via **TLS-ALPN-01**
  (Let's Encrypt's servers reached it on :443 through the new NAT — proof the public path works).
- **Two separate logins** clarified (tripped Minda up): the **DocuSeal.com Console** (licence/billing)
  vs the **self-hosted admin** (the local MG account) — different databases, different passwords.

## Validation
- Let's Encrypt issued the cert (public reachability proven end-to-end).
- Office PC to the public URL **times out** — **expected** (NAT hairpin not configured); from **4G it
  loads** with a valid padlock, and the self-host admin logs in. ASA `write memory` done.

## Follow-ups (OI-21, not blocking)
SMTP on the self-host (email the signing links) → then wire Anna (API key in her env, via her `Raw/`);
optional NAT hairpin / split-DNS for internal access. Then graduate RND-8 formally.

## Artefacts
`Runbooks/Runbook-DocuSeal-Pro-Public-Selfhost-HQ.md` (updated to the real Route-B deployment + the NAT
fix), `R&D/docuseal-anna/notes.md`, `open-issues.md` (OI-8 note, OI-21, OI-22), ledger row 102,
`current-state.md`. Self-host: HQ VM 106 (`10.224.10.60`), public `https://sign.fishbonegroup.co.uk`.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
