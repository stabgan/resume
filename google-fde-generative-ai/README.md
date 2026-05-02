# Google FDE GenAI Tailored Resume

Tailored resume for the **Forward Deployed Engineer, Generative AI, Google Cloud** role (Bangalore / Gurgaon / Mumbai).

**Files:**

- `resume_google_fde.tex` — LaTeX source
- `resume_google_fde.pdf` — 3-page compiled PDF

## Role Context


| Attribute | Value                                                                                                                                                 |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Title     | Forward Deployed Engineer, Generative AI, Google Cloud                                                                                                |
| Locations | Gurgaon, Bengaluru, Mumbai                                                                                                                            |
| Contact   | Harish Gumpini, Randstad Sourceright (Google)                                                                                                         |
| JD        | 8+ yrs prod-grade AI, L400 Python, multi-agent (LangGraph/CrewAI/ADK), ReAct/self-reflection/hierarchical delegation, MCP + OAuth, LLM-native metrics |


## Build

```bash
tectonic resume_google_fde.tex
mdls -name kMDItemNumberOfPages resume_google_fde.pdf  # verify 3 pages
```

## Tailoring Methodology

Two iterative review rounds with 10 parallel specialist review agents per round, feedback synthesized between rounds.

### Review Perspectives (10 agents per round)

1. ATS parsing & JD keyword density
2. Google FDE hiring manager lens
3. Technical depth & credibility
4. Visual design & typography (eye-tracking)
5. Content brevity, clarity, redundancy
6. Quantified metrics strength
7. Customer-embedded narrative strength
8. Cognitive bias optimization
9. Interview conversation seeding
10. Competitor differentiation / positioning

### Scores Across Rounds


| Dimension                  | Round 1 | Round 2 | Source                                                                   |
| -------------------------- | ------- | ------- | ------------------------------------------------------------------------ |
| ATS keyword match          | 6/10    | 8.5/10  | Forward-Deployed in tagline, Gemini/Vertex in top third, bulleted skills |
| HM phone-screen confidence | 7/10    | 8.5/10  | Embedded-builder narrative, customer-perimeter language                  |
| Technical credibility      | 6.5/10  | 7.5/10  | Fixed TranslateGemma→Gemma 3, softened 100%→≥95%/N=500, 100x→~30x        |
| Visual hierarchy           | 7/10    | 8/10    | Thicker rules, black!40 footer, bulleted skills                          |
| Metrics calibration        | 6/10    | 7.5/10  | Softened round numbers, added N & baselines                              |
| Customer narrative         | 5.5/10  | 7/10    | Director/legal/CAB altitude, "zero net-new infra" positioning            |
| Cognitive bias             | 6.5/10  | 8.5/10  | Removed negative anchors (AIR 4,860, stale certs, vanity metrics)        |
| Interview seeding          | 7.5/10  | 8.5/10  | Neutralized dangerous seeds, added methodology qualifiers                |
| Differentiation            | 5/10    | 7.5/10  | MCP + Gemma-3 HF front-loaded, "Familiar with" hedges gone               |
| Editorial brevity          | —       | Applied | Summary 125→95 words, duplicate bullets removed                          |


## Key Tailoring Decisions

### Headline & Summary

- **Tagline:** "Senior AI/ML Engineer | Forward-Deployed GenAI, Multi-Agent Systems & MCP on Google Cloud" — keyword-match on role title, GCP, multi-agent, MCP.
- **Summary opener:** "Customer-embedded AI engineer, 5+ yrs shipping production GenAI (Python, primary) inside live enterprise environments." — primacy, FDE schema match in <6 sec.

### Factual / Technical Hardening (Round 2)

- `TranslateGemma 4B` → `Gemma 3 4B` (factual error; Google never released TranslateGemma)
- `ICD-CM-10` → `ICD-10-CM` (correct medical coding order)
- `100% pass rate` → `≥95% acceptance on N=500 spot-checks`
- `100x cost reduction` → `~30x token spend per trial, 3x more trials at same budget` (honest math)
- `cost-per-request -3x` → `cost-per-request cut 3x` (grammar: negative-times is nonsense)
- `DSPy InferRules-style` → `custom DSPy module over BootstrapFewShot` (real primitive names)
- `GIST-style` → `greedy diversity selection` (explained, not acronym-dropped)
- `supervisor-plus-specialist ... hierarchical delegation` → `supervisor/specialist ... stateful checkpointing, HITL interrupts` (specific LangGraph primitives, not redundant)
- `AUROC 0.95` now qualified with `temporal holdout, leakage-audited` — neutralizes the top interview backfire risk.

### Customer-Embedded FDE Narrative

- J&J role subtitle: `Data Architect & Data Scientist (Embedded AI/ML Delivery)`
- J&J discovery bullet: raised altitude to Director + legal/security/change-advisory inside regulated medical-device business
- J&J deployment bullet: "white-glove deployment inside customer perimeter" + "zero net-new infra, zero new vendor paperwork" — textbook FDE signal
- Data Sentry: "connective tissue across a regulated customer's live identity infrastructure"
- MCP servers: reframed from hobby-OSS to production patterns (removed self-narrating "the field→product loop Google FDEs run" line in round 2)

### Cognitive Bias Fixes

- Removed negative anchors: GATE DA AIR 4,860, stale MIT 2019 / Azure AI-900 2021 certs, h-index:4, per-paper citation counts (kept only lead paper's 22), vanity metrics (43 followers, 19 stars, 6 stars)
- Removed Param.ai 2018 intern entry (loss-aversion signal)
- Retired WBJEE 2016 #3450 and PNTSE undergrad anchors
- Reordered contact links: Scholar → GitHub → npm → HF → LinkedIn → site (descending authority)
- Footer page numbers recessed to `black!40`

### Visual Refinements

- Section rules thickened to 1.2pt (Bravo & Nakayama 1992 pop-out threshold)
- `\needspace` guards prevent orphan section headings (Education: 11 baselines; J&J COE: 6)
- Skills converted from wall-of-text prose to true bulleted categories
- Publications and Open Source converted to discrete `\item` entries (ATS-friendly parse)

## Research Sources

Same foundation as the root `README.md`:

- Labrecque & Milne (2012), *J. Marketing* — blue = competence + trust
- Nielsen (2006), NN/g — F-pattern
- Pernice (2017), NN/g — bold-density threshold
- Bravo & Nakayama (1992) — pop-out ≥3:1 contrast
- TheLadders (2018) — 7.4 s recruiter scan
- Sundeep Teki — FDE role taxonomy (Palantir → OpenAI / Anthropic lineage)

## Round 2 Outputs Still Open

Intentionally left for the candidate to judge or for interview prep rather than hard-coded:

- Dollar-denominated impact (reviewers asked for $ savings on Haiku migration; left as task-quality + latency + cost-ratio since the candidate has the ratio, not necessarily the absolute)
- Round-number cluster softening (30%→40%, 50%, 3x) — requires real measured values from the candidate
- "Selected Impact" 3-bullet strip between summary and Experience (would add vertical space, risks breaking 3-page budget)

## Page-count discipline

Strict 3-page limit maintained. Each revision verified with `mdls -name kMDItemNumberOfPages`.