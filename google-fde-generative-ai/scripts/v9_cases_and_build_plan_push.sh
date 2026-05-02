#!/usr/bin/env bash
# Archive the old single-file casebook, stage the 10 new case files + build plan + README updates, commit, push.
# Safe: excludes .DS_Store, .kiro/, cert page scrap.txt (contains credential IDs).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

echo "== Repo root: $REPO_ROOT"
echo "== HEAD before: $(git log --oneline -1)"

UNIFIED="google-fde-generative-ai/interview-prep-unified"
ARCHIVE_DIR="google-fde-generative-ai/interview-prep/_archive"

# 1. Move the old single-file casebook to the archive (uses git mv so history is preserved)
OLD_CASEBOOK="$UNIFIED/03_RRK_CASEBOOK.md"
NEW_CASEBOOK_PATH="$ARCHIVE_DIR/03_RRK_CASEBOOK_v1_skeleton.md"

if [ -f "$OLD_CASEBOOK" ] && [ ! -f "$NEW_CASEBOOK_PATH" ]; then
  echo "== Archiving $OLD_CASEBOOK -> $NEW_CASEBOOK_PATH"
  git mv "$OLD_CASEBOOK" "$NEW_CASEBOOK_PATH"
else
  echo "== Skipping archive step (already moved or source missing)"
fi

# 2. Stage only the files we want to commit. Explicit add-list, no bulk `git add .`
git add "$UNIFIED/cases/"
git add "$UNIFIED/11_BUILD_PLAN.md"
git add "$UNIFIED/01_SOURCE_OF_TRUTH.md"
git add "$UNIFIED/README.md"
git add "$UNIFIED/00_EXECUTION_PLAN.md"
# git mv above already staged the rename, but re-add to be explicit
if [ -f "$NEW_CASEBOOK_PATH" ]; then
  git add "$NEW_CASEBOOK_PATH"
fi

# 3. Show what is being committed
echo ""
echo "== Files staged for commit:"
git diff --cached --name-status

echo ""
echo "== Sanity check: confirm NO forbidden files are staged"
if git diff --cached --name-only | grep -E '(\.DS_Store|\.kiro/|cert page scrap\.txt)' ; then
  echo "!! FORBIDDEN FILE STAGED. Aborting."
  exit 1
fi
echo "   (none found)"

# 4. Commit with conventional message
COMMIT_MSG="feat(fde): 10 full case studies + 11-day GitHub build plan, replace 'don't claim' framing

- cases/: 10 spoon-fed RRK case studies (2000-3000 words each, 18-section template)
  01_slow_website.md (canonical recruiter prompt)
  02_enterprise_rag_bank.md (RBI bank, EmbeddingGemma)
  03_multi_agent_claims.md (IRDAI insurer, workflow-over-agent)
  04_mcp_oauth_tool_integration.md (Slack + ADK + OAuth/PKCE)
  05_eval_pipeline_agentic_support.md (4-layer eval framework)
  06_customer_data_readiness.md (healthcare, 4-week sprint)
  07_cost_reduction.md (7-lever framework, Haiku migration)
  08_scale_internal_to_external.md (6-month hardening)
  09_production_agent_debugging.md (7-class failure taxonomy)
  10_exec_discovery.md (C-suite portfolio scoping)
- cases/README.md: rehearsal schedule mapped to 00_EXECUTION_PLAN.md
- 11_BUILD_PLAN.md: 6 GitHub projects to ship in 11 days (ADK, CrewAI-vs-LangGraph, OAuth/PKCE, Vertex AI RAG Engine, A2A, VPC-SC)
- 01_SOURCE_OF_TRUTH.md: 'don't claim' section replaced with 'Your Gaps Are Closeable — Build Plan'
- Archived 03_RRK_CASEBOOK.md (skeleton) to _archive/03_RRK_CASEBOOK_v1_skeleton.md
- README.md + 00_EXECUTION_PLAN.md: point at cases/ folder and 11_BUILD_PLAN.md"

git commit -m "$COMMIT_MSG"

echo ""
echo "== Commit created:"
git log --oneline -1

# 5. Push to origin/main
echo ""
echo "== Pushing to origin main..."
git push origin main

echo ""
echo "== Done. HEAD after: $(git log --oneline -1)"
