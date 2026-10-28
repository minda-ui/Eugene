# Runbook — AI machine P1 test: transcribe a voice note (Whisper, local STT)

> **Eugene, 2026-10-28 (guide-only, §3).** The second P1 smoke test on the on-site brain: one audio clip (a
> site voice note / voicemail) → text. Proves **local speech-to-text** on the P40 — the capability that turns
> the voice half of site chats (and voicemails, meetings) into something the brain can work. **Minda runs it
> on the box; Eugene guides + verifies. Local only — voice is personal data and never leaves the estate. This
> is a TEST; transcripts inform a human, they don't trigger anything on their own (§3).**
> Model/hardware facts verified 2026-10-28 (Whisper docs + P40 characteristics) — see sources at the end.

## The P40 fact that shapes this
The P40 has **no tensor cores and weak FP16**, so the usual **float16 Whisper is slow on it.** Use **int8**
(faster-whisper) or a **whisper.cpp CUDA** build instead. Two engines below — try both, keep the faster.

## Prerequisites
- [ ] 2× P40 fitted + baffle + driver **570+**; `nvidia-smi` shows the cards (same as the vision test).
- [ ] **ffmpeg** installed (audio decode): `apt-get install -y ffmpeg`.
- [ ] A **test audio file** on the box — a real site voice note (WhatsApp/Telegram `.ogg`/`.m4a`) or a quick
      phone recording `~/voicenote.ogg`. Pick one with site noise + an accent, not studio-clean — that's the
      real workload.

## Engine 1 (recommended) — faster-whisper, int8
Easiest to wire into the pipeline (Python), handles `.ogg/.m4a/.mp3/.wav` directly.
```bash
# faster-whisper needs CUDA 12 + cuDNN 9 present on the host/VM
pip install faster-whisper
```
```python
# transcribe.py
from faster_whisper import WhisperModel

# int8 on the P40 (NOT float16 — no tensor cores). int8 large-v3 ≈ 4 GB VRAM.
model = WhisperModel("large-v3", device="cuda", compute_type="int8")

segments, info = model.transcribe(
    "/home/minda/voicenote.ogg",
    language="en",            # or omit to auto-detect
    vad_filter=True,          # voice-activity filter — trims silence/noise (good for site clips)
)
print(f"[detected {info.language}, {info.duration:.1f}s]")
for s in segments:
    print(f"{s.start:6.1f}-{s.end:6.1f}  {s.text.strip()}")
```
```bash
python3 transcribe.py
```
If int8 is still slow or inaccurate, try `compute_type="int8_float16"`; if VRAM allows and you want to test
quality, `"float16"` — but expect it slow on Pascal.

## Engine 2 (alternative) — whisper.cpp, CUDA
Often the strongest Pascal option; wants 16 kHz mono WAV input.
```bash
git clone https://github.com/ggml-org/whisper.cpp && cd whisper.cpp
GGML_CUDA=1 make -j                      # CUDA build
./models/download-ggml-model.sh large-v3
# convert the clip to 16k mono wav, then run:
ffmpeg -i ~/voicenote.ogg -ar 16000 -ac 1 -c:a pcm_s16le ~/voicenote.wav
./build/bin/whisper-cli -m models/ggml-large-v3.bin -f ~/voicenote.wav -l en
```

## What good looks like, and iterate
- **Pass =** an accurate transcript of a real, noisy, accented site clip (names/materials/numbers right —
  "20 boards Thursday" comes through). Try 3–4 clips: clean, noisy, strong accent, one with site jargon.
- **Speed:** time it → the **real-time factor** (audio-seconds ÷ transcribe-seconds). On the P40, int8
  faster-whisper or whisper.cpp should be comfortably **faster than real-time** for large-v3. Watch
  `nvidia-smi` (VRAM small, temps stable = baffle OK).
- **If accuracy is weak on jargon:** that's expected for trade terms — note which words it misses; a small
  prompt/`initial_prompt` with common site terms (material names, your sites) sharpens it.
- **Speed vs quality:** if large-v3 is too slow, try **`large-v3-turbo`** (faster, ~same quality for English)
  or `medium` — compare on your clips. *(Verify the turbo model name on the engine's model list.)*

## If it fails
- **Very slow:** you're on **float16** → switch to **int8** (faster-whisper) or use whisper.cpp CUDA.
- **cuDNN / CUDA errors (faster-whisper):** CTranslate2 needs **CUDA 12 + cuDNN 9** — install/upgrade cuDNN 9,
  or fall back to whisper.cpp (self-contained CUDA build).
- **"No such file" / can't decode:** ffmpeg missing, or feed whisper.cpp a 16 kHz mono WAV (convert as above).
- **Runs on CPU (slow):** driver < 570 or CUDA not found → fix the driver, confirm `device="cuda"`.

## Next after this passes
→ **Voice-note transcription in the P2 feed:** the Telegram bridge hands each **voice note** to this same
Whisper call → the text joins the **daily summariser + request extractor** (so spoken updates count too). And
it's the **STT half** of the later voice interface (P4). See `estate-intelligence-software-buildlist.md`.

---
_Guide-only (§3): Minda runs it on the box + holds all creds; Eugene guides + verifies. Local only — voice is
personal data, it never leaves the estate; transcripts inform a human. Pairs with the P1 vision test, RND-17
(voice), RND-21 (site chat). Sources: faster-whisper / CTranslate2 docs (int8/float16, CUDA 12 + cuDNN 9),
whisper.cpp CUDA; P40 = no tensor cores / weak FP16._
