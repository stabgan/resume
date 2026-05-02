# Case 10 — Customer C-Suite Discovery

Tags: Customer Discovery, Executive Framing, Portfolio Scoping, Politics, Business Value. Likelihood: VERY HIGH (the archetypal FDE situation).

## 1. The Prompt

"A C-suite stakeholder says 'We need GenAI across the business.' How do you run discovery?"

The most common FDE opening, and the most misread. It sounds technical. It is not. It tests whether I can turn vague executive ambition into a scoped, shippable program without breaking political dynamics, without overpromising and without pretending I already know the answer.

## 2. Customer Context

You are embedded with Keystone Industries, a diversified Indian conglomerate spanning manufacturing, logistics and consumer products. Roughly 12,000 employees, ₹8000Cr revenue, family-owned with a professional leadership layer. The Group CEO recently attended a Google executive event and returned inspired. His memo: "We are going all-in on GenAI. I have authorized a ₹10Cr Year 1 budget. I want results in 6 months."

Beneath that memo it is messier. The CIO is excited but anxious after a failed SAP consolidation and a data lake that produced no dashboard anyone used. The CFO is skeptical and wants a clean line from spend to P&L. The CHRO worries about job-impact optics in a workforce still recovering from restructuring. The four BU CEOs are silently competing for the budget: manufacturing wants predictive maintenance, consumer products wants a marketing agent, logistics wants route optimization. Everyone wants to be first.

My first meeting is Monday with nine people: CIO, CFO, CHRO, Chief Transformation Officer and four BU CEOs. One budget, zero agreement.

## 3. What's Actually Being Tested

Important to recognize: this is not a technical question. If I jump to "design a RAG" or "build an agent", I have already lost the round. The interviewer is checking:

- Can I separate business objective from AI wishlist?
- Can I say no to a CEO with love?
- Can I pick the right use case, not the flashiest?
- Can I handle political dynamics without becoming political myself?
- Do I have a framework, not just intuition?

Slow the conversation down, not up.

## 4. The Pre-Meeting Preparation

Before the meeting, I do the quiet work.

I read what Keystone publishes: annual report, strategy deck, investor updates, press releases from the last 18 months. Whatever the CEO has been saying externally is what the board scores him on internally. I look for recurring themes (margin pressure, export exposure, channel mix shifts, ESG commitments).

Then I get on the phone. Off the record with the CIO: what is the real pressure, where has IT been burned, which BU head actually returns his calls. Off the record with at least two BU CEOs: what keeps them up at night, what they would spend ₹2Cr on tomorrow. I sketch an org chart with dotted lines for actual influence.

At J&J MedTech, I did exactly this for two weeks before proposing architecture. I knew the approval workflow owners, program Director, legal team and CAB reviewers by name before writing a line of ML spec. That pattern is not optional. It is the job.

## 5. The Meeting — 90-Minute Structure

### Opening (5 min)

"Thank you for the time. Before I respond to the question of where we use GenAI, I would like to spend this session understanding Keystone's top business priorities. The best GenAI investment is often not the flashiest use case. It is the one that materially moves a metric the board is watching."

This signals I am not here to sell, and it quietly reframes the meeting from "pick AI use cases" to "pick business outcomes, then see if AI fits."

### Business Discovery (30 min)

Eight questions, asked not lectured:

1. Top three business outcomes Keystone must deliver in the next 12 months?
2. Which of those has a roadblock that is cost-driven, error-driven or capacity-driven?
3. If you fixed the biggest roadblock, what would you do with the freed capacity?
4. What is the unacceptable failure mode in each? What would get someone fired?
5. Who would own the solution after the pilot? Name a person.
6. What changed about the market that makes GenAI relevant now versus 12 months ago?
7. Past digital transformations: what went well, what went sideways, why?
8. Which BU has the cleanest data and the most urgent pain, honestly?

Question 4 is the one most FDEs skip. Everyone will tell you what success looks like. Very few will tell you what failure looks like. Without the unacceptable failure mode, I cannot design guardrails, cannot scope and cannot tell the CEO no when he asks for something that trips the wire.

### Portfolio Mapping (20 min)

I move to the whiteboard and draw a 2x2: Value (low/high) × Feasibility (low/high). Each stakeholder nominates their top two use cases; I place each on the matrix with the group, out loud.

This depersonalizes selection ("the matrix says this, not me") and forces BU CEOs to argue on value and feasibility, not seniority or volume. Top-right quadrant is where the pilot lives.

### Constraint Mapping (15 min)

