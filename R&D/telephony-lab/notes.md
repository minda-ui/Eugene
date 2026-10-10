# RND-11 — Telephony staging lab

_Spark, 2026-10-10. Status: spark. Guide-only; no prod PBX touch until a change is proven on the clone._

## The pain it kills
Today's HARD LESSON: you cannot safely test a FusionPBX change on the one PBX the business answers
calls on. The remaining OI-8 ring bug (Oracle vSBC early media → FreeSWITCH pre-answers the extension
leg → `RINGING→EARLY` → desk doesn't ring → voicemail) is precisely the kind of fix that wants to be
broken and re-broken on a clone. On the live box every experiment is a potential outage — exactly the
morning we already had once today.

## The idea
A **throwaway FusionPBX LXC** that mirrors production's external SIP profile + dialplan, plus a
**call generator**, so a change is proven green *off-line* and only then handed over as a verified,
one-change runbook for the live box.

```
[ clone FusionPBX LXC ]  <--SIP-->  [ SIPp / softphone call generator ]
   mirrors prod external profile + dialplan
   safe to break: test DID rewrite, PRACK/100rel, sip_ignore_183nosdp, early-media tuning
        |
        v  (only once GREEN on the clone)
[ one-change, verified runbook ]  -->  human applies to live PBX (VM 105), snapshot first
```

## Build sketch (phased, all guide-only)
- **P0** — stand a FusionPBX LXC on a Proxmox host (the RND-2 local-models box is a candidate; keep it
  resource-capped so prod is never starved). No carrier trunk — internal only to start.
- **P1** — import prod's external profile + the `public`-context dialplan (incl. the DID→`destination_number`
  rewrite we built today) so the clone behaves like the real inbound path.
- **P2** — add a **SIPp** scenario (or a softphone) that synthesises an inbound INVITE shaped like
  WebMate's (trunk user in Request-URI, real DID in To header) → reproduce the ring bug on the clone.
- **P3** — fix early media on the clone (PRACK/`enable-100rel`, `sip_ignore_183nosdp`, pre-answer
  handling), confirm the extension leg actually rings end-to-end, capture the exact diff.
- **P4** — hand over as `Runbook-OI8-...` with the proven change only; human snapshots VM 105 and applies
  one change at a time, verify, rollback kept.

## Why it's worth it beyond OI-8
Every future dialplan/trunk/codec change gets a safe place to live first. "Push and pray" → "prove,
then apply." Pairs with RND-6 (the SIP canary could run against the clone too) and RND-2 (shares the box).

## Open questions
- Does the clone need a real (test) SIP trunk to fully reproduce vSBC early media, or does a SIPp
  scenario replay it faithfully enough? (Probably SIPp is enough for the ring-leg behaviour.)
- Lightest footprint: full FusionPBX LXC vs a bare FreeSWITCH with just the external profile?
- Graduation target: a `Hardware-Projects/` or `Runbooks/` home once Minda commits.
