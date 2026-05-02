# Evidence And Strategy

This file explains what the sprint is optimizing for.

## Primary Evidence

### Recruiter Email

- You are shortlisted for **Forward Deployed Engineer, GenAI**.
- Interviews start May 6 and are scheduled Wednesdays/Thursdays.
- Recruiter asked for availability for **two rounds**.
- Priyanka Biswas is the new process contact.

### Official Recruiter PDF

The PDF is the source of truth for the official loop:

- **RRK, 60 minutes**.
- **Coding, 60 minutes**.
- A shadow interviewer may join.
- Final calibrated management review.

RRK topics from the PDF:

- AI/ML engineering.
- Operational excellence.
- Security, privacy, compliance.
- Scalability from 10,000 internal users to millions external.
- Performance and cost optimization.
- GenAI concepts: LLMs, training, serving, troubleshooting, NLP, hands-on models.
- Application development: design, build, test, deploy, explain demo value.
- Consulting: uncover stakeholder needs and make recommendations.
- Cloud technology: not strictly GCP-specific, but know Google Cloud products and value proposition.
- Troubleshooting: distributed systems, network, web scenarios.
- System design: broad ask, constraints, simplicity, robustness, tradeoffs.

Coding topics from the PDF:

- LeetCode/HackerRank style.
- Object-oriented programming.
- Virtual platform with formatting/syntax highlighting.
- No running/deploying code.
- 30-50 lines of Python.
- Clarify, explain algorithm, code, optimize, test, find bugs.

## External Research Signals

### Blind / Customer Engineer RRK

Blind posts around Google Customer Engineer and AI RRK are thin but useful:

- One Google Customer Engineer AI RRK commenter said they passed RRK and were asked technical questions on **containers, building inference pipelines, and differences in required infrastructure**, with the interviewer expecting detail.
- Older Google RRK Blind advice for Customer Engineering says to expect questions specific to customer engineering, priorities, project management, databases, web technology, cloud migrations, and "how would a customer move from on-prem to cloud."

Implication:

- RRK can go below "GenAI architecture" into infrastructure: containers, serving, migration, network, data systems, and customer priorities.

### Google Cloud Customer Engineer Guides

PracticeInterviews and CleverPrep describe adjacent CE loops:

- RRK: technical + behavioral + hypothetical.
- GCA: structured problem solving.
- Googleyness/Leadership.
- Presentation: 7-slide technical solution, business + technical stakeholders.
- Questions include cloud migration, BigQuery vs Cloud SQL, GKE vs Cloud Run vs App Engine, security concerns, ML pipeline on Google Cloud, POC for skeptical enterprise customer.

Implication:

- Even if your official loop has only RRK + Coding, RRK can contain mini system design, consulting, customer objections, cloud architecture, and behavioral signals.

### FDE Guides / Interview Accounts

FDE-specific research emphasizes:

- Problem decomposition over memorized answers.
- Customer-specific architecture rather than abstract "design Twitter."
- Coding is often medium-level but contextualized in end-user/customer scenarios.
- Graphs/BFS, arrays/strings, hash tables, trees, and DP appear often.
- Behavioral is embedded throughout technical rounds.
- Rejection often comes from jumping to solution, missing user/customer constraints, weak ownership, or technical stories with no business impact.

Implication:

- Every technical answer must show customer context, not just engineering mechanics.

### Coding Strategy Research

Common public advice:

- Blind 75 is the minimal high-yield list for limited time.
- NeetCode 150 is better for structured pattern coverage if you can handle volume.
- Google coding requires medium/hard fluency in arrays/strings, hash maps, trees, graphs, DP, binary search, backtracking, heaps, intervals, and recursion.

For your 18-hour/day sprint:

- Do **not** choose between Blind 75 and NeetCode 150.
- Use a **tiered NeetCode-compatible plan**:
  - Must 60: pattern core, no excuses.
  - Should 40: depth and Google-style variants.
  - Stretch 50: NeetCode 150 completion / hard exposure.

## Strategic Conclusion

The earlier rapid pack underweighted:

- DSA volume.
- Data structures and algorithm fundamentals.
- Classic system design.
- ML system design.
- Containers/inference infrastructure.
- Google Cloud customer-engineering depth.
- Presentation-style solution defense.

The intensive pack fixes that.

## Preparation Priority

### Priority 1 - Coding Filter

If you fail coding, RRK excellence may not save you. You need enough no-run Python muscle memory to solve a medium reliably.

Target:

- Must 60 completed.
- 20-30 re-solves.
- At least 6 timed mocks.

### Priority 2 - RRK / System Design

This is where you can overperform into the higher bar.

Target:

- 10 RRK cases.
- 6 classic system designs.
- 6 ML/GenAI system designs.
- 3 presentation-style deep dives.

### Priority 3 - FDE/Behavioral

FDE answers must connect technical work to customer impact.

Target:

- 8 stories.
- 3 hot stories.
- Every story includes business pain, technical decision, production result, reusable lesson.

### Priority 4 - Compensation

Do not over-focus before offer, but know the anchor.

Current assumptions:

- Your fixed: INR 33L, no stock.
- Recruiter signal: base may cap near INR 40L.
- Public Google India SWE L4: around INR 70L-85L TC.
- Public Google India SWE L5: around INR 1.1Cr-1.3Cr TC.
- Ask level/ladder first, then negotiate total comp.

## Highest-Bar Persona

Walk in as:

> A senior embedded AI engineer who can code, decompose customer ambiguity, design production GenAI systems, secure them inside enterprise environments, measure quality/cost/latency, and convert field friction into reusable Google Cloud product feedback.

Everything in this folder is designed to make that persona automatic.