- Data landscape. What is instrumented, what is in a warehouse, what is still in Excel.
- Regulatory. Industry-specific obligations, data residency, sectoral rules.
- Talent. What exists internally, what to rent, what to hire.
- Cultural. Curious or defensive adoption environment. Unions in the loop.
- Technical debt. Legacy systems to integrate with, and owners' patience for change.
- Budget allocation rules. Capex or opex, per-BU or central, cross-fiscal-year or not.

### Pilot Scoping (20 min)

"I propose starting with one pilot, not three. I would rather show one real result in 90 days than three vague attempts in 180."

Picking one pilot against a ₹10Cr budget sounds conservative. It is actually the only way to protect the CEO's story to the board. One shipped pilot with measurable outcome is a story. Three half-done pilots is a narrative problem.

The pilot must score Yes on all: highest business value quantifiable in ₹ or hours, data accessible (gold-tier or near it), owner with skin in the game, scopable to 90 days, failure recoverable without brand or legal damage, does not disrupt the whole org.

Before we leave the room: agreement on success criteria, timeline, named team, budget line and named sustain owner.

## 6. The Senior Moves

DO:

- Push back on "GenAI across the business". That is a marketing slogan, not a plan.
- Ask about unacceptable failure modes, not just success.
- Pick one pilot, not a portfolio.
- Name ownership clearly. Who owns this in month 6, with budget and headcount.
- Commit to 90 days with measurable outcome, not 12 months with sentiment.

DO NOT:

- Promise the CEO 10 use cases in Year 1.
- Let the politically loudest BU win the budget.
- Skip compliance and legal in the first meeting.
- Design the architecture in the meeting. No data yet.
- Commit to specific GCP products until discovery is done.
- Become "the AI person" permanently. Stay an advisor with a handoff date.

## 7. Typical Pilot Recommendations for Keystone

Likely winners:

**Manufacturing:** GenAI-assisted knowledge search for field technicians, layered on existing predictive maintenance signals. Measurable in uptime and cost per hour of downtime. Data in IoT logs and service reports. Owner is the plant manager who already answers for uptime. Failure recoverable because the technician remains the decision-maker.

**Consumer products:** Customer support augmentation, scoped to one brand, one channel, one language. Measurable in handle time and first-contact resolution. Owner is the CX head. Failure contained because the agent suggests, does not send.

**Internal:** HR self-service agent for policy Q&A. Low risk, high adoption, easy data, great vehicle for internal evangelism because every employee becomes a user.

Likely losers, even if politically loud:

**Logistics route optimization.** Mature field, established tools, narrow marginal value from GenAI, long integration tail. Traditional optimization beats LLMs for the next two years.

**AI for financial reporting.** Regulatory risk outweighs benefit. CFO will ask who signs off on an AI-generated number, and there is no good answer yet.

Say this explicitly, politely, with rationale. The CFO will appreciate the realism.

## 8. The Framework for Picking

Every candidate use case gets scored on seven binaries:

1. Business value quantifiable in rupees or hours? Yes/No.
2. Data accessible and reasonably clean? Yes/No/Partial.
3. Owner with skin in the game? Yes/No.
4. Failure mode recoverable? Yes/No.
5. Scopable to 90 days? Yes/No.
6. Compliance complexity low or medium? Yes/No.
7. Adoption path clear (who uses it, how)? Yes/No.

Pilot only where all seven are Yes. Anything No on 1, 3 or 4 is not a pilot candidate regardless of enthusiasm.

## 9. The Post-Meeting Deliverable

Within 48 hours I send back:

- Two-page memo: priorities as the room agreed, top five candidates, the 2x2, proposed pilot, success criteria, top risks.
- Invitation for a 45-minute follow-up to confirm the pilot charter.
- Draft pilot charter: scope, success metric, named team, budget envelope, timeline, sustain owner.

The 48-hour clock matters. C-suite momentum decays quickly.

## 10. Tradeoffs

1. **Customer satisfaction (CEO happy) vs. customer success (actual ROI).** Customer success wins. A happy CEO with no results in month 6 is worse than a mildly disappointed CEO with one clean win.
2. **Narrow (one pilot) vs. broad (portfolio).** Narrow. You cannot succeed at five pilots in 180 days. You can succeed at one and earn the right to do five next year.
3. **Buy (Vertex, managed) vs. build (custom fine-tune).** Buy first. Fine-tuning is a month 12 conversation, not month 1.

## 11. Common CEO Responses and How to Handle

"I want 10 use cases by end of year." → "Ambitious. Picking one pilot well creates the leverage for 10 later."

"Our competitor is already doing X." → "Can we check what they have actually shipped versus announced? And whether X is replicable for our data and workflow."

"My board wants to see AI adoption." → "Let me frame the pilot so board reporting is a side effect, not the goal. Measurable customer outcome first, tell the story second."

