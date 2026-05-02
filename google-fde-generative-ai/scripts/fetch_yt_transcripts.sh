#!/usr/bin/env bash
# Fetch subtitles for the 3 recruiter-PDF-linked YouTube videos.
set -euo pipefail

OUT_DIR="google-fde-generative-ai/interview-prep-unified/_transcripts"
mkdir -p "$OUT_DIR"

cd "$OUT_DIR"

for VID in "XKu_SEDAykw" "rgQm1KEIIuc" "Gg318hR5JY0"; do
  echo "== Fetching subtitles for $VID"
  yt-dlp --write-auto-sub --sub-langs en --sub-format vtt --skip-download --output "%(id)s.%(ext)s" "https://www.youtube.com/watch?v=$VID" 2>&1 | tail -3
done

echo ""
echo "== Files:"
ls -la
