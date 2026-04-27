#!/usr/bin/env bash
# Commit and push the interview-prep curriculum.
set -euo pipefail

cd "$(dirname "$0")/../.."

# Keep local-only files out
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

git add google-fde-generative-ai/interview-prep/ \
        google-fde-generative-ai/scripts/

if git diff --cached --quiet; then
  echo "nothing to commit."
  exit 0
fi

git commit -m "docs(fde): add interview prep curriculum + research sources

Six-week curriculum for the Google Forward Deployed Engineer, Generative
AI, Google Cloud loop, based on:
  - 3 first-person Google-FDE interview write-ups (Medium, FDE Academy,
    ElevenLabs)
  - Sundeep Teki's FDE AI Engineer career guide (5 interview dimensions,
    evaluation weights)
  - Google Cloud ADK / Vertex AI Agent Engine / A2A protocol docs
  - 6 relevant arXiv papers (GEPA, DSPy declarative learning, VISTA,
    Small LLMs Are Weak Tool Learners, Context Engineering for
    Multi-Agent Code Assistants, Thucy multi-agent claim verification)

Artifacts:

- CHEATSHEET_recruiter_call.md -- one-pager for tomorrow 9:30 IST screen:
  60-sec intro script, comp-negotiation tree (current 33L + expected
  range 65-80L or 95L-1.2Cr depending on level), logistics answers,
  3 prepared questions, after-call follow-up template.

- CURRICULUM.md -- 6-week plan broken down:
  * Week 1: Google Cloud surface (ADK + Vertex AI Agent Engine + A2A) --
    biggest gap, close first. Build open-source project #1.
  * Week 2: DSA drilling (40+ medium-hard problems on Google Docs).
  * Week 3: AI/ML Round 1 (LLM prod systems, multi-agent patterns,
    DSPy/GEPA, embedding fine-tuning, RAG).
  * Week 4: System design with customer-infrastructure scenarios. Build
    open-source project #2.
  * Week 5: Customer scenarios + Googleyness (10 STAR stories).
  * Week 6: Mocks, polish, recovery.

- RESEARCH_SOURCES.md -- all cited sources with key takeaways and how
  each maps back to the 3 explicit JD requirements in Harish's email.

- README.md -- quick-start index + honest gap audit (ADK hands-on,
  Vertex AI Agent Engine, DSA on Google Docs flagged as highest-severity
  gaps).

Priority open-source projects (highest-ROI signal to Google reviewers):
  1. adk-langgraph-bridge -- reimplement a LangGraph supervisor/
     specialist workflow in ADK, deploy to Agent Engine (8-12 hrs)
  2. fde-reference-architecture -- mermaid diagrams + README for a
     customer-embedded agent reference (6-8 hrs)
  3. gepa-cookbook -- notebook comparing GEPA vs MIPROv2 (optional,
     10-15 hrs)

Bottom line: if only 3 weeks of prep available, do Weeks 1, 2, 5 in
that order. Everything else is nice-to-have."

git push origin main
echo ""
echo "done."
