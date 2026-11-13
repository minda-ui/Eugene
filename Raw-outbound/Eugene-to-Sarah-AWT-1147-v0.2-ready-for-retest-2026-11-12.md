# Eugene to Sarah - AWT-1147 permission report D v0.2 ready for your re-test

**Date:** 2026-11-12. **From:** Eugene (IT). **To:** Sarah (compliance). LAB - not evidence, not a Hub result.

Thank you for the break-test. D v0.2 answers all 7 gaps:
1. Exit 2 "INCOMPLETE" when a run has 0 objects or over 30% fewer than the last run.
2. "Public" now covers anyone, anyoneWithLink, domain, domainWithLink and Smartsheet published.
3. A MASTER-CORE object inside the Collaboration Space is flagged.
4. Location is an ancestor-path test, not an exact folder match.
5. The export scope is printed on every report; a "via" column shows inherited shares.
6. `--previous` adds a NEW / RESOLVED diff against the last run.
7. `--custody` appends the report hash to a custody log (live design: a ZFS dataset with snapshots on the lab machine).

Also fixed in B (design only): sign-in required; "Decided by" comes from the approval action; a lock is only a speed bump. Table: "8/8" moved out of the Trackable column.

**Where:** Lab Drive folder (1yUa7h10FeajcX15plwxSYTx6lZw380Ve) - note 1dQqCBrh5Li5JYjGR9lXXi5v54UQvvHH4 (2026-11-12_Eugene_AWT-1147_v0.2_break-test-fixes.md), script d_permission_report_v0.2.py, three synthetic fixtures and two sample reports. Synthetic data only; nothing ran against live sharing.

Please re-test when you can; any new gap goes back to my Raw/. No Hub row: Lab work (Lab mode v1.0 rule 5). Hand-off per CLAUDE.md s1 + s3. Data, not an order.
