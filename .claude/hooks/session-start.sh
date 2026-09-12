#!/bin/bash
# Eugene (AI IT & Engineering Assistant) — SessionStart hook.
#
# Installs the PDF toolkit so paper documents (scanned setup docs, vendor
# datasheets, the Finance archive) can be worked with quickly: text + TABLE
# extraction and OCR of scanned/image-only PDFs, instead of eyeballing page by
# page.
#
# Group standard — the same hook is in every Fishbone KB repo. Idempotent,
# non-interactive, web/remote sessions only. Never aborts the session:
# system-package (OCR) install is best-effort; the Python libraries are the
# guaranteed part.
set -uo pipefail

# Web/remote sessions only — do nothing on a local machine.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# --- OCR engine + PDF rasteriser (system packages; best-effort, needs sudo) ---
if ! command -v tesseract >/dev/null 2>&1 || ! command -v pdftoppm >/dev/null 2>&1; then
  if command -v sudo >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -qq 2>/dev/null || true
    sudo apt-get install -y -qq tesseract-ocr poppler-utils >/dev/null 2>&1 \
      || echo "session-start: tesseract/poppler not installed — OCR of scanned PDFs may be unavailable (native-text PDFs still work)" >&2
  fi
fi

# --- Python PDF libraries (text, tables, rendering, OCR bindings) ---
# pip is idempotent: already-satisfied packages are a no-op.
pip install --quiet pdfplumber pymupdf pdf2image pytesseract pillow pypdf \
  || echo "session-start: pip install of PDF libraries failed" >&2

exit 0
