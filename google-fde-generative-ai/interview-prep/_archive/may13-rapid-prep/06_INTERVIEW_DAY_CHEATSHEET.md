# Interview Day Cheatsheet - May 13

Read this on May 12 night and May 13 morning. Do not use it to cram.

## The Loop

- **RRK:** 60 minutes.
- **Coding:** 60 minutes.
- Virtual interviews.
- Coding is Python/OOP, 30-50 lines, no execution.

## Your 60-Second Opener

> I am a senior AI/ML engineer focused on production GenAI systems. At Gracenote, I run a LangGraph multi-agent workflow with stateful checkpointing and HITL interrupts, and I recently migrated a 10K request/day generation service from expensive Sonnet to cheaper Haiku using DSPy optimization and DeepEval gates, cutting p95 latency 50% and cost per request 3x. Before that, I spent two years embedded with J&J MedTech teams, turning undocumented approval heuristics into a production decision-support model that cleared legal, security, and CAB review inside their existing AWS footprint. The common thread is exactly what this FDE role asks for: enter a messy customer environment, build the connective tissue, evaluate it rigorously, and turn repeatable friction into reusable tools.

## FDE In One Sentence

> An FDE is an embedded builder who turns frontier AI into production reality inside a customer's actual environment.

## RRK Answer Framework

For any broad question:

1. Business goal.
2. Users and stakeholders.
3. Data and integration.
4. Architecture.
5. Security and privacy.
6. Evaluation and observability.
7. Latency and cost.
8. Rollout and rollback.
9. Reusable asset or product feedback.

Opening line:

> Let me first clarify the workflow, data boundary, success metric, and unacceptable failure modes. Then I will propose an MVP and harden it for production.

## Architecture Skeleton

Use this for RAG, agents, support bots, claims workflows, internal assistants:

- Entry point: web app, chat, API, internal workflow.
- Auth: SSO/OAuth/IAM, user identity propagation.
- Orchestrator: deterministic workflow first, agentic autonomy where needed.
- Data: connectors, ACLs, metadata, freshness.
- Retrieval: chunking, embeddings, vector/hybrid search, reranking.
- Model: tiered Gemini/model routing.
- Tools: MCP/function calls, typed schemas, least privilege.
- Safety: validators, policy checks, prompt-injection defenses.
- Human review: required for high-risk writes.
- Observability: traces, logs, metrics, cost, prompt/model/tool versions.
- Evals: golden set, regression, LLM-as-judge with human calibration.
- Rollout: pilot, shadow, canary, rollback.

## Google Cloud Vocabulary

Use names sparingly and correctly:

- **Vertex AI:** managed ML/GenAI platform.
- **Gemini:** model family.
- **ADK:** code-first agent development kit.
- **Agent Engine:** managed runtime for deploying/scaling/observing agents.
- **RAG Engine:** managed RAG workflows/connectors.
- **Vector Search:** scalable vector retrieval.
- **BigQuery:** structured data and analytics grounding.
- **Cloud Run:** simple containerized service deployment.
- **GKE:** complex Kubernetes workloads.
- **IAP:** identity-aware access to apps.
- **VPC-SC:** service perimeter/data exfiltration control.
- **Private Service Connect:** private access to managed services/APIs.
- **Apigee:** API management, auth, quota, policy, analytics.
- **Cloud Logging/Monitoring/Trace:** production visibility.

## MCP vs A2A

> MCP connects agents to tools and data. A2A connects agents to other agents. ADK builds the agent. Agent Engine runs it in production.

## RAG vs Fine-Tuning

Use RAG when:

- Facts change.
- Access control matters.
- You need citations.
- Knowledge lives in documents/databases.

Use fine-tuning when:

- Behavior/style/format must improve.
- Task is stable.
- You have high-quality examples.
- Smaller/faster model economics matter.

Best answer:

> I would start with RAG and evals if the problem is knowledge access. I would fine-tune only if the failure is behavior, format, or domain representation after retrieval is solid.

## Agent Safety

Say:

- Tools are least privilege.
- Tool schemas are typed.
- Retrieved content is untrusted.
- Documents cannot grant permissions.
- Human approval for risky writes.
- Trace every model and tool call.
- Use step/time limits to prevent loops.
- Regression-test known bad trajectories.

