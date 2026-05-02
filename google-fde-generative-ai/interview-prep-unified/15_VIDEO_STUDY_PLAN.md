# 15 — Video Study Plan (DeepLearning.AI Pro + YouTube)

## Why this file exists

You have an active **DeepLearning.AI Pro** subscription that you're barely using. 6 courses started, none past 2% completion. I inspected your logged-in catalog and cross-referenced every course against the FDE JD: ADK, Agent Engine, MCP, A2A, Vertex AI, RAG Engine, OAuth, eval discipline, cost optimization, agentic workflows.

Most of it is gold you already paid for. This file picks the 8 highest-leverage courses for May 13, schedules them into your existing 11-day plan, and adds YouTube supplements from Stanford / MIT / Anthropic / Google DeepMind for concepts your DLAI catalog doesn't cover cleanly.

**Hard rule:** video is a supplement, not a substitute. Every hour you spend watching is an hour you're not rehearsing cases, drilling coding, or practicing stories. The plan below is 10-12 hours of video total, spread across the 11 days, with specific stopping points per session.

**What this file is NOT:** a binge guide. A completionist will watch every course and run out of time for rehearsal. You watch with a specific question in mind, take 5 lines of notes per session, tie it back to a case or a rapid-fire probe, and move on.

---

## How to use this file

1. For each course, I list: which lessons to watch (specific timestamps), what question you're answering, what to write down, and which existing prep artifact (case, probe, story) it reinforces.
2. Schedule: each course is slotted into an existing day in `00_EXECUTION_PLAN.md`. Do not add extra study time; this replaces lower-ROI reading.
3. Watch at 1.5x. DeepLearning.AI players support this. The code-example lessons can go to 1.25x when code is on screen.
4. Keep a running note: one line per lesson, "what surprised me" + "which case does this reinforce".

---

## Priority tier 1: MUST watch (5.5 hours total, spread May 3-9)

These 4 courses are non-negotiable. Every one of them directly closes a JD gap or sharpens an evidence-backed claim.

### 1. A2A: The Agent2Agent Protocol (Google Cloud + IBM Research) — 67 minutes

**URL:** `https://learn.deeplearning.ai/courses/a2a-the-agent2agent-protocol`

**Why:** You're being asked about A2A in an FDE round with near-certainty. This course is co-authored by Google Cloud, has **actual ADK labs**, and uses Claude on Vertex AI.

**Watch in this order:**
- Introduction (4m)
- A2A Architecture (6m)
- Building a QA Agent with Claude on Vertex AI (3m) — first real Vertex+ADK context
- Wrapping the QA Agent into an A2A Server (4m)
- Calling an A2A Agent using an A2A Client (3m)
- **Creating an A2A Health Research Agent using Google ADK (2m)** — highest priority
- **Creating an A2A Sequential Chain Agent with ADK (2m)** — highest priority
- Creating an A2A Healthcare Provider Agent using LangGraph and MCP (6m) — ties A2A to your LangGraph experience
- Advanced A2A Concepts: Extensions and Security (4m)

**Skip:** Microsoft Agent Framework, BeeAI Framework, Agent Stack (lessons 10-12). Not likely to come up for Google FDE.

**Slot into:** May 5 (Mon) — same day as the Multi-Agent Claims case. Swaps the 75-min evening block you'd have spent re-reading the case.

**Question to answer while watching:** "If Priya asks me to describe an A2A architecture for a customer, can I sketch one from memory, including agent cards and the ADK + Vertex integration?"

**Write down 5 lines:**
- How A2A differs from MCP in one sentence.
- The JSON shape of an agent card.
- What ADK's `LlmAgent` wraps.
- The specific security knob A2A exposes that MCP doesn't.
- One question to ask Priya about A2A roadmap.

**Reinforces:**
- Case `cases/03_multi_agent_claims.md` (multi-agent architecture)
- Case `cases/04_mcp_oauth_tool_integration.md` (tool + agent separation)
- Probe Q2.3 in `12_RAPID_FIRE_QA.md` (MCP vs A2A vs tool-calling)
- Story 5 (AutoResearch / MCP flagship) — ties MCP server pattern to A2A

