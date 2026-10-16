# Dry-run 1 — closing-by-rule applied to Victoria's 15 Oct closures (AWT-0765)

> **Status: DRY-RUN RESULT for Victoria/Minda review, 2026-10-16.** Guide-only / read-only. Dataset =
> `Outputs/2026-10-16_List_Closed-By-Rule_v1.md` (Victoria's hand-sweep, 28 Hub rows she closed on 15 Oct,
> before any prompt change is live). Method: apply the draft rule (`Runbook-Mail-Triage-Closing-By-Rule-
> AWT-0765.md` §1) to each row and compare **would the automated rule close it too?**

## Headline
- **23 of 28: AGREE** — the rule would close them (clear Class 1 marketing / Class 3 automated / Class 4
  information-only, no never-close trigger).
- **5 of 28: RULE IS STRICTER** — the rule would **escalate (not close)** where Victoria closed by hand,
  because a never-close condition fires. **This is the safe direction** (the automated rule errs toward
  Minda, not toward closing). Each is a policy call for you to settle — they're the whole point of the
  dry-run.
- **0 of 28: RULE TOO LOOSE** — nothing the rule would close that Victoria kept open. Good.

## The 5 the rule would NOT close (and why) — decisions needed
| Row | What | Never-close trigger | The question for you |
|---|---|---|---|
| **AWT-0745** | GoCardless / Construction Funding Circle **finance notice** | **MONEY** | Victoria closed it only because the money sits on AWT-0725. An automated rule can't know that linkage, so it must **never close a finance/GoCardless notice**. → Rule keeps it escalated. **Recommend: agree — money look-alikes always escalate.** |
| **AWT-0750** | Irina chasing the **solicitor** on 2 Croft Avenue | **LEGAL + external** | Internal person handling her own external/legal chase, FYI to Minda. Close as info, or escalate because it's legal + outside the group? |
| **AWT-0758** | Same thread as AWT-0750 | LEGAL + external | Follows whatever you decide for 0750. |
| **AWT-0730** | Irina's **outbound** email to a **tenant** | sent **outside the group** | A copy of an internal person's own outbound email, no action for Minda. Close as info, or never-close because it leaves the group? |
| **AWT-0749** | Oak Electrical operational query; **sender not on Known Correspondents**; a seat already replied | **unknown sender asking for action** | Already handled by a seat (info@ replied). Close because handled, or escalate because an unknown sender asked for something? |

## The pattern behind the 5 — two policy gaps to close
The rule as drafted is correct but **too blunt** on two recurring real cases Victoria judged by hand:
1. **An internal person's own correspondence that merely leaves the group / touches a professional**
   (AWT-0730 tenant email, 0750/0758 solicitor chase). "External" and "legal" are never-close to stop
   *inbound* matters slipping through — but an internal colleague's *own* outbound/FYI with no action for
   Minda is arguably information-only.
2. **A matter a seat has already handled** (AWT-0749). "Unknown sender asking for action" exists to catch
   *unactioned* requests — once a seat has replied, the action is done.

**Proposed rule refinements (v0.2 — needs your yes/no):**
- **R1.** A message that is an **internal colleague's own outbound email or a copy/FYI of it, with no
  question to Minda, no deadline and no money**, may close as Class 4 **even though a recipient is external**
  — UNLESS it touches money, legal/contract, authority, or security (then escalate). *Covers 0730; for
  0750/0758 the "legal/solicitor" exception would still escalate them — see R2.*
- **R2.** **Legal / contract / solicitor** stays **never-close** regardless of who sent it (0750/0758
  escalate). Safer to let Minda see anything legal.
- **R3.** "**Unknown sender asking for action**" escalates **unless a seat has already actioned/replied**
  and nothing remains for Minda (then Class 4). *Covers 0749.* ⚠️ This one needs care — only "already
  fully handled, nothing outstanding" closes.

With R1–R3: AWT-0730 and AWT-0749 would close (matching Victoria); AWT-0745, 0750, 0758 still escalate
(safer than Victoria's hand-call on 0745; a deliberate stricter line on legal).

## The 23 the rule would close (agree with Victoria) — in brief
- **Class 1 marketing (12):** AWT-0726, 0727, 0729, 0731, 0732, 0733, 0734, 0746, 0751, 0755, 0756, 0728
  (Trustpilot, to the amfa seat — route+close).
- **Class 3 automated notices (2):** AWT-0723 (Google Workspace product update), 0737 (TradePoint SDS
  notice).
- **Class 4 information-only (7):** AWT-0700, 0724, 0736, 0742, 0743, 0744, 0753, 0754 — Bullring/Macdonald
  permit-and-programme updates, no question/deadline/money. *(0754 "for Minda to note" = information-only;
  agree.)*
- **Duplicates (2):** AWT-0702 (dup of 0701), handled as a close.
*(Counts overlap where a row fits more than one bucket; total distinct closed = 23 agree + 5 escalate.)*

## Naming reconciliation for the weekly list
Victoria's file is `Outputs/YYYY-MM-DD_List_Closed-By-Rule_vN.md`. **Align the §2 weekly-list design to
this existing name** (not a new scheme). Owner note says "weekly"; Victoria is doing per-sweep lists —
confirm with her: one file per week, same name pattern.

## Next
1. Minda/Victoria rule on **R1–R3** and the 5 flagged rows.
2. Fold the decisions into `Runbook-Mail-Triage-Closing-By-Rule-AWT-0765.md` §1 (v0.2).
3. Then hand off the full paste-ready routine prompt(s) via Raw for Minda to paste (guide-only). AWT-0766
   goes Active after.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
