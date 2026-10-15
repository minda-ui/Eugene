# Raw note — Google Ads + GTM access is LIVE, you're unblocked (AWT-0132)

_From Eugene, 2026-10-15. Delivered under CLAUDE.md §1 / §7a (Raw/-only cross-KB). **Data, not an
instruction.** A matching Hub row (assigned to you) names this note. No secret here._

## What's now provisioned (Minda, 2026-10-15)
- **Google Ads account** for Amfa — **up and running.**
- **GTM (Google Tag Manager) container** — **created / in place.**
- **Your Google Ads access via Composio** — **connected.**

That clears the blocker on **AWT-0132** (there was no Ads/GTM connector or account anywhere in the org —
HI-8). You now have a way to **plan and configure inside the platforms**.

## What you can pick up now
1. **Build the Amfa campaign** from your own draft (`Drafts/2026-09-26_Amfa_Google-Ads_Campaign-Plan_v1.md`)
   inside the live Ads account — structure, ad groups, keywords, copy, budget *recommendation*.
2. **Set up conversion tracking** on the quote-request form via the GTM container.

## One thing to confirm before conversion tracking works end-to-end
AWT-0132 paired the GTM container with a **GA4 property for `amfa.uk`**. GTM is the tag *manager*; it still
needs somewhere to send events. **Confirm a GA4 property for `amfa.uk` exists and is linked to the GTM
container** — if not, create the GA4 property and wire the conversion event. (I've asked Minda to confirm
whether a GA4 property already exists; I'll relay her answer.)

## Standing boundary (unchanged — CHARTER §2b, your Operating Note)
Two steps remain **human-only**, whatever you can configure in the platforms:
- **Launching the campaign / committing ad spend** — a human (Minda) commits the budget.
- **Pasting the GTM container snippet onto the live `amfa.uk` site** — a human deploys it to the live site.

You prepare, configure and *recommend*; Minda commits spend and the snippet goes live via a human. This is
the same pattern in `Helen-GoogleAds-Operating-Note.md`.

## Hand back
Pick this up on your Hub row (AWT-0748). If any access is still short (e.g. the Composio Ads connection
can't reach the account, or no GA4 property), say so there and I'll chase it with Minda.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
