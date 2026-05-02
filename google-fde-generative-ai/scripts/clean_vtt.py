#!/usr/bin/env python3
"""Deduplicate and clean VTT auto-subs into plain text."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "interview-prep-unified" / "_transcripts"

FILES = [
    ("Gg318hR5JY0.en.vtt", "systems_design.txt"),
    ("XKu_SEDAykw.en.vtt", "coding_interview.txt"),
    ("rgQm1KEIIuc.en.vtt", "life_in_appengine_production.txt"),
]

for src, dst in FILES:
    path = ROOT / src
    if not path.exists():
        print(f"Missing: {path}")
        continue
    raw = path.read_text()

    # Strip VTT header and timestamp lines
    lines = raw.splitlines()
    cues = []
    seen = set()
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if line.startswith("WEBVTT") or line.startswith("Kind:") or line.startswith("Language:"):
            continue
        if "-->" in line:
            continue
        # Strip VTT inline tags like <00:00:00.000><c> and </c>
        line = re.sub(r"<[^>]+>", "", line)
        line = line.strip()
        if not line:
            continue
        # Dedup consecutive repeated lines (auto-sub artifact)
        if line in seen:
            continue
        seen.add(line)
        cues.append(line)

    out_path = ROOT / dst
    out_path.write_text(" ".join(cues))
    print(f"{dst}: {len(cues)} unique lines, {len(out_path.read_text())} chars")
