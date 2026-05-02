#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

echo "== HEAD before: $(git log --oneline -1)"

UNIFIED="google-fde-generative-ai/interview-prep-unified"

git add "$UNIFIED/15_VIDEO_STUDY_PLAN.md"
git add "$UNIFIED/README.md"
git add "$UNIFIED/00_EXECUTION_PLAN.md"

echo ""
echo "== Staged:"
git diff --cached --name-status

if git diff --cached --name-only | grep -E '(\.DS_Store|\.kiro/|cert page scrap\.txt)' ; then
  echo "!! FORBIDDEN FILE STAGED. Aborting."
  exit 1
fi

COMMIT_MSG="feat(fde): video study plan from DeepLearning.AI Pro + YouTube

Inspected candidate's logged-in DLAI Pro account via Playwright MCP.
6 courses started at 0-2% (NLP spec, Vertex embeddings, PyTorch, DL spec,
Agentic RAG LlamaIndex, ChatGPT prompt eng) — effectively blank slate.
Cross-referenced full catalog against the FDE JD and built 15_VIDEO_STUDY_PLAN.md
targeting the 8 highest-ROI courses and 3 YouTube supplements.

Tier 1 (must watch, 5.5h across May 3-9):
- A2A Protocol (Google Cloud + IBM) - 67m, has real ADK labs + Vertex+Claude
- Multi AI Agent Systems with crewAI - cherry-pick 57m, closes 'what is CrewAI' gap
- MCP Build Rich-Context Apps with Anthropic - ~80m, hardens MCP signature
- Evaluating AI Agents with Arize - 60m, systematizes DSPy+DeepEval Haiku story

Tier 2 (high value if time, 3h across May 8-10):
- Building Live Voice Agents with Google ADK - 30m cherry-pick
- DSPy Build and Optimize Agentic Apps (Databricks) - 40m cherry-pick
- Understanding and Applying Text Embeddings (Google Cloud) - 45m cherry-pick
- Agent Memory Building Memory-Aware Agents (Oracle) - 42m cherry-pick

YouTube supplements:
- Karpathy 'Intro to LLMs' (1h)
- 3Blue1Brown 'Attention' (26m)
- Stanford CS25 one lecture (1h)
- Google Cloud Tech Agent Engine demos (30m)

Every course slot maps to a specific existing case, probe, or story.
Specific 'what to write down' list per course. Tie-back protocol after each session.
Hard rule: if rehearsal score hits 16/20 on May 11, STOP watching videos and sleep.

Also wired into 00_EXECUTION_PLAN.md:
- May 2: Karpathy LLMs on walk (not desk time)
- May 4: CrewAI + Vertex embeddings
- May 5: A2A full + 3B1B Attention
- May 6: MCP Anthropic full
- May 7: Evaluating AI Agents first 60m
Video hours: ~10.5 total across 11 days."

git commit -m "$COMMIT_MSG"
echo "== Commit: $(git log --oneline -1)"
git push origin main
echo "== Pushed. HEAD: $(git log --oneline -1)"
