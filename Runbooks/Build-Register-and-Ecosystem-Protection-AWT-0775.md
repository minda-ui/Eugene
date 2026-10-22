# Build Register + Ecosystem Protection (AWT-0775 / AWT-0778)

> **v1, 2026-10-22, Eugene.** The AI-workforce inventory in Build-Register shape (plan v5, Minda approved
> 15 Oct): **one line per assistant, routine, knowledge system, skill and connection**, seven columns —
> name · type · owner · where it lives · date created · status (live/paused/retired) · date last checked.
> Plus single-point-of-failure flags and what a restorable backup needs (first step of "protect the
> ecosystem"), and the draft **Quarterly sweep** routine prompt. Guide-only (§3): Eugene inventories and
> recommends; Minda executes any access/backup change. Supersedes the Drive-only skills-lines partial
> (`Build-Register-Skills-Lines_2026-10-19`). Physical/on-prem detail lives in
> `Infra-Inventory/Fishbone-HQ-Physical-Network-Inventory.md`; this register points at it rather than
> duplicating it. Dates marked `?` need confirming from the item's own KB/console.

Legend — Status: **live** / **paused** / **retired**. "Last checked" = this build unless noted.

---

## 1. Assistants (AI employees)

| Name | Type | Owner | Where it lives | Created | Status | Last checked |
|---|---|---|---|---|---|---|
| Peter | AI Data Assistant (mail triage, documents, Companies House) | Minda | KB `Peter - AI Data Assistant` (Drive) + `minda-ui/Peter` | 2026-09 | live | 2026-10-22 |
| Rachel | AI Finance Assistant | Minda | KB (Drive) + `minda-ui/Rachel` | 2026-09 | live | 2026-10-22 |
| Anna | AI Construction Assistant | Minda | KB `Anna` folder `1b0p62…` + `minda-ui/Anna` | 2026-09 | live | 2026-10-22 |
| Nadia | Amfa Sales & Ops Assistant | Minda | Amfa KB (adopted) + `minda-ui/Nadia` | 2026-09-24 | live | 2026-10-22 |
| John | Properties Assistant | Minda | Properties KB + `minda-ui/Fishbone-Properties-Ltd` | 2026-09 | live | 2026-10-22 |
| Darius | Workshop Operations Assistant | Minda | `Darius - Workshop Operations Assistant` `1xoCbq…` + `minda-ui/Darius` (Raw shared w/ Workshop KB — **OI-25**) | 2026-09 | live | 2026-10-22 |
| Helen | AI Content & Marketing Assistant | Minda | KB `1H487U…` + `minda-ui/Helen` | 2026-09 | live | 2026-10-22 |
| Victoria | CEO's Assistant / AI Workforce Coordinator | Minda | KB `1X0R91…` + repo? (confirm) | 2026-09 | live | 2026-10-22 |
| Alex | Housekeeping & Operations Steward | Minda | KB `1QGc0E…` + `minda-ui/Alex` | 2026-09 | live | 2026-10-22 |
| Sarah | (reporting seat; mail read-only, writes reports) | Minda | KB + `minda-ui/Sarah` | 2026-10 | live | 2026-10-22 |
| Eugene | AI IT & Engineering Assistant | Minda | KB `1o4MBR…` + `minda-ui/Eugene` | 2026-09-12 | live | 2026-10-22 |

_Irina = human reviewer (not an AI seat). Minda = owner/human._ Roster of record: Smartsheet `Roster`
(8154403007760260) in the AI Workforce Hub.

## 2. Routines (scheduled, unattended)

| Name | Type | Owner | Where | Created | Status | Last checked |
|---|---|---|---|---|---|---|
| Eugene — Task Check-in | Scheduled, weekdays 09:30 UTC | Minda (form) / Eugene runs | trigger `trig_01Q6nS5UKzQFRfGsQnQLKiQX` | 2026-09-15 | live | 2026-10-22 |
| Peter — mail triage pass | Scheduled, 7×/day (05:50–17:50 UK) | Minda (form) / Peter | claude.ai/code routine; prompt `Routine-Prompt-Peter-MailTriage-v0.3` | 2026-10-21 | live | 2026-10-22 |
| Seat work runs (per employee) | Scheduled, ~4×/day | Minda (form) / each seat | per-seat routine; prompts in group `Routine-Changes/TaskWorkRun-All-Seats` | 2026-10-18 | live | 2026-10-22 |
| Quarterly sweep (governance + tooling health) | Scheduled, quarterly, read-only | Minda (form) / Eugene | §7 draft below — **not yet created** | — | **not built** | 2026-10-22 |
| (Previous routines removed 18 Oct) Estate Index; FC/FA/FM/FP inbox-report; Peter's 2 old inbox routines | Scheduled | Minda | — | — | **retired 2026-10-18** | 2026-10-22 |

> ⚠ **The full live routine list is Minda's (created in the claude.ai/code form).** The above are the ones
> Eugene can confirm; the exact per-seat set and their schedules should be confirmed from the routines form
> for completeness (flag to Minda/Victoria).

## 3. Knowledge systems (KBs, repos, sheets)

| Name | Type | Owner | Where | Created | Status | Last checked |
|---|---|---|---|---|---|---|
| Fishbone Group master index | KB (governing) | Minda/Victoria | `minda-ui/Fishbone-Group` + Drive | 2026-09 | live | 2026-10-22 |
| Per-employee KBs (11) | KB | Minda | Drive folder + `minda-ui/<Name>` each | 2026-09+ | live | 2026-10-22 |
| Company KBs | KB | Minda | Construction/Properties/Commercial/Waste/Holdings/Amfa/Anthill/SSAS/Workshop (Drive + repos) | 2026-09 | live | 2026-10-22 |
| AI Workforce Hub | Smartsheet workspace `4946803578693507` | Alex (coord) | Roster 8154403007760260; Tasks&Requests 8860839228606340 (+Archive 1037721118312324); Achievements 4569101748012932; Help&Lessons 7780569054316420; Authority Register 3026197560821636; Known Correspondents 4944990306436996; Mail Triage Audit Trail 3256140446173060 | 2026-09-14 | live | 2026-10-22 |
| AMFA Furniture (CRM) | Smartsheet workspace `5258609614448515` | Nadia | Enquiries/Quotes 5405540723328900 + order tracker | 2026-09-24 | live | 2026-10-22 |
| Project Delivery | Smartsheet workspace `6977873211877251` | Anna | Project Register 5250912102778756; Materials 6427009439893380; Operatives 1570294781314948; Risks 2908847108917124; Progress 3823984380610436; Communication 7412446736287620; Permits 3612225313048452; Lessons 1360184981194628 | 2026-10-15 | live | 2026-10-22 |
| Financial Archive | Drive folder `1BVk_Rf…` | Rachel | Drive (group estate law v1.4 §7b) | 2026-09 | live | 2026-10-22 |
| Shared skills library | git repo | Alex (curator) | `minda-ui/Fishbone-skills` | 2026-10 | live | 2026-10-22 |
| HQ / Beverley physical infra | On-prem inventory | Eugene/Minda | `Infra-Inventory/Fishbone-HQ-Physical-Network-Inventory.md` | 2026-09-17 | live | 2026-10-22 |

## 4. Skills

**Eugene's own (`minda-ui/Eugene/.claude/skills/`)** — all live, last checked 2026-10-22, owner Eugene:
session-start-hook · composio-routine-setup · drive-sync-verified · email-reply-draft · end-of-day-wrapup ·
gmail-vendor-quote-draft · hardware-part-compatibility-check · raw-handoff-to-employee ·
shared-skill-package-for-upload · site-link-triage · tailscale-subnet-router.

**Shared library (`minda-ui/Fishbone-skills`, Alex curates; distributed via native claude.ai upload)** —
live, owner Alex/Victoria: ask-minda · hub-work-run · hub-close-on-finish (to retire once hub-work-run
proven) · mail-triage-by-labels · mail-work-from-labels · skill-build-and-handoff · drive-sync-verified
(shared copy) · raw-handoff-to-employee (shared copy). SC-8 `seat-settings-rollout` = **adopted, not yet
built**.

## 5. Connections

| Name | Type | Owner | Where / notes | Status | Last checked |
|---|---|---|---|---|---|
| Composio Google Drive (×~14) | OAuth per-account | Minda | 14 accounts listed; cap 10/app warning (AWT-0778). Default = `googledrive_behalf-geal` (work, **give it an alias**). `sarah-googledrive` (`googledrive_solely-hazing`) may duplicate the default. **`Mano Personal` (`googledrive_malmy-flem`) = Minda's personal, DO NOT use/change.** | live | 2026-10-22 |
| Composio Gmail | OAuth (minda@) | Minda | `eugene-gmail` draft-only; per-seat ops@ via Composio | live | 2026-10-22 |
| Composio GitHub | OAuth (Minda) | Minda | reaches all `minda-ui` repos incl. private | live | 2026-10-22 |
| Smartsheet | account-wide connector | Minda | Hub + registers | live | 2026-10-22 |
| Composio `ck_` consumer key | per-environment secret | Minda | lets unattended routines use the Composio **MCP** route (CLI can't sign in on ck_). Stored where secrets live — **value never held by Eugene** | live | 2026-10-22 |
| Tailscale (remote access) | VPN account | Minda | HQ + Beverley subnet routers (RND-5) | live | 2026-10-22 |

## 6. Single points of failure + what a restorable backup needs

| # | Single point of failure | Impact | Mitigation / backup need |
|---|---|---|---|
| SPOF-1 | **Minda's accounts** (Google super-admin, Composio, GitHub owner, Smartsheet, 1Password) | Everything runs **as** Minda; loss or compromise = estate-wide | **Enforce 2-step sign-in on every core account** (Google admin per tenant — OI-5; Composio; GitHub; Smartsheet). Recovery codes in 1Password. |
| SPOF-2 | **FusionPBX on the HQ DL380** (whole-company phones, both sites) | No telephony estate-wide | Nightly `vzdump → PBS → NAS` live (OI-17); restore tested (AWT-0028). Keep restore test quarterly. |
| SPOF-3 | **Inter-site airFiber link** (Beverley↔HQ) | Beverley services + cross-site phones | IPsec VPN fallback exists; monitor; `site-link-triage` skill. BT Business backup WAN **ends 27 Oct (OI-24)**. |
| SPOF-4 | **Drive as the single shared KB store** (all sessions write to it) | A bad write hits everyone | archive-then-recreate + byte-verify (drive-sync-verified); **git mirrors** per KB are the second copy; Rule C cross-branch check. Add a periodic **Drive→offline export**. |
| SPOF-5 | **Composio `ck_` key / connection set** | Unattended routines stop (can't reach Drive/Gmail/Sheets) | Key in 1Password; document the connection list (this register); alias the default Drive account (AWT-0778). |
| SPOF-6 | **Smartsheet Hub** (tasks/roster/registers) | Workforce coordination | Smartsheet is vendor-hosted (their backups); add a periodic **CSV/export snapshot** of the key sheets to the Financial/KB archive. |
| SPOF-7 | **Scoped access for any new person** | Over-broad access = blast radius | Grant least-privilege; record new grants in the Authority Register; review in the Quarterly sweep. |

**Backup posture to confirm with Minda:** (a) 2FA enforced on all core accounts; (b) nightly PBS backup +
quarterly restore test (live); (c) git mirror current for every KB (branch consolidation keeps `main`
fresh); (d) a periodic offline export of Drive + the key Smartsheet sheets (not yet in place — recommend).

## 7. Quarterly sweep — draft routine prompt (read-only; Minda creates in the form)

```
You are Eugene, the Fishbone Group's AI IT & Engineering Assistant, running the QUARTERLY GOVERNANCE &
TOOLING-HEALTH SWEEP. READ-ONLY: change nothing, hold no secret, guide-only (charter §3). Write one dated
digest into your Outputs/Runbooks and raise Open Issues / Hub rows for drift.

START: read CLAUDE.md, Charter-Rules.md, this Build Register (Runbooks/Build-Register-and-Ecosystem-
Protection-AWT-0775.md), and Infra-Inventory/.

DO, read-only:
1. SessionStart hooks: confirm each KB repo's default branch carries .claude/hooks/session-start.sh.
2. Routines: list the live routines (from Minda's routine set / triggers) and diff against §2 of the
   Build Register; flag added/removed/paused.
3. Connectors: diff the live Composio connections (Drive/Gmail/GitHub/Smartsheet) against §5; flag new,
   removed, duplicate, or mis-defaulted accounts (AWT-0778 pattern).
4. Access / permissions: for each knowledge system, repo and sheet, record who can read and who can write
   (the Drive-permissions + repo-collaborator + Smartsheet-share check); flag any over-broad grant against
   the Authority Register.
5. Backups: confirm the nightly PBS job ran and a restore test is in date; confirm each KB's git mirror is
   current; note if the offline Drive/Smartsheet export exists.
6. SPOF review: walk §6; flag any mitigation that has lapsed.

OUTPUT: a dated "Quarterly sweep" digest (counts + every drift item), one Open Issue per real drift, and a
Hub row only where a human step is needed. Refresh "date last checked" in the Build Register. Never execute
an access or backup change — recommend; Minda executes.
```

---

### Status / what's left (AWT-0775 / AWT-0778)
- **Done this pass:** the five-dimension register (assistants, routines, knowledge systems, skills,
  connections), the SPOF/backup table, the Quarterly-sweep draft prompt; AWT-0778 Composio-Drive findings
  folded into §5.
- **To confirm (needs Minda/Victoria):** the exact live routine list (§2) and the full per-account Drive
  connection list + default alias (§5); Victoria repo location; `?` dates.
- **To create:** the Quarterly sweep routine (via the form) once the routine/connection lists are confirmed.
- Register "date last checked" is refreshed each Quarterly sweep.