## Eval Metrics

For RAG:

- Retrieval recall.
- Faithfulness.
- Citation correctness.
- Answer usefulness.
- Freshness.

For agents:

- Task success.
- Tool success/failure.
- Wrong-action rate.
- Escalation correctness.
- Safety violation rate.
- p95 latency.
- Cost per successful task.

For rollout:

- Golden set pass rate.
- Canary quality.
- Human override rate.
- Incident count.
- User adoption.

## Cost And Latency Playbook

1. Measure baseline.
2. Segment request types.
3. Trim prompt/context.
4. Tune retrieval top-k.
5. Cache safe repeated work.
6. Route easy tasks to cheaper/faster model.
7. Parallelize independent tools.
8. Use eval gate and canary before migration.

Your proof:

> Sonnet to Haiku, DSPy optimization, DeepEval gate, 50% p95 latency reduction, 3x cost reduction.

## Troubleshooting Slow System

Layer it:

- User/device/browser/geography.
- Recent deploy or traffic spike.
- Frontend assets and third-party scripts.
- CDN/cache.
- Network.
- API latency.
- Database/cache.
- Model/tool calls if GenAI path.

Say:

> I would first separate user-perceived latency from backend latency, then trace one slow request end to end.

## Coding Protocol

1. Restate problem.
2. Ask constraints.
3. State brute force.
4. State optimized approach and invariant.
5. Code cleanly.
6. Dry-run normal and edge case.
7. State complexity and tests.

Opening:

> Let me restate the problem and clarify input size, edge cases, and expected output.

If stuck:

> Let me step back and identify the invariant.

If still stuck:

> I will write the brute force first to make correctness concrete, then optimize from there.

## Coding Patterns

- Contiguous substring/subarray: sliding window.
- Sorted pair/triplet: two pointers.
- Fast lookup/grouping: hash map/set.
- Monotonic condition: binary search.
- Grid/components: DFS/BFS.
- Dependencies: topological sort.
- Top K: heap.
- Generate combinations: backtracking.
- Min/max ways: DP.
- Recent history class: dict plus queue/list.

## Hot Stories

Keep these three ready:

1. **J&J approval heuristics:** ambiguity, customer discovery, regulated rollout.
2. **Haiku migration:** eval discipline, latency/cost, production GenAI.
3. **AutoResearch/MCP:** field friction to reusable tool, FDE product feedback loop.

Backup stories:

- Data Sentry for ownership/security/OAuth.
- Gracenote ingestion for troubleshooting.
- Hard-gate disagreement for stakeholder conflict.
- Overclean metric for failure.

## Questions To Ask Interviewers

Pick one or two:

- "For this FDE team, what are the most common blockers between prototype and production?"
- "How much of the role is embedded customer delivery versus building reusable assets for the broader Google Cloud field?"
- "What does success look like for the first 6 months?"
- "How does the FDE team feed product gaps back into ADK, Agent Engine, or the broader Vertex AI roadmap?"

## Compensation If It Comes Up

Do not negotiate deeply before offer. Say:

> I would like to understand the level and ladder this role maps to before anchoring on a number. I am looking at total compensation in line with Google India L4/L5 market data, and I am flexible on base, stock, and bonus split depending on level.

If pressed:

> My current fixed is INR 33L with no stock. For Google, I would anchor on market and level rather than current comp.

## Do Not Say

- "I only know AWS."
- "I am rusty."
- "I use AI agents so coding may be hard."
- "I would just use RAG."
- "The model should decide."
- "We can add security later."
- "I do not know the exact product."

Say instead:

- "My production experience maps cleanly to Google Cloud primitives."
- "I have been practicing the no-run coding format."
- "The system is more than the model: data, tools, evals, security, rollout."
- "For risky actions, I would keep a human approval step initially."
- "I know the pattern; I would validate the exact product mechanics in docs or with a specialist."

## Morning Checklist

- Camera, mic, internet.
- Interview links.
- Water.
- Notebook and pen.
- Blank coding doc.
- Resume open locally.
- This cheatsheet read once.
- No new material.

## Final Sentence

> I build production GenAI by starting from the customer workflow, not the model, and I make it real through integration, evaluation, security, and rollout discipline.
