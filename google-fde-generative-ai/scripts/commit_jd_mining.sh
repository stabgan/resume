#!/usr/bin/env bash
# Commit the JD mining + refined curriculum.
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

git commit -m "docs(fde): canonical JD from mining 10 live Google FDE postings; refine curriculum

Mined 10 live Google FDE GenAI postings across variants:
  * India (Bengaluru/Mumbai/Gurugram) -- your req
  * US generic; US advanced (Staff); US entry (FDE I)
  * UK (London); DACH (Germany/Austria/Switzerland)
  * Singapore (Mandarin); Japan (Japanese+English)
  * Telecom vertical; GenMedia vertical; Applied AI (conversational) sibling

Synthesized into CANONICAL_JD.md -- the single-source-of-truth for what
Google is actually hiring for. Key findings:

1. Role definition is verbatim across 8 of 10 postings: 'embedded builder
   who bridges the gap between frontier AI products and production-grade
   reality within customers.' Variant framings: builder-consultant,
   innovator-builder, high-agency engineer with founder's mindset.

2. Four universal responsibilities (appear near-verbatim on almost every
   posting): lead dev for prototype->prod agentic workflows / architect
   connective tissue to customer live infra / build eval + observability
   pipelines / convert field insights to product feature requests.

3. Min-quals vary by seniority tier: Early (2-3 yrs), Mid (3 yrs), Senior
   (6-8 yrs, the India/Singapore tier), Staff (10+ yrs). Recruiter
   reached out at 5.5 yrs so Google is flexing on years for signal density.

4. Preferred-qual list is remarkably consistent: Master's/PhD, multi-agent
   via LangGraph/CrewAI/ADK w/ ReAct+self-reflection+hierarchical
   delegation, LLM-native metrics (tokens/sec, cost-per-request), MCP +
   tool-calling + OAuth 2.0, large-scale fine-tuning w/ accelerators.

5. Google-specific tech stack that interview rounds will probe:
   Vertex AI Agent Builder umbrella (ADK, Agent Engine, Agent Studio,
   Agent Garden, Memory Bank, Agentspace, Vertex AI Search, Model
   Garden), A2A protocol, BigQuery grounding, Cloud Run + IAP + VPC-SC
   + Private Service Connect + Workload Identity Federation, Apigee,
   Terraform (explicitly a min-qual on the Applied AI variant).

6. The 6 capabilities Google grades against (derived from mining):
   (1) production agentic systems on GCP, (2) messy customer infra
   integration, (3) eval + observability with LLM-native metrics,
   (4) discovery->spec->ship with C-suite, (5) Python under pressure,
   (6) field-insight->product-feedback translation.

CURRICULUM.md refined against canonical JD:
  - Added Week 2 dedicated to GCP enterprise integration patterns
    (VPC-SC, IAP, PSC, Workload Identity Federation, Apigee, OAuth 2.0
    flows, Terraform, Vertex AI Search, Memory Bank) -- this was the
    single biggest gap in curriculum v1
  - Refined fde-reference-architecture project to use real GCP primitives
    and include a Terraform module
  - Re-weighted AI/ML round prep toward Google-specific stack
  - Added 7 key phrases from the JD that recruiters/HMs recognize
  - Reorganized STAR stories against the 6 capabilities
  - Added 3-week crash-plan path in case the loop lands fast

Also updated README.md index to route the reader through CHEATSHEET ->
CANONICAL_JD -> CURRICULUM in order."

git push origin main
echo ""
echo "done."
