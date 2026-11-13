#!/usr/bin/env python3
"""Option D prototype v0.2 (AWT-1147, Lab only, SYNTHETIC data).

Read-only access-audit report. Input: an inventory export (objects + sharing) and a core map.
Output: markdown report + a findings JSON for the next run's diff. Never calls an API.

v0.2 closes Sarah's break-test gaps (12 Nov, AWT-1148):
 1 empty / sharply shrunken inventory -> exit 2 (INCOMPLETE), never "0 findings, clean"
 2 public = anyone, anyoneWithLink, domain, domainWithLink, Smartsheet published links
 3 master-core object found inside the Collaboration Space -> own finding line
 4 Collaboration Space test uses the object's ancestor path, not an exact location match
 5 export scope (source, account, what was / was not listed) printed on every report
 6 diff against the previous run: NEW / RESOLVED / unchanged
 7 hash custody: the hash is also appended to a custody log that a seat cannot write
   (live design: a ZFS dataset on the lab machine with daily snapshots - see notes)
Exit codes: 0 clean, 1 findings, 2 incomplete input (alert either way).
"""
import argparse, hashlib, json, os, sys
from datetime import datetime, timezone

PUBLIC = {"anyone", "anyoneWithLink", "domain", "domainWithLink"}
WRITE = {"writer", "editor", "owner", "admin", "fileOrganizer", "organizer"}
DROP = 0.30  # >30 % fewer objects than last run = suspicious export

def load(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)

def classify(obj, cores, collab, master):
    out = []
    home = obj["home_core"]
    ancestors = obj.get("ancestors", []) + [obj.get("location", "")]
    in_collab = collab in ancestors
    if obj.get("published"):
        out.append("PUBLIC published link (Smartsheet)")
    if in_collab and home == master:
        out.append(f"MASTER-CORE object sits inside the Collaboration Space")
    for g in obj.get("shared_with", []):
        who, role = g["principal"], g["role"]
        if who in PUBLIC:
            out.append(f"PUBLIC {who} ({role})"); continue
        p_core = cores.get(who)
        if p_core is None:
            out.append(f"UNKNOWN principal {who} ({role}) - not on the core map")
        elif p_core != home and not in_collab:
            sev = "WRITE" if role in WRITE else "read"
            via = f" via {g['via']}" if g.get("via") else ""
            out.append(f"CROSS-CORE {sev}: {who} ({p_core}){via} on a {home} object outside the Collaboration Space")
    return out

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("inventory"); ap.add_argument("coremap")
    ap.add_argument("-o", "--out", required=True, help="report .md; findings JSON written next to it")
    ap.add_argument("--previous", help="findings JSON of the last run (for diff + drop check)")
    ap.add_argument("--custody", help="append-only custody log for the report hash")
    a = ap.parse_args()
    inv, cm = load(a.inventory), load(a.coremap)
    scope = inv.get("scope", {"note": "NOT STATED by the export"}) if isinstance(inv, dict) else {"note": "NOT STATED by the export"}
    objs = inv["objects"] if isinstance(inv, dict) else inv
    prev = load(a.previous) if a.previous and os.path.exists(a.previous) else None

    problems = []
    if len(objs) == 0:
        problems.append("Inventory has 0 objects")
    if prev and prev["objects"] and len(objs) < prev["objects"] * (1 - DROP):
        problems.append(f"Inventory dropped from {prev['objects']} to {len(objs)} objects (> {int(DROP*100)} %)")

    rows = []
    for o in objs:
        for f in classify(o, cm["principals"], cm["collaboration_space"], cm.get("master_core", "master")):
            rows.append({"id": o["id"], "kind": o["kind"], "title": o["title"], "home": o["home_core"], "finding": f})
    keys = {f"{r['id']}|{r['finding']}" for r in rows}
    old = set(prev["keys"]) if prev else set()

    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    L = [f"# Access audit (LAB PROTOTYPE v0.2, synthetic data) - {now}", ""]
    if problems:
        L += ["**INCOMPLETE INPUT - do not read this as clean:** " + "; ".join(problems), ""]
    L += ["**Export scope:** " + "; ".join(f"{k}: {v}" for k, v in scope.items()), "",
          f"Objects scanned: {len(objs)}. Findings: {len(rows)}."
          + (f" New since last run: {len(keys - old)}. Resolved: {len(old - keys)}." if prev else " (no previous run to diff)"), "",
          "| Change | Object id | Kind | Title | Home core | Finding |", "|---|---|---|---|---|---|"]
    order = lambda r: ("WRITE" not in r["finding"], "PUBLIC" not in r["finding"], "MASTER" not in r["finding"], r["id"])
    for r in sorted(rows, key=order):
        ch = "NEW" if prev and f"{r['id']}|{r['finding']}" not in old else ""
        L.append(f"| {ch} | {r['id']} | {r['kind']} | {r['title']} | {r['home']} | {r['finding']} |")
    for k in sorted(old - keys):
        oid, f = k.split("|", 1)
        L.append(f"| RESOLVED | {oid} | | | | {f} |")
    body = "\n".join(L) + "\n"
    digest = hashlib.sha256(body.encode()).hexdigest()
    body += f"\nReport SHA-256: `{digest}`\n"
    open(a.out, "w", encoding="utf-8").write(body)
    json.dump({"objects": len(objs), "keys": sorted(keys), "sha256": digest, "at": now},
              open(os.path.splitext(a.out)[0] + ".findings.json", "w"))
    if a.custody:
        with open(a.custody, "a", encoding="utf-8") as c:
            c.write(f"{now}\t{os.path.basename(a.out)}\t{digest}\n")
    return 2 if problems else (1 if rows else 0)

if __name__ == "__main__":
    sys.exit(main())
