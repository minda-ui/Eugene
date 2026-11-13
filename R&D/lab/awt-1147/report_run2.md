# Access audit (LAB PROTOTYPE v0.2, synthetic data) - 2026-11-12 13:31 UTC

**Export scope:** source: synthetic fixture; account: master core (read-only); listed: Drive files+folders incl. inherited, Smartsheet sheets+workspaces incl. published flag; not_listed: Gmail, shared drives of other tenants

Objects scanned: 7. Findings: 5. New since last run: 1. Resolved: 1.

| Change | Object id | Kind | Title | Home core | Finding |
|---|---|---|---|---|---|
|  | f1 | file | Fake budget A | master | CROSS-CORE WRITE: andrejus@example.test (secondary-a) on a master object outside the Collaboration Space |
|  | s2 | sheet | Fake public form data | secondary-b | PUBLIC published link (Smartsheet) |
|  | f3 | folder | Fake shared plan | master | MASTER-CORE object sits inside the Collaboration Space |
|  | f4 | file | Fake inherited share | master | CROSS-CORE read: irina@example.test (secondary-b) via parent folder 'Fake HR' on a master object outside the Collaboration Space |
| NEW | f6 | file | Fake new leak | master | UNKNOWN principal stranger@example.test (reader) - not on the core map |
| RESOLVED | f2 | | | | PUBLIC domainWithLink (reader) |

Report SHA-256: `31caefaa2d3f926f3d8051a7c2834e9fe2e7437872f786328c3fe13404c8f2e5`
