# Change log — 2026-10-18 — Adopted + built 3 skill candidates (SC-5/6/7)

Minda: "Adopt all three candidates." Built them as Eugene's own skills (§2b; guide-only content). Live
from this session (they registered immediately).

| Candidate | New skill | What it does |
|---|---|---|
| SC-7 | **`site-link-triage`** | Ordered inter-site-link fault diagnosis — site → link → radio → switch-port — with the LACP/cabling safety checks (never plug the radio into an ASA port-channel member; a switch-port "up" only proves power+Ethernet to the dish, not the RF lock; Tailscale working ≠ native link up). From the 2026-10-17 Beverley airFiber outage. |
| SC-5 | **`shared-skill-package-for-upload`** | Validate + zip a `minda-ui/Fishbone-Skills` library skill for the native claude.ai Skills upload channel; bakes in the no-angle-bracket/XML-tags-in-description rule and the `<name>/`-top-level-folder requirement; hands Minda the exact upload path. |
| SC-6 | **`hardware-part-compatibility-check`** | Buy / don't-buy verdict for a part vs a target system — form factor, connector (SFF-8644 vs QSFP/SFF-8436 vs SFF-8088), speed negotiation, 512-vs-520 sector size, caddies/trays, IT-vs-RAID, PSU/slot/riser headroom — with the exact spec to re-search. From RND-2 GPU + RND-3 storage sourcing. |

`.claude/skill-candidates.md` rows SC-5/6/7 marked `adopted → <path> (2026-10-18)`. Each skill is guide-only
(§3) and matches house-style frontmatter (name + plain-English description with trigger phrases). The
`<site>`/`<skill>` placeholders in the local descriptions are fine for repo-loaded skills (same as the
existing `tailscale-subnet-router`); the no-angle-bracket rule only applies to the shared *upload* channel.

Not done (optional, later): these are Eugene's own skills; if any would help the wider workforce they can be
**proposed to the shared library** via the curation loop (Victoria estate-fit → Alex genericise → package
with the new `shared-skill-package-for-upload` skill). Not proposed yet.

Ledger 125.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
