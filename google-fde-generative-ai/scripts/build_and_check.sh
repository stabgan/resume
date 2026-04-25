#!/usr/bin/env bash
# Compile the FDE resume and report page count.
set -euo pipefail
cd "$(dirname "$0")/.."
tectonic resume_google_fde.tex 2>&1 | tail -3
echo ""
echo "=== PAGE COUNT ==="
mdls -name kMDItemNumberOfPages resume_google_fde.pdf
