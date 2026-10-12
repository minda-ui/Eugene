# Runbook — OI-8 last mile v2: recover PBX SSH (close OI-18), trace with sngrep, find & fix the no-ring

> **Status:** READY 2026-10-12. Supersedes the blind-GUI approach of `Runbook-OI8-Inbound-Ring-EarlyMedia-Fix.md`
> for the *diagnosis* step. Guide-only (§3): **Minda executes, Eugene guides + verifies.** Off-hours /
> phones-free window. The whole point: **stop guessing — get eyes on the actual call + config.**

## Why v2 (what we already tried, 2026-10-12 — do NOT repeat)
Inbound reaches the PBX and routes, but the desk (1001) never audibly rings; a leg bridges out to the
mobile **`447855463292`** and its early media pre-answers the call. **Confirmed clean:** extension **1001**
and **1002** call-forward / follow-me / DND; the **Boss** ring group's own "Ring Group Forward" (Disabled).
**Tried and reverted, none fixed it:** `ignore_early_media=ring_ready` (webmate_inbound_did dialplan);
`enable-100rel=false` (external SIP profile); Boss ring-group Strategy `Simultaneous → Enterprise`.
So the mobile leg is wired in **somewhere the GUI isn't showing us**, and we have **no SIP/media visibility**
— both solved by getting SSH (OI-18). Background: `Wiki/FreeSWITCH-EarlyMedia-RingGroups.md`.

## 0. Pre-flight
1. Phones-free window confirmed.
2. **Proxmox snapshot VM 105** → `pre-oi8-ssh-recovery-<date>`.
3. Baseline: internal **1002→1001** rings + audio; one **outbound** call works.
4. Have the Proxmox console for VM 105 open.

## Part A — Recover PBX OS/SSH (closes OI-18)
VM 105 = FusionPBX on **Debian**; root password expired, root SSH denied. Reset via console (same method
as the other boxes today):
1. Proxmox → **VM 105 → Reboot**, watch the **console** (this drops calls ~1–2 min — hence phones-free).
2. At the **GRUB** menu (tap `Esc`/`Shift` if it flies past) → highlight the default entry → press **`e`**.
3. Find the line starting `linux …`; go to its **end** and append a space then **`init=/bin/bash`**
   (and, if present, **delete `quiet`** so the shell prompt is visible — the `quiet` trap we hit on
   `public-proxy`). Press **`Ctrl-X`** to boot.
4. At the `#` root shell:
   ```sh
   mount -o remount,rw /
   passwd root                 # Minda sets a strong pw → 1Password; Eugene never sees it
   # allow SSH in for the diagnosis (tighten again after):
   grep -n PermitRootLogin /etc/ssh/sshd_config
   # if it's 'no'/'prohibit-password', set to 'yes' temporarily, OR use an existing sudo user instead
   ```
5. Reboot cleanly: from `init=/bin/bash` use `exec /sbin/init` **or** reset the VM from Proxmox.
6. Confirm phones came back (internal + outbound), then **SSH in** from the Proxmox host:
   `ssh root@10.224.13.9`.
   - If a FusionPBX/`fusionpbx` sudo user already exists, prefer that over enabling root SSH.

## Part B — Trace ONE inbound call (sngrep + fs_cli)
With SSH in:
```sh
which sngrep || apt-get install -y sngrep      # live SIP ladder
fs_cli                                         # FreeSWITCH console; then: /log 7   (Ctrl+L to clear)
```
In **sngrep**, place **one** inbound call to `01916052945` and read:
- The **inbound INVITE** from WebMate (`52.28.7.189`) — the **Request-URI / To** (is it the DID, or the
  mobile, or the trunk username? this is the "username-in-R-URI" history).
- Which legs FreeSWITCH **originates**: an INVITE to the **1001 handset** (`10.224.13.10`)? an INVITE
  **out to the gateway** toward **`447855463292`**? both?
