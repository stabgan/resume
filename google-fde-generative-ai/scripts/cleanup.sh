#!/usr/bin/env bash
# Repo cleanup. Keeps final prep files + originals (resume, PDF, emails).
# Removes old archive tree + one-off commit scripts.
# Local-only cleanup for .DS_Store / cert page scrap / playwright cache.

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

echo "== Repo root: $REPO_ROOT"
echo "== HEAD before: $(git log --oneline -1)"
echo ""

# -------- 1. Delete the old interview-prep/_archive tree --------
# Every file here was merged into interview-prep-unified/ weeks ago.
# Git history preserves it; you can recover via git log --diff-filter=D.
if [ -d "google-fde-generative-ai/interview-prep" ]; then
  echo "== Removing superseded archive tree: google-fde-generative-ai/interview-prep/"
  git rm -rf "google-fde-generative-ai/interview-prep"
else
  echo "== Archive tree already gone"
fi

# -------- 2. Delete one-off commit scripts, keep reusable helpers --------
echo ""
echo "== Removing one-off commit scripts (v5-v14 + older)"
for script in \
  "scripts/v5_compile_and_push.sh" \
  "scripts/v6_compile_and_push.sh" \
  "scripts/v6_final_push.sh" \
  "scripts/v7_preserve_uncommitted.sh" \
  "scripts/v8_archive_and_push.sh" \
  "scripts/v9_cases_and_build_plan_push.sh" \
  "scripts/v10_drill_materials_push.sh" \
  "scripts/v11_review_fixes_push.sh" \
  "scripts/v12_video_study_plan_push.sh" \
  "scripts/v13_blind_metric_adversarial_push.sh" \
  "scripts/v14_pdf_groundtruth_push.sh" \
  "scripts/build_and_check.sh" \
  "scripts/commit_and_push.sh" \
  "scripts/commit_interview_prep.sh" \
  "scripts/commit_jd_mining.sh" \
  "scripts/commit_v2_curriculum.sh" \
  "scripts/verify_and_push.sh" \
  "scripts/write_humanized_resume.sh"
do
  path="google-fde-generative-ai/$script"
  if [ -f "$path" ]; then
    git rm "$path"
  fi
done

# Keeping these because they're reusable + document how the raw data got here:
#   scripts/extract_recruiter_pdf.py  (PDF text extractor)
#   scripts/fetch_yt_transcripts.sh   (YouTube transcript fetcher)
#   scripts/clean_vtt.py              (VTT deduper)

# Replace this cleanup.sh itself with a short note explaining what was removed.
# Keep the file in history so anyone reading the repo knows cleanup happened.

# -------- 3. Local-only cleanup (never tracked) --------
echo ""
echo "== Removing untracked local junk (not in git)"
rm -f .DS_Store
rm -f "cert page scrap.txt"
rm -f ZED_FORK_PLAN.md
rm -rf .playwright-mcp

# Add .gitignore entries for anything that might come back
if [ ! -f .gitignore ] || ! grep -q ".DS_Store" .gitignore; then
  echo ""
  echo "== Refreshing .gitignore"
  cat > .gitignore <<'EOF'
# macOS
.DS_Store
**/.DS_Store

# Kiro IDE local state
.kiro/

# Playwright MCP browser cache (research artifacts only)
.playwright-mcp/

# Local-only working files with credentials / scratch
cert page scrap.txt

# Python cache
__pycache__/
*.pyc

# Virtual environments
venv/
.venv/
env/
EOF
  git add .gitignore
fi

# -------- 4. Show what is staged and commit --------
echo ""
echo "== Staged changes:"
git diff --cached --name-status

echo ""
echo "== Pushing..."

COMMIT_MSG="chore(fde): repo cleanup — keep finals, drop archive + one-off scripts

Kept:
  - All originals (recruiter PDF, 3 emails, resumes, root README)
  - 21 prep markdown files in interview-prep-unified/
  - cases/ (10 full case studies + README)
  - _leetcode_google_tags/ (5 CSVs + README, free LC Premium mirror)
  - _transcripts/ (3 Google interview-prep video transcripts)
  - 3 reusable helper scripts (extract_recruiter_pdf.py,
    fetch_yt_transcripts.sh, clean_vtt.py)

Removed:
  - interview-prep/_archive/ (entire tree, ~30 superseded drafts now
    fully absorbed into interview-prep-unified/)
  - 19 one-off commit/build scripts in scripts/ (v5 through v14,
    plus older commit_*, build_and_check, verify_and_push,
    write_humanized_resume). Their commits are in git history;
    the scripts themselves no longer carry value.

Local-only cleanup (never tracked):
  - .DS_Store
  - cert page scrap.txt (credential IDs)
  - ZED_FORK_PLAN.md (not interview prep)
  - .playwright-mcp/ (browser research artifacts)

.gitignore refreshed to keep these out permanently.

Repo state after this commit:
  14 tracked directories, ~50 files total (from ~100+ before).
  Every remaining file has a clear purpose."

git commit -m "$COMMIT_MSG"
echo "== Commit: $(git log --oneline -1)"
git push origin main
echo "== Pushed. HEAD: $(git log --oneline -1)"
