#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

TEXFILE="${1:-article.tex}"
BASENAME="${TEXFILE%.tex}"

if ! command -v pdflatex >/dev/null 2>&1; then
    echo "Error: pdflatex is not installed or not on PATH." >&2
    exit 1
fi

echo "Compiling $TEXFILE..."
pdflatex -interaction=nonstopmode "$TEXFILE" || true
pdflatex -interaction=nonstopmode "$TEXFILE" || true

echo "Diagnostics from log..."
if [ -f "$BASENAME.log" ]; then
    grep -E "Warning|Error|undefined|Reference" "$BASENAME.log" || echo "(no warnings, errors, or undefined references)"
fi

echo "Cleaning up auxiliary files..."
for f in "$BASENAME".*; do
    case "$f" in
        *.pdf|*.tex) ;;
        *) rm -f "$f" ;;
    esac
done

echo "Build complete: $(pwd)/$BASENAME.pdf"
