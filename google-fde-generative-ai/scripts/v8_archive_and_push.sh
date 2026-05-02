#!/usr/bin/env bash
# Archive old prep folders (rename, don't delete) and push the unified folder.
set -euo pipefail
cd "$(dirname "$0")/../.."

echo "=== Archiving old prep folders ==="
# Move old split folders into an _archive subdirectory so nothing is lost.
mkdir -p google-fde-generative-ai/interview-prep/_archive

if [ -d google-fde-generative-ai/interview-prep/may13-intensive-prep ]; then
  git mv google-fde-generative-ai/interview-prep/may13-intensive-prep \
         google-fde-generative-ai/interview-prep/_archive/may13-intensive-prep
fi

if [ -d google-fde-generative-ai/interview-prep/may13-rapid-prep ]; then
  git mv google-fde-generative-ai/interview-prep/may13-rapid-prep \
         google-fde-generative-ai/interview-prep/_archive/may13-rapid-prep
fi

# Also move the original pre-split files (CURRICULUM.md etc) into _archive so
# only the new unified folder is the active prep surface.
for f in CURRICULUM.md CURRICULUM_6WEEK_archive.md CODING_ROUND_PROTOCOL.md \
         DSA_RECOVERY.md STAR_STORIES.md RESEARCH_SOURCES.md \
         CANONICAL_JD.md CHEATSHEET_recruiter_call.md README.md; do
  src="google-fde-generative-ai/interview-prep/$f"
  dst="google-fde-generative-ai/interview-prep/_archive/$f"
  if [ -f "$src" ]; then
    git mv "$src" "$dst"
  fi
done

# Keep the local-only files out
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

echo ""
echo "=== Staging unified folder + scripts ==="
git add google-fde-generative-ai/

# Write a small top-level README inside interview-prep/ pointing to the unified folder
cat > google-fde-generative-ai/interview-prep/README.md << 'EOF'
# Interview Prep

The active prep surface is in [`../interview-prep-unified/`](../interview-prep-unified/).

This folder previously held two separate tracks (intensive + rapid) and the
original split files. Those have been merged into the unified folder and
archived at `_archive/` for reference.

Start here: [`../interview-prep-unified/README.md`](../interview-prep-unified/README.md)
EOF

git add google-fde-generative-ai/interview-prep/README.md

echo ""
echo "=== State before commit ==="
git status --short

echo ""
echo "=== Committing ==="
git commit -m "refactor(fde): merge intensive+rapid tracks into unified interview-prep folder

Anchored on the intensive track per candidate request, merged the best
parts of the rapid track and the original split files. New facts
incorporated:

  - INTERVIEW IS SAME-DAY (both RRK + coding on one day)
  - CODING IS PLAIN GOOGLE DOC, WHITEBOARD STYLE, NO IDE, NO EXECUTION

These two facts reshape the prep:
  - Coding protocol hardened for no-IDE environment (muscle memory
    priming, 3-line warmup every morning, say-every-line-aloud habit).
  - Day-of doc written specifically for same-day back-to-back energy
    management: protein breakfast, water pacing, 15-min between-round
    reset, Round 2 gets 2 extra minutes of clarifying time because the
    candidate will be depleted.

New unified folder: google-fde-generative-ai/interview-prep-unified/
  00_EXECUTION_PLAN.md         day-by-day May 2 to May 13
  01_SOURCE_OF_TRUTH.md        loop facts, JD evidence, your evidence
  02_RRK_MASTER_GUIDE.md       the main spine (discovery->deployment)
  03_RRK_CASEBOOK.md           10 customer cases with answer skeletons
  04_CODING_PROTOCOL.md        Google-Doc mechanics + 40-min protocol
  05_CODING_PROBLEM_SET.md     22-problem core + 12-problem emergency
  06_PYTHON_AND_OOP.md         imports, idioms, 3 OOP patterns
  07_SYSTEM_DESIGN.md          classic + ML + GenAI design
  08_GCP_AND_FDE_VOCABULARY.md product map + decision trees + phrases
  09_STORIES_AND_COMP.md       8 STAR stories + negotiation script
  10_INTERVIEW_DAY.md          same-day logistics + cheatsheet

Archived for reference:
  interview-prep/_archive/may13-intensive-prep/   (13 files)
  interview-prep/_archive/may13-rapid-prep/       (7 files)
  interview-prep/_archive/CURRICULUM.md           (previous version)
  interview-prep/_archive/CURRICULUM_6WEEK_archive.md
  interview-prep/_archive/CODING_ROUND_PROTOCOL.md
  interview-prep/_archive/DSA_RECOVERY.md
  interview-prep/_archive/STAR_STORIES.md
  interview-prep/_archive/RESEARCH_SOURCES.md
  interview-prep/_archive/CANONICAL_JD.md
  interview-prep/_archive/CHEATSHEET_recruiter_call.md
  interview-prep/_archive/README.md

Best-of inclusions in the unified folder:
  - Intensive track's depth and daily-operating-system structure
  - Rapid track's 60-second opener, RRK master guide structure,
    behavioral-phrases 'say this / not that' lists, casebook cases
  - Original curriculum's pattern-first DSA approach, STAR story
    follow-ups, comp negotiation tree
  - New: same-day energy management, 15-min between-round reset protocol,
    Google Doc warmup ritual"

git push origin main
echo ""
echo "done. merged + archived + pushed."
