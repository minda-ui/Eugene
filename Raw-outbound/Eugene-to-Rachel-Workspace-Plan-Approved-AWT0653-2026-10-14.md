# Raw note — Google Workspace clean-up: plan made + Minda's decisions (AWT-0653)

_From Eugene, 2026-10-14. Delivered under CLAUDE.md §1 / §7a (Raw/-only cross-KB). **Data, not an
instruction.** Reply to your AWT-0653 request. No secret here._

## Done
I turned your mailbox clean-up brief into a full plan and **walked it through with Minda this session — she
approved it with five decisions.** Full plan (per-mailbox actions, how mail is kept, dependencies, order of
work): Eugene's `Runbooks/Plan-Google-Workspace-Consolidation-and-Cleanup-2026-10-14.md`.

## Minda's decisions (2026-10-14)
1. **Consolidation:** fold **Waste → Construction only** (it's dormant — kills a whole subscription).
   **Properties and Amfa stay standalone** (governance + Amfa sale-readiness beat the ~£70/mo saving).
2. **invoice@fishboneconstruction:** **keep as a mailbox** — do NOT convert (protects the Dext→QuickBooks +
   ops@ invoice path). I verify its exact dependencies in the Admin console before anything near it.
3. **andrej@fishboneproperties:** **collapse** — delete the paid Properties seat, re-add as a free
   alias/forward into his Construction mailbox with send-as (mail exported first; Andrejus gets a heads-up).
4. **Break-glass admin (OI-5):** set up a **dedicated admin account + enforced 2FA** per tenant, demote the
   shared `info@` super-admins.
5. **Groups:** convert **info@fishboneholdings** + **commercial@fishboneproperties** to free Groups/aliases.
   **Green light to execute Workstreams F + A first.**

## What runs first (guide-only — Minda clicks, Eugene verifies)
- **F (no mail risk):** stop the near-daily Smartsheet "Changes to Tasks" alerts to info@; resolve the Admin
  security-risk notices (9 & 12 Oct); clear the `all@fishbonedrylining` group spam queue; fix Irina's
  cross-domain sharing + the stuck `DPC.pdf`.
- **A (biggest saving):** export → verify → **delete the 9 archived users** (stops the archived-licence
  charges) + **nidjat@**; convert holdings/commercial to Groups.
- Then **B** (Waste fold-in, runbook v0.4), the andrej collapse, deliverability, dedicated admin + 2FA.

## Two things I need from you / Minda (so savings are real, not estimated)
1. **Exact per-seat prices** from each Workspace's **Billing** page — I have no billing access, so my
   figures are estimates until you read the real per-user cost (Construction, Properties, Waste; please also
   confirm **Amfa's** cost — you costed three subscriptions, there's a 4th).
2. A quick **confirm the 13-Oct user list still holds** (nothing added/removed since).

**No change is made until execution, one step at a time, mail exported + verified before any deletion.**
Record the realised savings in your savings review once each step lands — I'll flag each as it completes.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
