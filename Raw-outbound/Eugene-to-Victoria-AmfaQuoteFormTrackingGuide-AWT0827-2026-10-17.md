# Runbook — Amfa quote-form conversion tracking (Tilda → GTM → GA4 → Google Ads)

> **AWT-0827 (Eugene, guide-only).** Written 2026-10-17. **Guide-only (charter §3): Eugene does NOT
> touch the live site, GTM, Tilda, GA4 or Google Ads — Minda or the site developer applies every step;
> Helen verifies.** The goal: make the **amfa.uk quote form (a Tilda form)** record a **conversion** so
> the "qualified enquiries per week" measure actually fires, flows into GA4 as a **key event**, and
> imports into **Google Ads** for optimisation.
>
> **Why this is needed** (from Helen's report AWT-0777, group KB Drafts `2026-10-17_Amfa_Live-Campaign-
> Report_AWT-0777_v1.md`): GA4 **556194113** and GTM **GTM-WLTMKHP5** are live on amfa.uk and receiving
> data (272 sessions), but the quote form has **no conversion event** — `form_submit` has **never
> fired**, and the only key events are Google defaults (`purchase`, `qualify_lead`, `close_convert_lead`).
> So the campaign can't be measured or optimised on real enquiries.
>
> **Coordination:** **Victoria (AWT-0828)** confirms the exact **GA4 event name + parameters** she wants
> (this guide uses a recommended default you can swap) and drafts the one-enquiry test plan; **Nadia
> (AWT-0829)** watches `enquiries@amfa.uk` for the TEST enquiry. **This guide is copied to Victoria's Raw.**

---

## The short version (what happens, in order)
1. **Tilda:** add a tiny script so a successful form submit pushes an event into the GTM "data layer".
2. **GTM:** a trigger catches that event and fires a **GA4 event** (default name here: `generate_lead`).
3. **GA4:** mark that event as a **key event**.
4. **Google Ads:** **import** the GA4 key event as a **conversion**.
5. **Test:** one marked TEST enquiry, verified in GTM Preview + GA4 DebugView (Helen confirms).

You do **not** need to be a developer. Each step is a form to fill in or a toggle to flip.

---

## Before you start — have these to hand
- **Tilda** login with edit rights to the amfa.uk project.
- **Google Tag Manager** access to container **GTM-WLTMKHP5** (Publish rights).
- **GA4** access to property **556194113** (Editor/Admin, to mark a key event).
- **Google Ads** access to the Amfa account (to import the conversion), and GA4↔Ads **linked**.
- The **event name Victoria confirms on AWT-0828** — this guide defaults to **`generate_lead`** (a Google
  "recommended" event, so Ads understands it as a lead). If Victoria names a different one, use hers
  **everywhere** below, spelled **exactly** (names are case-sensitive: `generate_lead` ≠ `Generate_Lead`).

---

## Step 1 — Tilda: tell GTM when the form is submitted

Tilda forms submit in the background (AJAX), so GTM's built-in "Form Submission" trigger **won't** see
them. The reliable way is to use Tilda's own **success event** (`tildaform:aftersuccess`), which Tilda
fires after a form is sent successfully, and push a named event into the data layer.

**Where to put it:** Tilda → your amfa.uk project → **Site Settings → More → Insert code** (the
site-wide "Inside the `<body>` / before `</body>`" box). Paste this exactly:

```html
<script>
document.addEventListener('DOMContentLoaded', function () {
  if (window.jQuery) {
    // Tilda fires this event after any form on the site is submitted successfully
    jQuery(document).on('tildaform:aftersuccess', function (event, object) {
      window.dataLayer = window.dataLayer || [];
      window.dataLayer.push({
        'event': 'quote_form_submit',                         // GTM listens for THIS name (Step 2)
        'form_name': (object && object.formid) ? object.formid : 'amfa_quote_form'
      });
    });
  }
});
</script>
```

Notes for whoever applies it:
- `'event': 'quote_form_submit'` is the **data-layer signal name** GTM will catch — keep it exactly, or
  change it in both places (here **and** Step 2's trigger).
- `generate_lead` (Step 2) is the **GA4 event** that ends up in reports/Ads; `quote_form_submit` is just
  the internal signal. They are deliberately different things.
- **Then publish the Tilda page(s)** (Tilda only applies code after a republish).
- ⚠️ The event name `tildaform:aftersuccess` is from Tilda-community docs; **confirm it fires in Step 5's
  Preview test.** If it doesn't, use the **thank-you-page fallback** below instead.

**Fallback (only if the success event doesn't fire):** set the Tilda form to **redirect to a
thank-you page** on success (Tilda form settings → "After submit" → redirect to e.g.
`amfa.uk/thank-you`). Then in Step 2 use a **GTM trigger of type "Page View"** (or "History Change" for
one-page sites) with **Page Path contains `/thank-you`**, instead of the Custom Event trigger. Everything
else (GA4 tag, key event, Ads import) is the same.

---

## Step 2 — GTM: fire a GA4 event when that signal arrives

In **Google Tag Manager** (container **GTM-WLTMKHP5**):

**2a. Make the trigger**
- **Triggers → New → Trigger Configuration → "Custom Event"**.
- **Event name:** `quote_form_submit` (must match Step 1 exactly).
- This trigger fires on **All Custom Events**. Name it `CE - Quote Form Submit`. Save.

**2b. Make the GA4 event tag**
- **Tags → New → Tag Configuration → "Google Analytics: GA4 Event"**.
- **Configuration / Measurement ID:** choose the existing Amfa GA4 configuration (the Google tag already
  in this container that sends to property 556194113). If it asks for a Measurement ID, it's the
  `G-XXXXXXX` for that property (GA4 → Admin → Data Streams → the amfa.uk web stream).
- **Event Name:** `generate_lead`  *(or Victoria's confirmed name from AWT-0828)*.
- **Event parameters** (optional but useful): add `form_name` = `{{DLV - form_name}}` — create that
  Data-Layer Variable (Variables → New → Data Layer Variable, name `form_name`).
- **Triggering:** choose `CE - Quote Form Submit` (from 2a). Name the tag `GA4 - generate_lead`. Save.

**2c. Publish** — click **Submit → Publish** in GTM. (Nothing is live until you publish.)

---

## Step 3 — GA4: mark it as a key event

In **GA4** (property **556194113**):
- **Admin → Data display → Key events** (older menus: **Events**).
- After the event has fired at least once (do Step 5 first, then come back), find **`generate_lead`** in
  the list and switch **"Mark as key event"** on. If it's a Google **recommended** event it may already
  be eligible; otherwise it appears here within ~24h of first firing.
- ⚠️ **Marking is not retroactive** — only enquiries from this point on count.

---

## Step 4 — Google Ads: import the key event as a conversion

A GA4 key event only drives Google Ads once you **import** it.
- First confirm **GA4 ↔ Google Ads are linked:** GA4 → **Admin → Product links → Google Ads links** (the
  Amfa Ads account should be listed; if not, link it — needs admin on both).
- In **Google Ads → Goals → Conversions → + New conversion action → Import → Google Analytics 4
  properties → Web**.
- Tick **`generate_lead`** (the key event) → **Import and continue**.
- Set it as a **Primary** action if you want it to drive bidding (Secondary = measured but not bid on).
- ⚠️ Expect a **lag** (imports can take hours–a day), **no historical backfill**, and that **Ads and GA4
  totals won't match exactly** (Ads credits the click date, GA4 credits the event date).

---

## Step 5 — Test it (one marked TEST enquiry — Helen verifies)

Do this **before** relying on any number, and coordinate with **Victoria's test plan (AWT-0828)** and
**Nadia (AWT-0829)** so the TEST enquiry isn't mistaken for a real lead.

1. In **GTM → Preview** (Tag Assistant), enter `https://amfa.uk` and connect.
2. On the live form, submit a **clearly-marked TEST** enquiry (e.g. name "TEST — ignore", a message that
   says TEST) from an address Victoria names.
3. In Tag Assistant, confirm: the **`quote_form_submit`** event appears **and** the **`GA4 - generate_lead`**
   tag **fired**.
4. In **GA4 → Admin → DebugView**, confirm **`generate_lead`** arrives in real time (with `form_name`).
5. **Helen** then checks GA4 **Realtime/DebugView** for the event, and after ~24–48h that it shows as a
   **key event** and the **Ads conversion** has imported (AWT-0828 step 3). **Nadia (AWT-0829)** confirms
   the TEST enquiry reached `enquiries@amfa.uk`.

If the event doesn't fire in step 3 → the Tilda success event name is the likely cause → switch to the
**thank-you-page fallback** in Step 1.

---

## Rollback (if anything misbehaves)
Nothing here changes the website's content or the form itself — only tracking — so rollback is clean:
- **GTM:** pause or delete the `GA4 - generate_lead` tag (and its trigger) → **Publish**. Tracking stops;
  site unaffected.
- **Tilda:** remove the `<script>` block from Site Settings → Insert code → republish.
- **GA4:** unmark the key event (Admin → Key events) if you need to.
- **Google Ads:** set the imported conversion to **Remove**/Secondary.
No enquiries, pages, or form behaviour are affected by any of these.

---

## Who does what (boundary — charter §2b)
- **Eugene:** this guide only. **Does not** touch the live site, Tilda, GTM, GA4 or Ads.
- **Minda / site developer:** applies Steps 1–4 (Tilda code, GTM publish, GA4 toggle, Ads import).
- **Victoria (AWT-0828):** confirms the GA4 event name + parameters, drafts the TEST plan, verifies in
  GA4/Ads with Helen.
- **Helen:** verifies the event fires and becomes a key event + Ads conversion.
- **Nadia (AWT-0829):** watches `enquiries@amfa.uk` for the TEST enquiry.

## Sources (method references)
- Tilda success-event form tracking: opsblu.com Tilda troubleshooting (`tildaform:aftersuccess`); Tilda
  Help Center "custom scripts after a successful form submission".
- GTM AJAX/custom-event form tracking + GA4 event tag: analyticsmania.com.
- GA4 key events + import into Google Ads (link → import → select key event; lag/backfill/attribution
  caveats): relevantaudience.com, theadspend.com 2026 guide.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
