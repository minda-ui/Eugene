# Change log — 2026-09-17 — SIP trunk migration outage (OI-8), live troubleshooting

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4._

## 2026-09-17 — Same-day SIP trunk migration and live company-wide phone outage

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Context.** Minda shared a WebMate/SIP Trunk Solutions support ticket screenshot
(T02530-15072026, migrating DDIs `+441916052945` through `948` to a new SIP trunk) as
"today's task" and asked Eugene to register it and plan the implementation. Partway through
setup it turned out phones were already down company-wide — the new gateway hadn't been
added to FusionPBX yet.

**Setup verified correct.** Working through Minda's own FusionPBX admin GUI (`10.224.13.9`,
Eugene has no connector — SRC-10, guide-only), step by step: new Gateway `WebMate-SIPTrunk`
added and registering successfully (`REGED`) against `sipreg.siptrunk.solutions`; inbound
Destinations for all 4 DDIs already correctly routed (1001+Ring Group "Boss", 1003, 1005,
1006); extension 1001 confirmed registered; Ring Group "Boss" confirmed correct (Simultaneous,
1001+1002). None of that was the problem.

**Root cause found.** A test call to 01916052945 produced **zero CDR entry** (most recent
prior entry ~2 months old) — inbound calls never reaching FreeSWITCH's dialplan at all.
FusionPBX's **"providers" Access Control** (Advanced → Access Controls) is default-deny with
exactly one allowed entry, `93.95.124.106/32` — almost certainly the old provider's IP. The
new provider has no matching allow entry and is silently dropped at the ACL.

**Eugene's independent IP lookup failed, honestly reported.** Tried to source the new
provider's signaling/media IP ranges via WebSearch/WebFetch: `siptrunk.solutions` doesn't
resolve publicly, a fetch on a subdomain hit `EGRESS_BLOCKED`, and search results kept
surfacing an unrelated same-sounding US company (`siptrunk.com`) — explicitly flagged that
those IPs must **not** be used. Drafted ticket-reply text asking WebMate directly for the
real IP ranges and ports; Minda reviewed and sent it.

**Remediation attempted, ruled out.** Minda chose to try restoring service immediately rather
than wait on the ticket: flipped the "providers" ACL's Default from `deny` to `allow`, pushed
it live via SIP Status → **Reload ACL**. Retested — still zero CDR. Tried the broader
**Reload XML** as well — still zero CDR. This **rules out the FusionPBX ACL as the sole
blocker** and exhausts every check available from the FusionPBX GUI alone.

**New blocker.** Suspicion moved to the **Cisco ASA firewall pair** in front of the ProLiant
(SRC-12) — the same old-provider-only IP pattern likely exists there as an inbound
access-list/NAT rule for SIP (UDP 5060) and RTP media, dropping the new provider's traffic
before it ever reaches FusionPBX. But **Minda does not hold ASA admin credentials herself**
(the contractor who helped build the network manages that device) — she has asked him for
access. So the ASA-side check is now blocked on a third party, in parallel with WebMate's
ticket reply.

**State at close of session:** phones still down. Two external dependencies, both outside
what either Eugene or Minda can act on directly: WebMate's reply with the real SIP IP ranges,
and the contractor's response granting ASA access. No further troubleshooting possible until
one of those lands.

**Governance.** Advisory/guidance only throughout — every actual change (Gateway creation,
ACL edits, reloads) was performed by Minda directly on her own FusionPBX session; Eugene has
no connector to this system and made no live-system change himself. No credential was ever
requested, held, or written down by Eugene — the SIP trunk password from the ticket was
entered by Minda directly and never transcribed into any Eugene file.

**Next.** Resume the moment either WebMate replies (add the real IP as an `allow` node in the
"providers" ACL, revert Default back to `deny`) or the contractor grants ASA access (check its
inbound SIP/RTP rule for the same old-provider-only pattern). Until then this sits as OI-8,
critical, blocked on external replies.