---

### 2. Multi AI Agent Systems with crewAI (crewAI + Joao Moura) — 2h41m

**URL:** `https://learn.deeplearning.ai/courses/multi-ai-agent-systems-with-crewai`

**Why:** You currently cannot answer "what is CrewAI?" confidently. This course gives you the mental model: roles, tasks, crews, delegation. After this you can truthfully say "I built a CrewAI prototype last week," reference your `crewai-vs-langgraph-comparison` repo from `11_BUILD_PLAN.md`, and move on.

**Watch in this order (cherry-pick, don't complete):**
- AI Agents (8m) — mental model
- Key elements of AI agents (11m) — role / goal / backstory / tools
- Multi-agent customer support automation (18m, with code) — the canonical example
- Mental framework for agent creation (3m) — how CrewAI thinks
- Key elements of agent tools (7m)
- Multi-agent collaboration (5m) — the delegation pattern
- Next steps with AI agent systems (5m)

**Skip:** Events planning, financial analysis, job application examples (lessons 7-11 specific code walkthroughs). 1 example of multi-agent is enough.

**Reduced time: 57 minutes, not 2h41m.**

**Slot into:** May 4 (Sun) — same day as Enterprise RAG case. Afternoon block, 60 min.

**Question to answer:** "If an interviewer pushes on 'why LangGraph over CrewAI', can I name 3 specific tradeoffs from hands-on experience, not just from a blog post?"

**Write down:**
- CrewAI's mental model in one sentence ("roles + tasks vs. graph + state").
- Which 2 CrewAI primitives map to LangGraph nodes vs. state.
- One concrete CrewAI limitation (no checkpointing by default, vs LangGraph's stateful checkpointer).
- One CrewAI strength over LangGraph (faster prototyping, less boilerplate for simple pipelines).
- One scenario where you'd pick CrewAI (fast customer demo of role-based delegation) vs LangGraph (production with HITL interrupts and state).

**Reinforces:**
- Probe Q2.2, Q2.8 in `12_RAPID_FIRE_QA.md` (ADK vs LangGraph, CrewAI vs ADK)
- Your `11_BUILD_PLAN.md` Project 2 (CrewAI-vs-LangGraph-comparison repo)
- Story 0 (why Google / why FDE) — lets you mention "I recently prototyped with CrewAI" without overclaiming

---

### 3. MCP: Build Rich-Context AI Apps with Anthropic (Anthropic) — ~1h20m

**URL:** `https://learn.deeplearning.ai/courses/mcp-build-rich-context-ai-apps-with-anthropic`

**Why:** You publish 2 npm MCP servers. You should be the person in the room who knows MCP cold. This course is taught by Anthropic, the protocol authors, and hardens your story that `@stabgan/openrouter-mcp-multimodal` (SSRF-safe) and `@stabgan/steelmind-mcp` are production-grade.

**Watch fully — 60 to 80 minutes.** This is the one course where you don't cherry-pick, because MCP is your signature.

**Slot into:** May 6 (Tue) — same day as MCP/OAuth case. Evening block.

**Question to answer:** "Can I answer 'walk me through the MCP server I published' without hesitation, including tool schema, transport (stdio vs SSE), error handling, and authorization?"

**Write down:**
- The 3 MCP primitives (tools, resources, prompts) and one use case for each.
- Transport options (stdio, SSE) and when you'd pick each.
- MCP's authorization model vs. A2A's.
- One specific thing your MCP server does that the Anthropic reference implementation doesn't (e.g., SSRF-safe URL handling).
- One specific weakness your MCP server has that you'd improve in a V2.

**Reinforces:**
- Story 5 (AutoResearch + MCP flagship)
- Case `cases/04_mcp_oauth_tool_integration.md`
- Probe Q2.3 (MCP vs A2A vs tool calling)
- Probe Q5.9 (prompt injection mitigations)

---

### 4. Evaluating AI Agents (Arize AI) — ~1h30m

**URL:** `https://learn.deeplearning.ai/courses/evaluating-ai-agents`

**Why:** This course systematizes what you did with DeepEval + DSPy on the Haiku migration. It gives you vocabulary (span, trace, evaluator, LLM-as-judge calibration, root cause analysis) that makes your eval-first story land harder in the room.

**Cherry-pick:** the first 60 minutes. Intro, evaluator types, trace analysis, LLM-as-judge, regression detection. Skip the Arize-specific tooling walkthrough unless you want to name Arize Phoenix in the round.

**Slot into:** May 7 (Wed) — same day as Eval Pipeline case. Evening block.

**Question to answer:** "When Priya asks 'how did you calibrate DeepEval against human labelers on Gracenote?', do I have a crisp 90-second answer?"

**Write down:**
- The taxonomy of agent failure modes (wrong plan, wrong tool, tool error, bad final answer).
- LLM-as-judge calibration protocol in 3 steps.
- The difference between unit evals, golden set, and online evals.
- One specific metric beyond accuracy that matters for agents (e.g., tool-call correctness rate, trajectory reward).
- One failure mode DeepEval can't catch that you'd handle with human review.

**Reinforces:**
- Story 6 (Sonnet → Haiku migration)
- Case `cases/05_eval_pipeline_agentic_support.md`
- Probes Q3.1, Q3.2, Q3.6, Q3.9 (eval layers, LLM-as-judge, LLM-native metrics, DeepEval)

---

## Priority tier 2: HIGH VALUE, watch if time (3 hours, May 8-10)

These are 20-30 min cherry-picks. Do 2-3 of them, skip the rest if Gracenote work is heavy.

### 5. Building Live Voice Agents with Google's ADK (Google) — ~1h

**URL:** `https://learn.deeplearning.ai/courses/building-live-voice-agents-with-googles-adk`

**Why:** Direct ADK hands-on, taught by Google. Voice is a narrow use case, but the ADK patterns (`LlmAgent`, `BaseAgent`, session state, tools) generalize. First 25 minutes on the ADK primitives is enough.

**Cherry-pick:** first ADK setup + primitives lesson, plus the multi-agent lesson. ~30 min.

**Slot into:** May 8 (Thu) afternoon. 30 min slot.

**Reinforces:** Your `adk-agent-hello-world` project in `11_BUILD_PLAN.md`.

---

### 6. DSPy: Build and Optimize Agentic Apps (Databricks) — ~1h30m

**URL:** `https://learn.deeplearning.ai/courses/dspy-build-optimize-agentic-apps`

**Why:** You've shipped DSPy with MIPROv2 + GEPA. This course adds **MLflow tracking** and **debugging workflow** vocabulary that strengthens the Haiku story.

**Cherry-pick:** first 40 min — DSPy primitives, MIPROv2 walkthrough, and one debugging case. Skip the full MLflow section.

**Slot into:** May 9 (Fri) morning, pre-mock. 40 min slot.

**Reinforces:** Story 6 (Sonnet → Haiku), probes Q3.7 and Q3.8 (DSPy vs prompt engineering, GEPA).

---

### 7. Understanding and Applying Text Embeddings (Google Cloud) — 1h24m

**URL:** `https://learn.deeplearning.ai/courses/google-cloud-vertex-ai`

**Why:** You already started this (0%). Google Cloud-authored. Covers Vertex AI text-embedding-gecko, semantic search, and Q&A. Directly supports your EmbeddingGemma fine-tune story and your RAG cases.

**Cherry-pick:** the first 3 lessons (Intro, Understanding Embeddings, Visualizing Embeddings). Skip the Q&A build-out if you're tight on time; it's redundant with your Gracenote work.

**Slot into:** May 4 (Sun) early morning, 45 min slot. Can replace part of re-reading `cases/02_enterprise_rag_bank.md`.

**Reinforces:**
- Your EmbeddingGemma +12 points story
- Case `cases/02_enterprise_rag_bank.md` (bank RAG with Matryoshka/4-directional)
- Probes Q1.2, Q1.3 (chunking, hybrid search)

---

### 8. Agent Memory: Building Memory-Aware Agents (Oracle) — ~1h25m

**URL:** `https://learn.deeplearning.ai/courses/agent-memory-building-memory-aware-agents`

**Why:** Agent memory is a real JD topic (Agent Engine has a Memory Bank feature). This course builds a memory manager end-to-end, which gives you the vocabulary to talk about extraction, consolidation, self-updating memory, and semantic tool memory.

**Cherry-pick:** Constructing the Memory Manager (22m) + Memory Aware Agent (20m). Skip the middle two lessons. **42 min.**

**Slot into:** May 10 (Sat) morning. 45 min slot.

**Reinforces:** Case `cases/09_production_agent_debugging.md`, probe Q2.6 (agent state/memory), the Gemini Agent Engine mention in `08_GCP_AND_FDE_VOCABULARY.md`.

---

## Priority tier 3: STRETCH — only if you're ahead of schedule

If May 10 you've done everything and want 30 more minutes of video, pick ONE:

- **Retrieval Augmented Generation (RAG)** (DeepLearning.AI) — if your RAG vocabulary feels shaky, watch the chunking + retrieval sections.
- **Advanced Retrieval for AI with Chroma** (Chroma) — query expansion, cross-encoder reranking, MMR. Sharpens `cases/02_enterprise_rag_bank.md` reranker argument.
- **Long-Term Agentic Memory With LangGraph** (LangChain) — if you expect LangGraph questions and want to strengthen Gracenote evidence.
- **Semantic Caching for AI Agents** (Redis) — 30 min total, directly maps to probe Q4.4 (caching safely).
- **Claude Code: A Highly Agentic Coding Assistant** (Anthropic) — 1h50m. Skip unless Priya explicitly asks about AI-assisted coding tools (possible given the JD emphasis on production engineering velocity).

**Do NOT watch:**
- Pretraining LLMs / Fine-tuning LLMs / Post-training LLMs / RL from HF — not FDE material, too deep.
- SGLang / JAX / LiteLLM — serving-infra details not likely in FDE round.
- TensorFlow / PyTorch specializations — you have the production chops.
- Generative AI for Everyone / AI Python for Beginners — below your level.
- NLP Specialization / Deep Learning Specialization — multi-week commitments. Not appropriate for an 11-day prep window.

---

## YouTube supplements (free, ~2-3 hours total)

DeepLearning.AI is practice-focused. YouTube is where you get the **conceptual depth** that lets you sound like a grad student when the interviewer probes theory. Watch these at 1.5x.

### 1. Andrej Karpathy — "Intro to Large Language Models" (1 hour)

Link: https://www.youtube.com/watch?v=zjkBMFhNj_g

Why: The single cleanest public explanation of what an LLM is doing mechanically. Covers tokenization, next-token prediction, fine-tuning, RLHF, system 1 vs system 2 thinking, tool use. If a bar raiser says "explain to me why the model hallucinates", this video gives you the 60-second answer from first principles.

Watch: fully, once. 1 hour.

Slot: May 2 (tonight) while cooking or on a walk. Not dedicated desk time.

Key takeaway to write down: one sentence on why RLHF improves instruction-following (it's an alignment mechanism, not a knowledge update).

### 2. Stanford CS25 — "Transformers United V4" (pick 1 lecture, ~1h)

Link: https://web.stanford.edu/class/cs25/ (syllabus) or search "Stanford CS25 2024" on YouTube

Why: Stanford's transformer seminar series. Each lecture is a guest talk by someone who actually built the thing. Pick ONE based on your weakest area:

- **Mixture of Experts** (if you expect cost/routing questions)
- **Agentic systems** (if you want more depth on planning/ReAct/Reflexion)
- **Multi-modal models** (if multimodal comes up)
- **Constitutional AI / Anthropic** (if Gemini vs Claude comparisons come up)

Watch: 1 lecture, 1 hour. Take 3 lines of notes.

Slot: May 3 (Sat) evening, after the Case 1 rehearsal.

### 3. 3Blue1Brown — "Attention in Transformers" (26 min)

Link: https://www.youtube.com/watch?v=eMlx5fFNoYc (part of his "But what is a GPT?" series)

Why: If a bar raiser says "explain attention in 2 minutes", this video's mental model — keys, queries, values as a soft dictionary — is the cleanest public explanation. Pairs well with the "Attention in Transformers" course on DeepLearning.AI (StatQuest, 1h6m) if you want to code it in PyTorch.

Watch: fully. 26 min.

Slot: May 5 (Mon) during breakfast.

### 4. MIT 6.S191 — Deep Learning Foundations (optional, 1-2 hours)

Link: http://introtodeeplearning.com/

Why: MIT's intro course. If your backprop / gradient / optimizer / attention mental models feel rusty, watch lectures 1 (intro) and 2 (RNN/attention) to refresh. You probably don't need this unless you expect a foundations question.

Skip unless: the interviewer's LinkedIn shows they're a research scientist, not an engineer.

### 5. Google DeepMind — Gemini 2.5 / Agent Engine demos on their YouTube

Links: https://www.youtube.com/@Google / https://www.youtube.com/@GoogleCloudTech

Why: 15-20 minute official demos of Agent Engine, Agent Builder, RAG Engine. Watching 1-2 of these gives you the **current Google vocabulary** (e.g., "Gemini Enterprise", "Agent Garden", "Memory Bank"). You don't need to watch all; pick the 2 most recent with "Agent Engine" or "Vertex AI RAG Engine" in the title.

Slot: May 11 (Sun) morning, 30 min. Part of the compression day.

### 6. Anthropic research interviews / talks (optional)

Link: https://www.youtube.com/@anthropic-ai

Why: If asked "what's the difference between Claude and Gemini from a customer perspective", having watched a recent Dario / Anthropic research talk gives you a grounded answer beyond marketing pages. Not essential.

Skip unless you have 20 min spare.

---

## The "do NOT watch" list

Save your time. These are tempting but low-ROI for May 13:

- **Andrew Ng's "Machine Learning Specialization"** — 60+ hours, foundations you already have.
- **Deep Learning Specialization** — same.
- **Full Stanford CS229 / CS231n courses** — multi-week ML foundations.
- **Andrej Karpathy's "Build GPT from scratch"** — excellent, but 4 hours. Save for after the interview.
- **DeepLearning.AI "AI Python for Beginners" / "Build with Andrew"** — beginner content.
- **Courses specifically about model training: "Pretraining LLMs", "Fine-tuning LLMs", "Post-training of LLMs", "Quantization in Depth", "Efficiently Serving LLMs"** — deep infra, not FDE scope.
- **Courses about specific non-Google frameworks ALONE: smolagents, Haystack, Pydantic-AI, DotTxt, Letta** — interesting but too narrow.
- **"AI for Medicine" / "MLOps Specialization" / "TensorFlow Developer"** — multi-week, not FDE-critical.

**Rule of thumb:** if a course is longer than 2 hours and doesn't have "Google", "ADK", "Vertex", "MCP", "A2A", "Eval", "RAG", or "DSPy" in the title, skip it.

---

## Updated 11-day schedule (layer on top of `00_EXECUTION_PLAN.md`)

| Date | Day focus (existing plan) | Video addition |
|---|---|---|
| May 2 (Fri) | Foundation + env setup | Karpathy "Intro to LLMs" (1h) on walk |
| May 3 (Sat) | RRK spine + Case 1 | Stanford CS25 pick (1h) |
| May 4 (Sun) | Enterprise RAG case | **CrewAI course (57m)** + Vertex embeddings first 3 lessons (45m) |
| May 5 (Mon) | Multi-Agent Claims case | **A2A course full (67m)** + 3Blue1Brown attention (26m) |
| May 6 (Tue) | MCP/OAuth case | **MCP Anthropic full (80m)** |
| May 7 (Wed) | Eval pipeline case | **Evaluating AI Agents (60m)** |
| May 8 (Thu) | Scale case | ADK voice agents first 2 lessons (30m) |
| May 9 (Fri) | Mock day 1 | DSPy course first 40m (pre-mock) |
| May 10 (Sat) | Repair weak spots | Agent Memory 2 lessons (42m) |
| May 11 (Sun) | Mock day 2 + compression | Google DeepMind Agent Engine demos (30m) |
| May 12 (Mon) | Taper | NO VIDEOS. Read 14 walkthroughs aloud only. |
| May 13 (Tue) | Interview | NO VIDEOS. |

**Total video hours:** ~10.5 hours spread across 11 days. Average ~1h/day. Replaceable with case re-reading when needed.

---

## Rehearsal tie-back protocol

After each video session, take 5 minutes to do ONE of these:

1. **Add a probe** to `12_RAPID_FIRE_QA.md` notes if the course surfaced a question you didn't have an answer for.
2. **Sharpen a case section** in `cases/` if the video gave you a better technical detail (e.g., a specific ADK primitive name, a specific eval metric).
3. **Update a story's follow-up answer** in `09_STORIES_AND_COMP.md` or `13_BEHAVIORAL_INDEX.md` if the video gave you a stronger technical tie-back.
4. **Write a 1-line question** you'd ask Priya at the end of the round, based on what the video surfaced.

If you can't do any of these 4 in 5 minutes, the video didn't teach you anything new — note that and skip the next optional course in the same track.

---

## One hard rule

**If by May 11 evening you've watched fewer than 5 of the Tier 1+2 courses but your rehearsal and mock scores are at 16/20 or better, DO NOT catch up on videos.** Rehearsal quality is uncapped in value; video is capped. Sleep and speak out loud.

Videos are the cheapest substitute for the real thing, which is rehearsing against a senior FDE. You can't do the real thing; watching Google's own A2A + ADK course is the closest approximation. But don't confuse watching with doing.

---

## Links (all PRO, all you already have access to)

Copy this block if you want to queue them up:

```
A2A                          https://learn.deeplearning.ai/courses/a2a-the-agent2agent-protocol
CrewAI                       https://learn.deeplearning.ai/courses/multi-ai-agent-systems-with-crewai
MCP (Anthropic)              https://learn.deeplearning.ai/courses/mcp-build-rich-context-ai-apps-with-anthropic
Evaluating AI Agents (Arize) https://learn.deeplearning.ai/courses/evaluating-ai-agents
ADK Voice (Google)           https://learn.deeplearning.ai/courses/building-live-voice-agents-with-googles-adk
DSPy (Databricks)            https://learn.deeplearning.ai/courses/dspy-build-optimize-agentic-apps
Vertex Embeddings            https://learn.deeplearning.ai/courses/google-cloud-vertex-ai
Agent Memory (Oracle)        https://learn.deeplearning.ai/courses/agent-memory-building-memory-aware-agents

Stretch (pick 1 if time):
RAG                          https://learn.deeplearning.ai/courses/retrieval-augmented-generation
Advanced Retrieval (Chroma)  https://learn.deeplearning.ai/courses/advanced-retrieval-for-ai
Long-term Memory LangGraph   https://learn.deeplearning.ai/courses/long-term-agentic-memory-with-langgraph
Semantic Caching (Redis)     https://learn.deeplearning.ai/courses/semantic-caching-for-ai-agents

YouTube:
Karpathy "Intro to LLMs"     https://www.youtube.com/watch?v=zjkBMFhNj_g
3Blue1Brown Attention        https://www.youtube.com/watch?v=eMlx5fFNoYc
Stanford CS25                https://web.stanford.edu/class/cs25/
Google Cloud Tech            https://www.youtube.com/@GoogleCloudTech
```
