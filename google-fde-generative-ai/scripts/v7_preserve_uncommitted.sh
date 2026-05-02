#!/usr/bin/env bash
# Preserve all uncommitted prep work before reorganizing.
set -euo pipefail
cd "$(dirname "$0")/../.."

echo "=== Current uncommitted state ==="
git status --short

echo ""
echo "=== Excluding local-only files ==="
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

echo ""
echo "=== Staging all new prep material + official PDF + emails ==="
git add google-fde-generative-ai/

if git diff --cached --quiet; then
  echo "nothing to commit."
  exit 0
fi

git commit -m "feat(fde): preserve intensive + rapid prep tracks, official recruiter PDF, emails

Locking in the full working set before merging into a unified structure.

New material being preserved:

  google-fde-generative-ai/GenAI Forward Deployed Engineer (FDE) Prep Doc (1).pdf
    The official Google recruiter prep PDF. Authoritative source for
    loop shape (2 rounds: RRK 60 min + Coding 60 min, no execution,
    30-50 lines Python, OOP).

  google-fde-generative-ai/emails/
    shortlisting_email.eml -- confirms 2 rounds, interviews start
    May 6 on Wed/Thu cadence, Priyanka Biswas is the new contact.
    Your invitation to apply to Google.eml -- original invite with
    embedded JD text.
    Full thread from Harish as .eml.

  google-fde-generative-ai/interview-prep/may13-intensive-prep/
    13 files, ~3700 lines. High-volume track covering DSA foundations,
    Must-60/Should-40/Stretch-50 coding set, Python/OOP patterns,
    classic system design, ML/GenAI system design, Google Cloud FDE
    RRK, casebook + mocks, behavioral/presentation/comp, final
    cheatsheets, research sources.

  google-fde-generative-ai/interview-prep/may13-rapid-prep/
    7 files, ~2100 lines. Right-sized daily track with RRK master
    guide, RRK casebook, minimal coding set, behavioral stories,
    interview-day cheatsheet.

Key facts locked in from this material:
  - The loop is exactly 2 rounds: RRK 60 min + Coding 60 min
  - Coding is plain editor, no execution, Python + OOP, 30-50 lines
  - Interviews start May 6, Wed/Thu cadence
  - May 13 is the target prep date (earliest plausible slot after
    11 days of runway)
  - Priyanka Biswas is the new recruiting contact

Next step: merge best parts of both tracks into a single unified
folder, archive the separates."

git push origin main
echo ""
echo "preserved."
