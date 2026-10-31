# AI server option — HPE DL385 Gen10 Plus (AMD EPYC) vs DL380 Gen10 (Intel)

_R&D (creative mode, 2026-10-31, Minda asked "DL380 Gen10 vs DL385 Gen10"). Verified from HPE QuickSpecs
**a00073549enw** (DL385 Gen10 Plus) and **a00008180enw** (DL380 Gen10). Prices not yet checked. Guide-only (§3)._

| | DL380 Gen10 (plan) | DL385 Gen10 (original) | **DL385 Gen10 Plus** |
|---|---|---|---|
| CPUs | Intel Xeon Scalable | AMD EPYC 7001 | **AMD EPYC 7001/7002** (not 7003 — that's the "Gen10 Plus v2") |
| Memory | 6 ch/CPU, DDR4-2933 | 8 ch/CPU, 2666 | **8 ch/CPU, up to 3200 (1 DIMM/channel); 2933 at 2 DPC** |
| Peak memory bandwidth (2 CPUs) | ~282 GB/s | ~341 GB/s | **~410 GB/s** (~1.45× DL380 Gen10, ~2.7× Gen9) |
| PCIe | Gen3 | Gen3 | **Gen4** |
| CPU TDP limit with GPUs | ≤165 W | — | **≤240 W** |
| HPE-supported GPUs | V100/V100S ×3, P40 ×3, T4 ×7 | ~2 DW (3rd-party) | **V100S ×3 (8/16SFF 35 °C), A100 40 GB ×3, T4 ×8, RTX 4000/6000/8000** |
| V100S power cable | 871829-B21 | — | **871829-B21** ("for use with the V100S PCIe 32GB") |
| Riser cages w/o retainer | P38515/P38517-B21 | — | P38771/P38774-B21 |
| Fan kit | 867810-B21 | — | P14608-B21 (Max Performance) |

**Read:** for the RAM-bound 480B and a future A100 refresh, the **DL385 Gen10 Plus** is the stronger AI server.
Plain **V100 is not on its list — V100S is** (faster, ~1,134 GB/s). Skip the original DL385 Gen10 (Naples, Gen3).
**Gen10 Plus v2** (EPYC 7003) is better still if priced close. Notes: AMD has no AVX-512 on Rome (fine — RAM-bound);
16 DIMMs needed to fill all channels.
**Next:** price DL385 Gen10 Plus chassis + 2× EPYC 7002 + 16 DIMMs + 2× V100S vs the DL380 Gen10 plan.
