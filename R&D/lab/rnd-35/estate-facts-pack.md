# Fishbone estate — facts pack for reviewers (RND-35 Lab test)

LAB item — not evidence, not a Hub result. Written by Eugene (IT), 2026-11-12, from his own KB.
Purpose: give an AI reviewer the facts about what the estate really runs, so it does not invent
systems. If something is not listed here, assume it does NOT exist and say so. No secrets, no
personal data.

## 1. How the AI workforce actually works
- 13 AI "seats" (Victoria, Peter, Eugene, Alex, Rachel, John, Anna, Darius, Nadia, Helen, Sarah,
  Laima, plus Andrejus's secondary-core assistant). Each is a Claude Code / claude.ai assistant
  with a written charter and a Knowledge Base (KB).
- **All master-core seats act as ONE Google identity: minda@.** Connectors (Google Drive, Gmail,
  Smartsheet, GitHub) and Composio run on Minda's login. Logs therefore cannot show which seat
  (or Minda) made a change. There are no per-seat service accounts today.
- Unattended work runs as **scheduled routines** that **only Minda can create**, by hand, in the
  claude.ai routines form. There is **no provisioning API** and no "assistant-creation endpoint".
- Each KB lives on **Google Drive** (a folder per seat) with a **git mirror** on GitHub. Cross-KB
  hand-offs go only through the receiving seat's `Raw/` folder (a note dropped in), never by
  editing another seat's files.

## 2. Coordination systems that exist
- **Smartsheet "AI Workforce Hub"**: sheets for Roster, Tasks & Requests (rows AWT-nnnn),
  Achievements, Help & Lessons, **Authority Register**, Build Register. Plain spreadsheets.
  Smartsheet keeps **cell history** and supports **approval requests** answered by email.
- **The gate** = one **Smartsheet exchange sheet per secondary core** (e.g. "Exchange - Irina",
  "Exchange - Andrejus"). Peter (AI) routes rows; Minda decides money/legal/signing. There is
  **no ticketing system, no gate service, no signed tickets, no database** (no Postgres/Airtable).
- **Master Core – Lab**: a Smartsheet index + a Drive Lab folder for research (this test).
- There is **no internal ACL / permission API** and **no in-house software team**. Permission
  checks today are read by hand or by a Lab prototype script (report "D", synthetic data only).

## 3. People and authority
- **Minda** is the final authority: only she changes sharing, routines, money or authority.
- **Andrejus** (director, co-owner of Fishbone Group) and **Irina** (Properties manager, co-owner
  of Anthill Homes) each have a **secondary core** outside the master core.
- Many decisions queue on Minda: ~38 open items on 12 Nov against a target of ~10.

## 4. Storage and data
- Documents: **Google Drive** (Google encrypts data at rest by default). Financial documents
  live only in the group Financial Archive folder. SSAS data lives in a Collaboration Space.
- Backups: Proxmox Backup Server on the HQ AI server (pve-ai) + copies to a second site
  (Beverley) and an older server (R710, being rebuilt). **A full restore has never been tested.**
- A nightly **read-only mirror of Minda's Google Drive** feeds a private collection in the
  local AI (Fishbone AI).

## 5. IT infrastructure (two sites, HQ and Beverley)
- Firewalls: OPNsense (HQ: a high-availability pair; Beverley: one box). The **old Cisco ASA
  still carries HQ's internet lines** until "Step B" (~late Nov).
- Switches: Cisco 3850s. Config backups of switches/firewalls are **planned, not built**.
- **No central monitoring or alerting** yet: a failed routine, backup or line is noticed only
  when someone looks.
- Local AI: **Fishbone AI** (Open WebUI + gpt-oss / Qwen models) on pve-ai, login-only, inside
  the office network. No per-group document access yet.
- Remote admin: Tailscale (no inbound ports opened on the firewalls).

## 6. Things that do NOT exist (do not assume them)
Provisioning API · ACL / permission API · ticketing or gate application · in-house dev team ·
per-seat service accounts · central monitoring · automated config backups · tested restore ·
custom databases (Postgres, Airtable) · PGP/signing infrastructure.

## 7. Instruction to the reviewer
Before your answer, **list every assumption you are making about our systems**. Mark each
recommendation as either "uses what exists" or "needs something new (name it, rough effort)".
