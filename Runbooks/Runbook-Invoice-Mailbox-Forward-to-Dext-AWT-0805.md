# Runbook — invoice@ auto-forwards every invoice to Dext (AWT-0805)

> **Status: READY (draft) 2026-10-16.** Guide-only (§3): **Minda or a Workspace admin makes the change in
> the account; Eugene writes + verifies.** Source: Rachel finance flow map v0.1 item 7; Victoria→Eugene
> Raw hand-off `2026-10-16_handoff_victoria-to-eugene_invoice-forward-and-closing-rule-AWT-0805.md`; Minda
> approved 16 Oct ("Yes to all three"). Hub **AWT-0805**, due **23 Oct**.

## Goal
`invoice@fishboneconstruction.co.uk` forwards **a copy of every incoming invoice to Dext automatically**,
so subcontractor invoices reach Dext the moment they arrive — while invoice@ **keeps every message** so
Minda still publishes from a full inbox.

## The four checks (from the hand-off) — honour all four
1. **invoice@ stays a mailbox.** Confirmed a real mailbox (Minda, 14 Oct), not an alias/group — so it has
   its own Gmail settings and keeps copies. The forward must **keep a copy in invoice@** (never "skip
   inbox"/delete).
2. **The forward cannot loop.** Forward only to the **Dext inbound address** (external, one-way — Dext does
   not reply back into invoice@). Do **not** forward to any address that forwards back to invoice@, and make
   sure invoice@ isn't also auto-forwarding elsewhere that could bounce back.
3. **Dext auto-publish stays OFF.** Dext receives and sorts invoices, but **Minda publishes** to the
   accounting system manually. Confirm Dext's auto-publish / auto-submit is **off** before going live.
4. **Test with one invoice** before trusting it (step 5).

## 0. Get the Dext inbound ("email-in") address first
In **Dext**, find the account's unique **inbound email address** (where you forward documents to):
- Dext web app → the **＋ / Add documents** area, or **Settings → your account** → look for *"Forward
  documents / email-in address"*. It's a unique address like `yourcompany@…dext.cc` / `…@mail.dext.com`
  (Dext shows the exact one — don't guess it).
- If a **supplier/Costs** specific address is offered, use the **Costs** inbox address (invoices are costs).
Copy that address — it's the forwarding target in the steps below.

## 1. Add Dext as a verified forwarding address (invoice@ Gmail → Settings)
Sign in to **invoice@** (or do it as the mailbox owner):
1. **Settings (gear) → See all settings → Forwarding and POP/IMAP → Add a forwarding address.**
2. Paste the **Dext inbound address** → Next → Proceed. Gmail sends a **confirmation code** to that address.
3. **Retrieve the confirmation code:** because the target is Dext, the confirmation email lands **in Dext**
   (Dext inbox / processed items), not a normal mailbox. Open it in Dext and copy the code/confirmation
   link. *(If it doesn't surface in Dext, Dext support can supply it — this is a known Dext step.)*
4. Back in invoice@ Gmail → paste the code → **Verify**. The Dext address now shows as a confirmed
   forwarding address.
> ⚠️ Do **not** set "Forward a copy… to Dext" as the account-wide default if invoice@ also receives
> non-invoice mail you don't want in Dext — use the filter in step 2 instead. If invoice@ is *purely* an
> invoice drop-box, account-wide forward (with **"keep Gmail's copy in the Inbox"**) is also fine.

## 2. Create the forwarding filter (keeps a copy in invoice@)
1. **Settings → Filters and Blocked Addresses → Create a new filter.**
2. Match the invoices. Simplest robust match: **Has attachment** = ticked (invoices arrive as PDF/image),
   or leave criteria broad if invoice@ only ever gets invoices. (Avoid matching Dext's own
   confirmation/system mail.)
3. **Create filter → tick "Forward it to" → choose the Dext address.**
4. **Do NOT tick "Delete it" or "Skip the Inbox".** The copy must stay in invoice@ (check 1).
5. (Optional) also tick **"Never send it to Spam"** so invoices aren't missed.
6. Create the filter. New invoices now copy to Dext automatically while staying in invoice@.

## 3. Loop + safety check
- Confirm invoice@ has **no other auto-forward** pointing somewhere that returns to invoice@ (Settings →
  Forwarding; and Filters list).
- Confirm the filter won't forward **Dext's own** notification mails back (match on attachment / sender
  helps).

## 4. Dext: auto-publish OFF
- In **Dext → Settings** (account / integrations / publishing), confirm **auto-publish / auto-submit to the
  accounting software is OFF**. Invoices land in Dext's **Costs** inbox for **Minda to review + publish**.

## 5. Test with ONE invoice (the proof)
1. Have one real (or sample) subcontractor invoice sent to **invoice@** (or forward one in).
2. Confirm within a few minutes:
   - it **appears in Dext's Costs inbox**, and
   - it is **still in invoice@** (a copy was kept), and
   - Dext did **not** auto-publish it (it's sitting for review).
3. If it doesn't arrive in Dext: re-check the forwarding address was **verified** (step 1) and the filter's
   **"Forward to"** is set; check Dext's accepted-senders/whitelist if Dext filters unknown senders.

## 6. Done / hand-back
- When the one-invoice test passes, **reply on Hub AWT-0805** with "live + tested", and note it to Rachel
  (finance flow map item 7 complete) via the normal Hub/Raw route.
- Ongoing: Minda publishes from Dext; invoice@ remains the full archive.

## Notes / §3
Guide-only — Minda/admin performs every account step; Eugene holds no credentials and makes no live change.
Eugene does not edit Rachel's/Victoria's KB; completion is reported via the Hub row (+ Raw if a KB note is
needed). Nothing here sends mail or publishes to the accounting system.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