- **180 vs 183** on each leg — confirm whether the desk leg gets a 183 (pre-answer) instead of 180 (ring).
This answers *both* unknowns: where the mobile leg is born, and whether the desk leg is being pre-answered.

## Part C — Find where `447855463292` is wired (one command)
```sh
grep -rin 447855463292 /etc/freeswitch/ 2>/dev/null
# FusionPBX keeps dialplans/destinations/forwards in Postgres, not just files — search the DB too:
sudo -u postgres psql fusionpbx -c "select dialplan_name  from v_dialplans       where dialplan_xml ilike '%447855463292%';"
sudo -u postgres psql fusionpbx -c "select dialplan_detail_data from v_dialplan_details where dialplan_detail_data ilike '%447855463292%';"
sudo -u postgres psql fusionpbx -c "select destination_number, destination_actions, destination_data from v_destinations where destination_number ilike '%1916052945%' or destination_actions ilike '%447855463292%' or destination_data ilike '%447855463292%';"
sudo -u postgres psql fusionpbx -c "select * from v_follow_me_destinations where follow_me_destination ilike '%447855463292%';"
sudo -u postgres psql fusionpbx -c "select extension, forward_all_destination, forward_busy_destination, forward_no_answer_destination, forward_user_not_registered_destination, do_not_disturb, follow_me_enabled from v_extensions where forward_all_destination ilike '%447855463292%' or forward_busy_destination ilike '%447855463292%' or forward_no_answer_destination ilike '%447855463292%' or forward_user_not_registered_destination ilike '%447855463292%';"
sudo -u postgres psql fusionpbx -c "select ring_group_name, ring_group_forward_destination from v_ring_groups where ring_group_forward_destination ilike '%447855463292%';"
sudo -u postgres psql fusionpbx -c "select r.ring_group_name, d.destination_number from v_ring_group_destinations d join v_ring_groups r using(ring_group_uuid) where d.destination_number ilike '%447855463292%';"
```
(If the DB name/user differ, get them from `/etc/fusionpbx/config.conf`.) One of these **will** show the
exact row holding the mobile — a stray dialplan, a destination action, a follow-me row, or a ring-group
member with an external dialstring that the GUI didn't render.

## Part D — Apply the targeted fix (depends on what B+C reveal)
- **If the mobile is a stray forward/dialplan/destination** not wanted on inbound → remove it / repoint the
  DID straight to **1001** (or the Boss group without the mobile). One change, reload XML, test one call.
- **If the mobile ring IS wanted** (boss wants calls on desk + mobile) → the real fix is to stop the
  mobile leg's early media pre-answering the desk: set **`ignore_early_media=true`** on the **right** leg
  (the originate to the gateway, or the bridge), confirmed from the sngrep ladder — not guessed.
- Keep it minimal, one change at a time, reload XML, **one** test call, revert if no help.

## Part E — Verify, persist, close
- Genuine external inbound call **rings the desk + two-way audio**; internal + outbound still fine.
- **Snapshot VM 105** `oi8-inbound-ringing-<date>`.
- Re-tighten SSH (`PermitRootLogin` back, or rely on the sudo user); note the new root pw is in 1Password.
- Fix **OI-19** (CDR) if needed so the inbound is logged; mark **OI-8 Resolved** only on a proven
  inbound ring+connect verified against the CDR.

## Guardrails
Snapshot before each change; one change at a time; **never `.*`**; never delete `local_extension`; recovery
card if anything breaks: **SIP Status → Flush Cache → Reload XML → Restart internal**; worst case roll back
the VM snapshot. The VM 105 reboot in Part A is the only disruptive step — phones-free window only.

## Related
`Wiki/FreeSWITCH-EarlyMedia-RingGroups.md`, `Runbook-OI8-Inbound-Ring-EarlyMedia-Fix.md` (v1, early-media
knobs — now largely ruled out), `open-issues.md` OI-8 / **OI-18** (this closes it) / OI-19,
`change-log/change-log-2026-10-10-oi8-inbound-rebuild-executed.md`.
