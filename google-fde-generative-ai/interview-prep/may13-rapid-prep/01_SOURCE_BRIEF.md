# Source Brief - Google FDE GenAI May 13 Loop

This is the factual base for the May 2-May 13 prep pack. Treat it as the source of truth when other notes conflict.

## What The Recruiter Material Says

The role is **Forward Deployed Engineer, GenAI, Google Cloud** in India, with locations listed across Bengaluru, Mumbai, and Gurugram.

The shortlisting email says:

- Your profile has been shortlisted for the FDE GenAI role.
- Interviews start May 6 and happen every Wednesday and Thursday.
- They asked for availability for **two rounds**.
- Priyanka Biswas is now the primary recruiting contact.

The recruiter prep PDF says the process is:

- **Initial call:** role and experience.
- **Interview preparation:** review the guide and ask recruiter questions before interviews.
- **Interviews:** **2 virtual interviews**.
- **Role Related Knowledge (RRK): 60 minutes**.
- **Coding: 60 minutes**.
- **Final review:** independent calibrated management review.

That means the plan should optimize for two high-quality rounds, not a long generic Google loop.

## Official PDF Interview Scope

### RRK

The RRK interview moves from high-level discovery to deep-dive architecture. Be ready to discuss:

- AI/ML engineering: how models become functional systems.
- Operational excellence: reliability, resilience, performance.
- Security, privacy, and compliance: especially sensitive customer or internal data.
- Scalability: 10,000 internal users to millions of external users.
- Performance and cost optimization.
- GenAI concepts: LLM training, serving, troubleshooting, NLP, hands-on GenAI models.
- Application development: design, build, test, deploy, and explain a demo's value to a customer.
- Consulting: uncover stakeholder needs through conversations and make recommendations.
- Cloud technology: not strictly GCP-specific, but know relevant GCP products and Google Cloud value proposition.
- Troubleshooting: structured diagnosis for distributed systems, network, and web scenarios.
- System design: clarify broad asks, gather constraints, propose tradeoffs, discuss robustness and limitations.

Sample troubleshooting prompt from the PDF:

> Your marketing manager complains that the new company website is slow. What would you do?

### Coding

The coding round is LeetCode/HackerRank style and includes object-oriented programming.

Operational details:

- Virtual interview platform with formatting and syntax highlighting.
- You will **not** run or deploy code.
- Expected code size: **30-50 lines of Python**.
- Ask clarifying questions and devise requirements.
- Explain the algorithm before or while coding.
- Prefer real code over pseudocode unless explicitly asked.
- Start with a working solution, then refine.
- Cover edge cases, tests, bugs, and optimization.

This is why the coding pack is pattern-first and small. The goal is fluency under no-run conditions, not 50 hard problems.

## High-Bar Role Target

Public Google Careers FDE IV GenAI postings describe the highest realistic bar:

- 8 years shipping production-grade AI-driven solutions.
- Python.
- Architecting AI systems on cloud platforms.
- Leading technical discovery with C-suite and engineering stakeholders.
- Building full-stack solutions that interface with enterprise systems.
- Secure agentic workflows with MCP, tool calling, and OAuth.
- Multi-agent frameworks such as LangGraph, CrewAI, or Google's ADK.
- LLM-native metrics such as tokens/sec, cost per request, state management, and granular tracing.
- Production-grade workflows that drive measurable ROI.
- Product feedback loop from field friction to reusable modules or feature requests.

The target persona is not "algorithm grinder." It is:

> Senior embedded AI builder who can discover a messy customer problem, design and code a production GenAI system, secure and operate it, prove ROI, and feed repeatable lessons back to product.

## What To Assume About Level

Prepare for **L5/FDE IV style expectations** even if the offer maps lower.

Reason:

- The India invitation has minimum qualifications around 3 years in Python and applied AI, but adjacent official FDE IV postings use 8 years and senior customer-discovery language.
- The recruiter described mid-level targeting, but level can depend on interview performance.
- Your resume has senior signals: production LangGraph, DSPy/DeepEval migration, EmbeddingGemma fine-tuning, J&J embedded customer delivery, MCP servers, and IIT Madras M.Tech.

In the interview, sound like a senior IC without over-claiming years:

- Lead with judgment, not authority.
- Explain tradeoffs and rollout plans.
- Ask business and risk questions before architecture.
- Bring everything back to measurable customer impact.

## Compensation And Negotiation Notes

Recruiter signal: base may cap around **INR 40L**. Treat that as a base-salary signal, not total compensation.

Public compensation signals:

- Levels.fyi Google India SWE median total compensation: L4 around **INR 72L**, L5 around **INR 1.2Cr**.
- Levels.fyi L5 average components: base around **INR 63.7L**, stock around **INR 50.4L/year**, bonus around **INR 6.5L**.
- AmbitionBox customer-facing Google technical roles appear lower than SWE levels but still materially above your current fixed salary.

Negotiation principle:

- Ask for the **level and ladder** first: SWE-like IC, Customer Engineer, Specialist, or Google Cloud technical IC.
- Separate base from total comp.
- Do not anchor on current INR 33L fixed.
- Use "market and level" language: "I would like to understand whether this is scoped as L4 or L5 before naming a number."

Working target:

- L4: INR 70L-85L annualized TC.
- L5: INR 1.1Cr-1.3Cr annualized TC.
- Strong L5 with competing leverage: INR 1.3Cr+ first-year TC.

## Your Strongest Evidence

Use these repeatedly across RRK and behavioral answers:

- **Gracenote LangGraph:** production multi-agent workflow, stateful checkpointing, HITL interrupts, editorial no-touch approval from 30% to 40%.
- **Claude Sonnet to Haiku migration:** DSPy MIPROv2/GEPA/rule mining, DeepEval canary, p95 latency down 50%, cost per request down 3x.
- **EmbeddingGemma:** hard-negative mining, Matryoshka, temporal holdout, +12 points accuracy@1 and accuracy@5.
- **J&J MedTech:** embedded customer discovery, undocumented approval heuristics, legal/security/CAB signoff, AUROC 0.95, no new infra.
- **Data Sentry:** multi-cloud IAM automation, Microsoft Graph OAuth, days to minutes.
- **MCP servers and AutoResearch:** field friction became reusable tools, exactly matching the FDE feedback-loop requirement.

## What To Ignore

Until May 13, do not spend serious time on:

- 50 hard LeetCode problems.
- Building a new public project from scratch.
- Deep distributed training theory beyond what you can defend from your resume.
- Memorizing every GCP product.
- Long compensation rabbit holes before interviews.

The interview signal is concentrated in RRK depth, no-run Python fluency, and customer-facing judgment.

## Source Links

- Google Careers FDE IV GenAI: https://careers.google.com/jobs/results/122489539678610118-forward-deployed-engineer-iii/
- Vertex AI Agent Builder overview: https://docs.cloud.google.com/agent-builder/overview
- Vertex AI Agent Engine overview: https://docs.cloud.google.com/agent-builder/agent-engine/overview
- Vertex AI RAG and Vector Search docs: https://docs.cloud.google.com/vertex-ai/docs
- Levels.fyi Google India SWE: https://www.levels.fyi/companies/google/salaries/software-engineer/locations/india
- Levels.fyi Google India L5 SWE: https://www.levels.fyi/companies/google/salaries/software-engineer/levels/l5/locations/india
