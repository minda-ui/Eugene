#!/usr/bin/env python3
# Import Drive-mirror documents into a PRIVATE Fishbone AI (Open WebUI) knowledge collection.
# Key: /root/.owui-key (chmod 600). State: /var/lib/owui-import/state.json. Usage: owui-import.py [LIMIT]
import json, os, sys, time, requests
URL = "http://10.224.10.31:3000"
ROOTS = ["/mnt/drive/mydrive", "/mnt/drive/shared"]
EXT = {".pdf", ".docx", ".xlsx", ".pptx", ".md", ".txt", ".csv"}
MAXB = 25 * 1024 * 1024
NAME = "Minda - Drive"
STATE = "/var/lib/owui-import/state.json"
H = {"Authorization": "Bearer " + open("/root/.owui-key").read().strip()}
limit = int(sys.argv[1]) if len(sys.argv) > 1 else 0
os.makedirs(os.path.dirname(STATE), exist_ok=True)
st = json.load(open(STATE)) if os.path.exists(STATE) else {"kb": None, "files": {}}

def save(): json.dump(st, open(STATE, "w"))

if not st["kb"]:
    kbs = requests.get(URL + "/api/v1/knowledge/", headers=H, timeout=60).json()
    kbs = kbs.get("items", kbs) if isinstance(kbs, dict) else kbs
    hit = [k for k in kbs if k.get("name") == NAME]
    if hit: st["kb"] = hit[0]["id"]
    else:
        r = requests.post(URL + "/api/v1/knowledge/create", headers=H, timeout=60,
                          json={"name": NAME, "description": "Private copy of Minda's Google Drive (read-only mirror)", "access_control": {}})
        r.raise_for_status(); st["kb"] = r.json()["id"]
    save(); print("knowledge collection:", st["kb"])

done = err = 0
for root in ROOTS:
    for d, _, fs in os.walk(root):
        for f in fs:
            p = os.path.join(d, f)
            if os.path.splitext(f)[1].lower() not in EXT: continue
            s = os.stat(p)
            if s.st_size == 0 or s.st_size > MAXB: continue
            sig = "%d:%d" % (s.st_size, int(s.st_mtime))
            old = st["files"].get(p)
            if old and old["sig"] == sig: continue
            try:
                if old:
                    requests.post(URL + "/api/v1/knowledge/%s/file/remove" % st["kb"], headers=H, json={"file_id": old["id"]}, timeout=120)
                with open(p, "rb") as fh:
                    r = requests.post(URL + "/api/v1/files/", headers=H, files={"file": (f, fh)}, timeout=600)
                r.raise_for_status(); fid = r.json()["id"]
                for _ in range(60):
                    r = requests.post(URL + "/api/v1/knowledge/%s/file/add" % st["kb"], headers=H, json={"file_id": fid}, timeout=600)
                    if r.ok: break
                    time.sleep(5)
                r.raise_for_status()
                st["files"][p] = {"sig": sig, "id": fid}; save(); done += 1
                print("OK ", p[len(root)+1:])
            except Exception as e:
                err += 1; print("ERR", p[len(root)+1:], str(e)[:150])
            if limit and done + err >= limit:
                print("done", done, "errors", err); sys.exit(0)
print("done", done, "errors", err)