"Our CIO does not think it is feasible." → "Let me spend time with the CIO on the specific blockers. Usually it is data or talent, not technology."

"Can you train our own model?" → "Not Year 1. Fine-tuning is a Year 2 conversation after we prove value on managed models."

"Why not just buy a turnkey product?" → "If a turnkey product exists for your exact use case, yes. For most enterprise GenAI, the integration with your data, workflow, identity and compliance is the work, and that does not ship turnkey."

## 12. Failure Modes in the Discovery Process

- Letting the CEO pick the use case. Pilot fails and the FDE takes the blame.
- Letting the loudest BU win. Political selection, not value selection.
- Overscoping. 180 days with nothing shipped.
- Under-involving legal and compliance. Blocked at launch.
- Picking a use case without a named data owner. Orphaned.
- Skipping the unacceptable failure mode question. Shipping something that needs rollback.
- Unclear success criteria. Cannot declare victory, cannot declare defeat.

## 13. Tie to My Evidence

This is exactly my J&J MedTech pattern. Embedded for two years. First weeks were discovery, not architecture. I pulled in the program Director the moment I discovered the approval rules were not documented, and reframed the ML spec from "predict approvals" to "decision support with override", which is what survived legal, security and CAB. Business reality first, AI second.

My Data Sentry work inside the J&J COE followed the same shape. I shadowed the IAM team for two days before writing code, to see how role requests actually flowed, not how policy said they flowed. Shadow BU leaders before proposing AI.

At Gracenote, CTO recognition for the LangGraph workflow and Haiku migration came because I picked the right pilots (high-volume, measurable, clearly owned) and showed outcomes quickly. I did not try to convert the entire metadata pipeline in one quarter. I converted the highest-leverage slice, proved it, and let that earn the next slice.

I would use my AutoResearch harness for the portfolio scoping itself: hypothesis log, memory log, plan-then-execute. That is the discipline I need to track use-case evaluation across nine stakeholders over three weeks without losing the thread.

## 14. Follow-up Q&A

- CEO insists on the portfolio approach? Push back with data. One pilot plus two explorations, not five pilots.
- No data owner? Find one or do not take the pilot.
- Low data quality everywhere? Propose a 6-week data-readiness sprint before AI.
- Internal politics? Principal-agent problem. Identify who benefits, who loses, compensate the losers.
- CIO against? Alignment first. Cannot succeed without CIO buy-in.
- Regulatory concerns? Legal and compliance in Week 1, not Week 8.
- BU CEOs disagree? Facilitate, do not pick. Escalate to CEO only if the 2x2 cannot resolve it.
- How to say no to a C-suite person? Data-driven, options-based, never adversarial. Offer the alternative in the same breath.
- Success metric? A business metric that changes in a defined window. CSAT alone is not enough.
- Cannot ship in 90 days? Redefine done or deprecate early. Do not drift.
- FDE-to-sustain transition? Ownership handoff Week 10, training Week 11, office hours first month after.
- Pilot failing? Post-mortem on data, scope or ownership. Customer trust matters more than win rate.

## 15. Red Flags to Avoid

- "Let's deploy RAG everywhere."
- "We will figure out ownership later."
- "AI will transform the business."
- "I can promise 10 use cases in Year 1."
- "We do not need the CIO onside."
- "The CEO is always right."

Each signals a junior FDE who produces a political mess and a failed pilot.


## 16. Senior Closing

If I kept hitting this pattern (C-suite mandate, vague scope, political dynamics), I would package the portfolio-scoping framework, pilot charter template and stakeholder-interview guide as a reusable FDE asset. Product feedback to Google: ship a GenAI Discovery Framework in the Cloud Consulting toolkit. Customers are being sold the tools without the discipline, and the tools underdeliver without it.

## 17. 90-Second Recall Summary

The prompt is political, not technical. Before the meeting, read Keystone's public docs and talk off the record to the CIO and two BU heads. In the meeting, open by reframing from "where do we use AI" to "what business outcomes matter". 30 minutes of business discovery with eight questions, including unacceptable failure mode. Map use cases on a value-feasibility 2x2. Map constraints across data, regulatory, talent, culture, tech debt and budget rules. Propose one pilot, not three. Score candidates on the seven-binary framework; accept only all-Yes. Within 48 hours deliver a two-page memo, draft pilot charter and follow-up invite. Tradeoffs: success over satisfaction, narrow over broad, buy before build. Anchor in J&J MedTech (discovery before architecture) and Gracenote (pick the right slice, prove value fast). Hand off ownership by Week 10. Do not become the AI person forever.
