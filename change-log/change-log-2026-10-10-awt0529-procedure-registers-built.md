# Change log — 2026-10-10 — AWT-0529: built the three procedure-set registers (Smartsheet)

_Minda: "build it." In-charter infrastructure build (§2b/§2e) in the group **Fishbone Group – Documents**
Smartsheet workspace. No secret held._

## Built (Fishbone Group – Documents workspace `5815486484113283`, next to the Document Register)
Columns per the v1.1 proposal §3 (spelled out in AWT-0529):
1. **Procedure Register** (sheet `4244584085456772`) — 14 cols: Procedure ID (primary) · Title · Level
   (1/2/3) · Version · Status (Draft/Approved/Superseded) · Approved by · Approved date · Document number ·
   Lead assistant (picklist incl. Sarah) · Audience (Client-shareable/Internal) · Applies to (companies) ·
   Next review date · Conditions · File location.
   https://app.smartsheet.eu/sheets/ccPvFp7G6Qw47Cqr6C9Wfjw6pg6FJ6qGm6PpWGr1
2. **Procedure Link Register** (sheet `8063737724536708`) — 7 cols: From (procedure + clause) (primary) ·
   To (procedure + clause) · Link type (Hands off to / Depends on / Uses record from / Same term) · What
   passes across · Version of each end when last checked · **Status (Consistent/Needs review/Conflict)**
   (col `7409771164075908`) · Date checked.
   https://app.smartsheet.eu/sheets/jM6XgJ77x4g5jCmfmhXfhHJGq925xCMj5VMH6Gf1
3. **Procedure Shared Terms** (sheet `3190427312326532`) — 4 cols: Term (primary) · Definition · Owning
   procedure · Used in.
   https://app.smartsheet.eu/sheets/8wX9mxq3jwcj8HvFjmMxQ8Jm5MFwcfpG3hgCVgp1

## Sharing
"Share like the Document Register" — checked the Document Register's shares: only `minda@` (OWNER, ITEM
scope); no other user/group shares. All three new sheets are in the same workspace under the same account
→ **identical sharing**, requirement met by placement. (All AI employees operate Smartsheet *as* `minda@`.)

## Sarah's permission (charter amendment A1) — flagged, not a Smartsheet share
A1 = Sarah may read + **write the Link Register *Status* column only**. Because everyone uses Smartsheet as
`minda@` (no separate per-assistant logins), this can't be a Smartsheet user-share. It's enforced by
**Sarah's own connector scope / charter A1** when she goes live (she's scaffolded but not live — AWT-0520/
0521). The Status column id is recorded above so her setup can target exactly it; a hard column-lock (lock
every Link Register column except Status) is available on request but would also block other Editors, so
only if the data-entry roles are Admins. Flagged to Victoria.

## Hand-offs
- **Reported to Victoria** via her Raw (`2026-10-10_Eugene-to-Victoria_Procedure-set-registers-BUILT-
  AWT-0529.md`, byte-verified) with the three links, so she enters **P04 v1.0** + the first shared terms.
- **Hub AWT-0529 → Done** (own-row, Green, done date 2026-10-10) with the full result.

## Notes
Guide-only not applicable (this is Eugene's own build authority); no live-system change; no credential.
First use of `create_sheet` for a real group deliverable — a candidate pattern if more registers are needed.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
