# RND-8 Phase 0 — DocuSeal trial test script

_Goal: prove the RAMS → sign → signed-PDF loop on a **free DocuSeal Cloud trial**, with **zero infra and
no firewall change**, and settle the one open question: **does the DOCX-field-tags upload work on the
free/trial tier, or is it Pro?** (That's the A-vs-B decision.) ~30–45 min. Guide-only; Minda runs it._

**You'll need:** a browser + phone, the sample file **`Sample-RAMS-DocuSeal-Phase0.docx`** (in this
folder), and **two mailboxes you can open** — e.g. `minda@fishboneconstruction.co.uk` and one other
(a personal Gmail, or `info@…`) to play the "external subbie".

> No real secrets, no live estate system touched. This is a throwaway trial account you can delete after.

---

## Step 1 — Create a free trial account
1. Go to **docuseal.com** → **Sign up** (free trial). Use `minda@` (or a throwaway).
2. You land in the dashboard. (This is **Cloud** — fine for a test; the real thing will be self-hosted.)

## Step 2 — Upload the tagged RAMS (the key test) ⭐
1. **New → Create / Upload document →** upload **`Sample-RAMS-DocuSeal-Phase0.docx`**.
2. **Watch what happens** — this is the whole point of Phase 0:
   - ✅ **If DocuSeal auto-detects fields** (you see signature/date/text fields appear for *Director*,
     *Operative 1*, *Operative 2*) → **the DOCX-field-tags flow works on this tier.** Note whether a
     banner says it's a Pro/trial feature.
   - ❌ **If it ignores the `{{…}}` text** (they stay as literal text, no fields) or **blocks it behind an
     upgrade prompt** → **the DOCX-tags API is Pro** → we go **Option B (Pro)** or **Option A (build a
     fixed template in the UI by hand)**.
   - 📝 **Write down which happened** — that's the deliverable of this test.

## Step 3 — Check the three submitters / roles
- Confirm DocuSeal created **three roles**: **Director, Operative 1, Operative 2**.
- Assign emails: **Director → minda@**, **Operative 1 → your 2nd mailbox**, **Operative 2 → minda@**
  again (or a 3rd address). Names can be anything for the test.

## Step 4 — Send for signature
1. **Send**. DocuSeal emails each submitter a **signing link** (no account needed to sign).
2. Check the **two inboxes** — confirm the emails arrive (this proves the email/SMTP path).

## Step 5 — Sign on a phone (the subbie experience)
1. Open the **Operative 1** link **on your phone**, in a normal browser, **not logged in**.
2. Draw the signature, fill name/company/date, **Complete**.
3. Do the **Director** and **Operative 2** links too (the director signature + auto-date `datenow`).

## Step 6 — Collect the result (what Anna would file)
1. Back in the dashboard the submission shows **Completed**.
2. **Download the signed PDF** + the **audit trail / completion certificate** (PKCS#7).
3. Confirm: all signatures present, the **auto-date** filled itself, the audit trail lists each signer,
   time, and IP.

## Step 7 — (Optional) peek at the API
- In **Settings → API**, note there's an **API token** and **webhook** settings. We don't wire anything
  now — just confirm they exist on this tier. (Anna will later call `CREATE_SUBMISSION…` + receive the
  `form.completed` webhook.)

---

## What to report back to Eugene (the 4 answers)
1. **Did the DOCX `{{tags}}` auto-detect into fields?** (yes / no / blocked by upgrade prompt) ← the big one
2. Did all three signing emails arrive, and did phone-signing work with **no account**?
3. Did the **signed PDF + audit trail** download cleanly, with the auto-date filled?
4. Any **"Pro only"** banners on: DOCX upload, API, webhooks?

From those I settle **A (free + fixed template)** vs **B (Pro ~£16/mo)**, and then draft the self-host
deploy kit (compose, `.env.example`, Caddyfile, Anna's template + the exact Composio call) for the
recovered Proxmox.

## Clean up
Delete the trial document/account afterwards (it's Cloud; we don't keep estate data there). Nothing to
undo on our side — no infra or firewall was touched.
