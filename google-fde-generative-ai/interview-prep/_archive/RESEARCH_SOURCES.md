# Research Sources — Google FDE GenAI Interview Prep

Compiled 27 April 2026. Used as the evidence base for `CURRICULUM.md`.

## Primary sources (Google FDE specific)

| Source | Key takeaway |
|---|---|
| [Ajay Kumar — "I Interviewed for Google's Forward Deployed Engineer Role"](https://medium.com/@trivajay259/i-interviewed-for-googles-forward-deployed-engineer-role-and-it-was-one-of-the-most-intense-12f2e676e91c) | **3 interview rounds + 1 initial technical recruiter screen.** Round 1 = AI/ML. Round 2 = DSA. Round 3 = Googleyness. |
| [FDE Academy — Interview Questions Guide (2026)](https://fde.academy/blog/forward-deployed-engineer-interview-questions) | **3–4 rounds typical**: technical + system design round, deployment scenario round, client simulation round, behavioral round. AI startups add a 5th AI-systems round. "FDE interviews are not grading your answer; they're watching how you think through a problem you've never seen before." |
| [Sundeep Teki — FDE AI Engineer Career Guide (2025)](https://www.sundeepteki.org/advice/forward-deployed-ai-engineer) | **5 interview dimensions**: (1) Technical Conceptual, (2) System Design, (3) Customer Scenarios, (4) Live Coding, (5) Behavioral. Evaluation weight: Customer Obsession 30%, Technical Versatility 25%, Communication 25%, Autonomy & Judgment 20%. |
| [First Round Review — So You Want to Hire an FDE](https://review.firstround.com/so-you-want-to-hire-a-forward-deployed-engineer/) | Palantir-style FDE interview: "Here's a customer problem, no one has ever solved it, how would you solve it?" Tests both business and technical reasoning. |
| [Hashnode — 2026 FDE Guide](https://hashnode.com/blog/a-complete-2026-guide-to-the-forward-deployed-engineer) | "Forward deployed" = military term; on the front lines, in the customer's world. FDE is NOT sales/consultant/support — hands-on-keyboard builder. Writes/debugs/ships code, pipelines, systems. |

## Google Cloud platform (know these cold)

| Source | Key takeaway |
|---|---|
| [Google Cloud — Vertex AI Agent Engine (Apr 2025)](https://cloud.google.com/blog/products/ai-machine-learning/build-and-manage-multi-system-agents-with-vertex-ai) | **Agent Engine = managed runtime for agents**. Handles context, infrastructure, scaling, security, evaluation, monitoring. Integrates with ADK. Supports MCP. Deterministic guardrails + orchestration controls. |
| [Google Developers Blog — ADK launch (Apr 2025)](https://developers.googleblog.com/en/agent-development-kit-easy-to-build-multi-agent-applications/) | **ADK = Agent Development Kit.** Open-source Python framework for multi-agent systems. Works with 200+ models (Gemini + Claude/Anthropic/Meta/Mistral/etc). Deploys to Cloud Run, Kubernetes, or Vertex AI Agent Engine. |
| [UI Bakery — Vertex AI Agent Builder 2026 Guide](https://uibakery.io/blog/vertex-ai-agent-builder) | Rebranded to **Gemini Enterprise Agent Platform** at Cloud Next 2026. Bundles ADK + Agent Studio (low-code) + Agent Engine (runtime) + Memory Bank + governance. |
| [MLOps Community — Deploying AI Agents with ADK (Nov 2025)](https://mlops.community/deploying-ai-agents-in-the-enterprise-without-losing-your-humanity-using-adk-and-google-cloud) | Real-world patterns for deploying ADK agents on Cloud Run + IAP, Vertex AI Agent Engine, and AgentSpace. |
| [Brandon Lincoln Hendricks — Building Production AI Agents w/ Gemini + ADK](https://brandonlincolnhendricks.com/research/building-production-ai-agents-gemini-adk-google-cloud) | Google showcased lessons from 70+ agent deployments at Cloud Next 2026. MCP emerging as tool-integration standard. |
| [Leanware — Vertex AI Agent Guide](https://www.leanware.co/insights/vertex-ai-agent) | **A2A protocol** (Agent-to-Agent) enables cross-framework communication. MCP for data connection. Memory Bank for long-term memory. |
| [Codecademy — ADK Visual Agent Builder](https://www.codecademy.com/article/google-adk-visual-agent-builder-build-your-first-ai-agent) | ADK 1.18.0 (Nov 2025) added Visual Agent Builder (browser IDE). YAML export; git + CI/CD. |

## Key papers (read these; 3–5 cited in resume)

| Paper | ID | Why it matters |
|---|---|---|
| **GEPA: Reflective Prompt Evolution Can Outperform RL** | [arXiv 2507.19457](https://arxiv.org/abs/2507.19457) | Agrawal et al. 2025 (Stanford + UC Berkeley incl. Matei Zaharia & Omar Khattab). GEPA uses natural-language reflection + Pareto-guided search; outperforms MIPROv2 by >10% and GRPO with 35x fewer rollouts. **You use this in your resume — know it deeply.** |
| **DSPy Declarative Learning — Use Cases** | [arXiv 2507.03620](https://arxiv.org/abs/2507.03620) | Practical DSPy results across 5 use cases (guardrails, hallucination, code gen, routing, eval). Read for real-world DSPy positioning. |
| **VISTA: Multi-Agent Decomposition of GEPA** | [arXiv 2603.18388](https://arxiv.org/abs/2603.18388) | Critical of GEPA black-box nature. Good to have awareness of limitations. |
| **Automated Risk-of-Bias w/ GEPA** | [arXiv 2512.01452](https://arxiv.org/abs/2512.01452) | Real applied GEPA example in medical domain (nice for your clinical-ML angle). |
| **Small LLMs Are Weak Tool Learners: Multi-LLM Agent** | [arXiv 2401.07324](https://arxiv.org/abs/2401.07324) | Planner/caller/summarizer decomposition — directly relevant to hierarchical delegation in the JD. |
| **Context Engineering for Multi-Agent Code Assistants** | [arXiv 2508.08322](https://arxiv.org/abs/2508.08322) | Multi-agent practical lessons: intent translator + retrieval + synthesis + Claude sub-agent orchestration. |
| **Thucy — Multi-Agent Claim Verification on DBs** | [arXiv 2512.03278](https://arxiv.org/abs/2512.03278) | Cross-DB multi-agent system; useful mental model for customer-data-silo problems. |

## Canonical non-Google FDE accounts (read for flavor)

- [ElevenLabs FDE Interview Experience](https://www.tryexponent.com/experiences/eleven-labs-solutions-architect-interview-ce0689) — recruiter screen + timed coding + live coding in Google Doc + customer case study + founder round
- [Startup.jobs FDE question bank](https://startup.jobs/interview-questions/forward-deployed-engineer) — representative FDE scenario questions
- [Adaface — 98 FDE questions](https://www.adaface.com/blog/forward-deployed-engineer-interview-questions/)

## Google interview process baselines (general SWE, for Round 2 DSA flavor)

- [Interview Query — Google SWE Guide 2025](https://www.interviewquery.com/interview-guides/google-software-engineer)
- [IGotAnOffer — Google SWE Interview](https://igotanoffer.com/blogs/tech/google-software-engineer-interview)
- [4dayweek.io — Google SWE Interview Guide](https://4dayweek.io/interview-process/google-software-engineer)

## Why these map to this specific req

From Harish's email, three explicit must-haves, all reflected above:
1. **"Multi-agent systems using ReAct patterns and hierarchical delegation"** → ADK + Agent Engine + A2A protocol + Small-LLM-Tool-Learners paper
2. **"LLM-native metrics (tokens/sec, cost-per-request, granular tracing)"** → Vertex AI Agent Engine observability + DeepEval + Gemini Enterprise monitoring
3. **"Connections between Google's AI products and live customer infrastructure (APIs, OAuth-based authentication)"** → Vertex AI Agent Builder integration patterns + MCP + OAuth 2.0 flows on GCP
