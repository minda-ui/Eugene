# RND-31 — exo (exo-explore/exo): distributed inference across devices — WATCH

**Date:** 2026-11-04 · **Status:** parked (watch) · **Asked by:** Minda
**Source:** https://github.com/exo-explore/exo (README read 2026-11-04; Apache-2.0, by exo labs)

## What it is
Open-source software that joins several machines into one AI cluster and splits a model too big for any one of them across all of them. Devices discover each other on the LAN; it chooses the split (tensor or pipeline) from each device's memory and the latency/bandwidth of each link; ChatGPT-style API. Built around **Apple Silicon** (MLX backend), with RDMA over Thunderbolt 5 between Macs.

## Why not for us now
- **Linux = CPU only** ("GPU support under development", README). Our P40s / V100s would sit idle.
- Its NVIDIA route uses MLX's CUDA build (optional extras), which very likely needs newer cards than Pascal P40 (unverified — check if it matters).
- Needs fast, low-latency links. Splitting one model over the HQ↔Beverley airFiber (~415 Mb/s) would be slow and stop when the radio drops — same verdict as RND-27.
- Our stack (RND-30) already covers the need: llama.cpp splits a model across GPUs in one server, and its RPC mode can span machines (e.g. Gen9 + Gen10 over the 10G server triangle) if ever wanted.

## Revisit when
- exo ships GPU support on Linux for NVIDIA cards we own (Volta/Pascal), **or**
- the estate ever buys Apple Silicon Macs (e.g. Mac Studios) for AI.
Check the README/releases at the ~2028 hardware review (RND-30) or if either trigger happens sooner.
