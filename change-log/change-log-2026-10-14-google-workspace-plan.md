# Change log — 2026-10-14 — Google Workspace consolidation & clean-up plan (approved)

_Guide-only / §3. No secret held. Branch `claude/lucid-mayer-nsoili`._

## Context
Minda: "Next Google Workspace. We need a solid plan." Rachel had already handed Eugene a mailbox clean-up
brief (AWT-0653) with a 13-Oct Admin-console user export and cost figures (~£3k/yr across three
subscriptions). Combined with the decided consolidation architecture (`Infra-Inventory/Workspace-and-Email-
Inventory.md`) and the AWT-0616 security carry-over, Eugene wrote one consolidated plan.

## Plan
`Runbooks/Plan-Google-Workspace-Consolidation-and-Cleanup-2026-10-14.md` — current state, objectives,
principles (no email ever lost; export+verify before any delete), six workstreams (A quick wins, B Waste
fold-in, C consolidation depth, D invoice@, E deliverability, F security/governance), order of work, what
Eugene can't see (Billing, live state), decisions needed.

## Decisions — walked through with Minda, one by one (all confirmed)
1. **Consolidation depth:** fold **Waste → Construction only**. Properties + Amfa **stay standalone**
   (she asked for the disadvantages of folding Properties — blurred legal line, hard carve-out, live-mail
   migration risk for ~£840/yr, muddier cost attribution, shared blast radius — and chose standalone).
2. **invoice@:** keep as a mailbox (protects the Dext→QuickBooks + ops@ invoice path).
3. **andrej@fishboneproperties:** collapse → free alias/send-as into his Construction mailbox (export first,
   heads-up to Andrejus).
4. **OI-5 break-glass admin:** set up a dedicated admin account + enforced 2FA per tenant; demote the shared
   info@ super-admins.
5. **Groups + go-ahead:** convert info@holdings + commercial@ to Groups; **green light Workstreams F + A**.

## Delivered / logged
- Plan committed (8b7e7f7) + Drive-synced (byte-verified OK).
- Note to **Rachel's Raw/** (Drive `1t6OsNHLDC3136Se4SDvxFGwqR5TitjCr`) with the plan + decisions + the two
  things only she/Minda can supply (exact per-seat Billing prices; confirm 13-Oct user list).
- **AWT-0653** (plan made + approved, In Progress — execution pending) and **AWT-0616** (security items
  folded into Workstream F, green-lit) updated. Ledger 113.

## Next
A **guided Admin-console session** (Minda clicks, Eugene verifies) to execute F then A, one step at a time,
mail exported + verified before any deletion. Rachel records realised savings per step.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
