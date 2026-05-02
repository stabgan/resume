# Case 06 — Customer Data Readiness

Tags: Data Strategy, Customer Discovery, Pre-Architecture Work, Regulated Environment. Likelihood: VERY HIGH (most common FDE blocker).

## 1. The Prompt

"A customer wants GenAI, but their data is messy, duplicated, and spread across legacy systems. What do you do?"

The most common situation I expect to walk into as an FDE. The surface ask is a model or chatbot. The real work is data readiness. Job: make it visible early, scope honestly, land a pilot that ships.

## 2. Customer Context

Embedded with Fortuna Health Systems: 4 hospitals, ~4,000 employees, ~2M annual patient visits. CEO read about Gemini and mandated "GenAI for clinical and admin workflows." CIO commissioned discovery. Landscape:

- 7 clinical systems: Epic at 2 hospitals, Cerner at 1, a legacy custom EMR at 1, plus PACS, LIS, and a home-grown order-entry app
- 4 admin systems: Workday-style ERP, HR, a billing system tied to a clearinghouse, an in-house scheduling app
- Document sprawl: SharePoint, Windows file shares, scanned PDFs in nested folders with no consistent naming
- Different hospitals use different local codes for the same procedures; CPT is used but mapped inconsistently
- Patient demographics in 3 formats (name parsing, address schemas, MRN formats)
- HIPAA plus HITRUST commitments, India-based offshore admin ops, a data residency clause in the contract

CIO says "pick a use case and go." As FDE, my job is to say what's actually realistic. Don't over-promise, don't under-deliver.

## 3. Discovery Phase

Before picking a use case, run discovery. Conversational, but collecting twelve specific signals.

1. What business problems are most painful right now?
2. Which workflows have budget attached this fiscal year?
3. Which regulators and frameworks apply? HIPAA, HITRUST, Joint Commission, state?
4. What's the biggest competitive threat?
5. Who are the stakeholders? Clinical ops, RCM, CMIO, CISO, compliance, legal?
6. What past AI or automation efforts failed, and why? (this is gold)
7. Who owns each system as a data owner, not the IT admin?
8. Who would actually use the AI daily? Nurses, coders, schedulers, physicians?
9. What happens today when data is wrong? Who eats the error?
10. What's the tolerance for errors? Clinical zero-tolerance vs admin fuzzy?
11. Who decides what data the AI can access? Privacy officer, CISO, or data owner?
12. Any existing DQ, MDM, or data warehouse efforts I can build on?

Critical move: no use case picked in this meeting. Get the data reality first. Picking now is gambling.

## 4. The Anti-Pattern

What I won't do:

- Promise a chatbot in 30 days
- Pick a flashy use case like clinical Q&A and find out six weeks in that the data lives inside Epic with no API surface I'm allowed to hit
- Design architecture before I understand data ownership
- Assume the CEO's mandate maps to one project

Data readiness is usually the blocker that looks like a model problem. I make it visible early instead of hiding it behind a demo. This is the J&J MedTech lesson in section 14.

## 5. MVP Proposal — 4-Week Data Readiness Sprint

A 4-week sprint before any model work. The MVP before the MVP.

### Week 1: Data Inventory

- List every system. For each: owner, API surface, row count, PII sensitivity, refresh cadence, DQ history
- Map systems to business workflows (which system powers which decision?)
- Classify each source as "gold" (trusted, governed), "bronze" (usable with work), or "tarnished" (Excel overlays, tribal knowledge, handwritten rules)
- Red flags: no named owner, spreadsheet overlays, critical logic in one person's head

### Week 2: Deep Dive on One Slice

Pick one candidate use case, pressure-test data viability:

- Schema alignment: same concept represented differently across the 3 to 5 source systems it touches?
- Labels: ground truth for what "correct" looks like? Without labels, no evaluation loop
- Freshness: how stale at decision time?
- Cardinality: duplicate, near-duplicate, orphan rate
- Governance: who authorizes this data for AI, documented?

### Week 3: Use Case Scoping

Rank candidates on five dimensions:

- Data viability (access, clean, govern in a quarter?)
- Business value (revenue recovered, cost avoided, risk reduced)
- Compliance complexity (PHI depth, audit)
- Time to pilot (6, 12, or more weeks)
- Ownership clarity post-delivery (who runs this when I leave?)

Pick 1 to 2 that rank highly on all five.

### Week 4: Go/No-Go

- Present inventory and scoped use case to CIO, clinical ops, CISO, compliance
- Get explicit yes/no, documented success criteria, named post-delivery owner
- If yes, scope MVP. If no, propose a narrower slice or an honest "not yet"

## 6. Data Inventory Template

Per system:

- Name (and internal nickname, because people use the nickname)
- Owner: person, not team
- Steward: day-to-day operator who knows the quirks
- Row count and size on disk
- Update frequency (real-time, hourly, nightly, manual)
- Primary keys and join keys
- PII classification (Public, Internal, Confidential, Restricted, PHI)
- Historical issues (outages, schema breaks, audit findings)
- Current users and workflows
- Access mechanism: API, direct DB, file drop, screen scrape
- Licensing constraints (third-party feeds often block AI use)
- Retention policy (7 years clinical, 10 billing, etc.)

Output: one BigQuery table plus a Data Catalog entry per system.

## 7. Data Quality Assessment Matrix

For each candidate source, score 8 dimensions:

- Completeness: % of expected records present
- Consistency: conflict rate across sources for the same entity
- Freshness: staleness distribution (p50, p95 age at query time)
- Accuracy: sample-vs-ground-truth on a 500-record audit
- Timeliness: latency from event to availability
- Uniqueness: duplicate and near-duplicate rate
- Integrity: referential validity
- Validity: schema conformance (types, enums, ranges)

Heatmap per source per dimension. Red cells fixed before AI touches them. Green ready. Yellow gets a mitigation note.

First clinical pilot thresholds: completeness above 95%, duplicate rate below 2%, accuracy above 98% on audit, freshness p95 under 24h admin, under 1h for active care.

## 8. The Canonical Schema Move

After inventory, before AI, define a canonical layer:

- One canonical representation per key entity: Patient, Encounter, Procedure, Claim
- Map each source to canonical with explicit transformation rules in dbt
- Flag conflicts rather than silently reconciling. If Epic says DOB is one thing and Cerner says another, both land with a conflict flag
- Store the conflict log as signal. Conflict patterns are themselves a data product

The move from J&J MedTech. Approval rules weren't documented, they were tribal heuristics that differed by region. I paused the ML spec and reframed: instead of predicting approvals (which encodes the inconsistency), build decision support with confidence and override. Don't model inconsistency, surface it.

## 9. Architecture (Data Layer)

```
Source Systems → Dataflow / Cloud Data Fusion → Cloud Storage (raw, versioned)
→ BigQuery (canonical via dbt) → Dataplex (DQ, lineage, catalog)
→ GenAI layer (Gemini on Vertex AI, Vector Search for docs)
```

Specifics:

- Cloud Storage with structured prefixes `system/yyyy/mm/dd/version/` for raw landing
- Cloud Data Fusion for visual ETL where analyst-stewards maintain mappings; Dataflow for high-volume streaming
- BigQuery holds the canonical layer. dbt models in Git, tests on every commit
- Dataplex runs DQ checks on canonical tables, tracks lineage, powers discovery catalog
- Data Catalog surfaces tags, owners, PII class
- Private Service Connect keeps on-prem EMR traffic on the Google backbone
- CMEK with HSM-backed keys for any PHI at rest
- VPC Service Controls perimeter around BigQuery, Cloud Storage, Vertex AI, Dataplex so PHI can't exfiltrate
- Cloud DLP for PHI detection on ingest and deterministic format-preserving masking on non-prod

Only then does GenAI have something to ground on.

## 10. Governance

Data Council:

- Chair: CIO
- Members: named data owner per domain (clinical, RCM, HR, scheduling), compliance lead, CISO delegate, AI/FDE lead
- Monthly, 60 minutes
- Approves: access grants, retention changes, model behavior changes, exceptions

Policies:

- Classification: Public, Internal, Confidential, Restricted, PHI/PII
- AI access by class. PHI requires BAA plus DPIA per use case
- Retention: 7 years clinical, 10 billing, 5 HR, aligned to state and federal minima
- Masking: deterministic tokens for MRN (joins still work), format-preserving encryption for customer-facing fields, free-form PHI redacted via DLP before prompts

## 11. Tradeoffs

1. Perfect data layer vs scoped use case first. Start with the scoped use case where data is cleanest. A pristine enterprise data layer is a multi-year project. A pilot needs a slice.
2. Move all data to GCP vs federated access. For v1, federated. BigQuery external tables plus Private Service Connect read where data lives. Migration planned but not a gate
3. Fix DQ before AI vs AI-first. Fix enough for the specific use case. Don't boil the ocean. The DQ matrix sets the minimum bar

## 12. Failure Modes

- Use case owner disappears mid-pilot: designate a steward in the MVP contract, not after
- Data fails DQ unexpectedly: surface it in the Dataplex dashboard. Customer sees what I see
- Labels drift as tribal rules change: periodic recalibration on cadence, drift tracked as a first-class metric
- Regulatory change: DQ framework absorbs most of it because it's dimension-based. Use cases designed to be explainable
- Data ownership disputed: escalate to Data Council. Don't freeze. Freezing is how pilots die
- Source system API deprecates: catalog tracks versions, migrations scheduled rather than discovered at break time
- Synthetic bias from historical discrimination in training data: fairness audit against protected-class slices before production. No exceptions for clinical use cases

## 13. Use Cases Ranked for Fortuna Health

After Week 2 and 3:

1. **Discharge summary drafting.** High value (physician time), clinical docs well-structured, low risk because a physician signs every output. HITL by design
2. **Prior authorization drafting and packet assembly.** Medium-to-high value, data scattered across EMR and billing but owners clear, medium risk
3. **Revenue cycle / claims denial response.** High value in recovered revenue, ownership clear, regulatory complexity meaningful
4. **Clinical decision support at point of care.** High value, high risk, messy data. Not a v1
5. **Internal admin chatbot over policy docs.** Easy data, low risk, low impact. Possible learning vehicle, not the lead

Recommendation: reject clinical Q&A as v1. Pick discharge summary drafting, with prior auth as fast-follow once the first pilot clears.

## 14. Tie to Your Evidence

J&J MedTech CCP, two years embedded. Hired to build an ML model for contract approvals. Three weeks in, the approval rules weren't documented. Regions had tribal heuristics that disagreed. I paused training, pulled in the program Director, reframed the spec: instead of predicting approvals (which would silently encode the inconsistency), decision support with confidence scores and human override. Same architecture move I propose here. AUROC 0.95, cleared legal, security, and CAB. Lesson: when data contradicts documented process, stop training and fix the operating model first.

Gracenote ingestion takeover, 1500+ partner catalogs with messy temporal ambiguity. I debugged from real failures, not docs, because the docs were wrong. Same approach for Week 2 of the readiness sprint.

Data Sentry at J&J, automated IAM across AWS, Azure, GCP. Taught me how to move data between clouds without breaking identity, network, or audit controls. Relevant for tradeoff 2.

## 15. Follow-up Q&A

- "CEO wants results in 30 days." Show inventory plus a scoped use case at Week 4. Commit to a pilot scope, not a platform. Visible win (inventory) plus a dated pilot plan.
- "Who owns DQ?" Data owner per domain, AI team as consumer, Data Council as governance.
- "IT says no APIs?" Interim: controlled RPA screen-scraping, OCR on PDF exports, scheduled file drops. Proper-API roadmap goes on the Data Council agenda with dates.
- "Inventory reveals the data is terrible?" Smaller use case, or delay AI until the base layer exists. No papering over red cells with prompt engineering.
- "Data residency (India vs US)?" Regional Cloud Storage, regional BigQuery, regional Vertex AI. Enforced via Organization Policy plus VPC-SC perimeter.
- "HIPAA?" BAA with Google Cloud, CMEK on PHI, VPC-SC perimeter, Cloud Audit Logs retained 7 years, DLP masking on ingest, IAM least privilege with Access Context Manager.
- "How do you measure data ready?" DQ framework. Pass rates per dimension, thresholds per use case. Discharge summaries need completeness above 98% on structured fields; admin chatbot can live with 90%.
- "Cost of the sprint?" 4 weeks, 1 FDE plus 1 data analyst. Order of magnitude cheaper than a failed AI project on bad data.
- "Can the customer DIY?" They can but usually won't. FDE adds speed and pattern recognition.
- "Customer insists on the flashy use case?" Show the DQ heatmap. If red, propose an alternative on the same budget. No building on broken data.
- "Unknown unknowns?" Sample and profile. DQ checks on a slice before the whole. Surprises show up cheap.
- "Source systems change mid-pilot?" Catalog, lineage, schema-drift alerts from Dataplex. Drift detected in hours, not in production.
- "Duplicates?" Entity resolution in canonical. Deterministic first (MRN, SSN hash, DOB+name), probabilistic second. Match decisions stored as signal for audit.
- "Who approves the inventory?" Data Council plus compliance.
- "Deliverables end of Week 4?" Inventory report, use case scoping doc, pilot plan, go/no-go memo, first DQ heatmap. All in a shared repo.

## 16. Red Flags to Avoid

- "Let's just start building"
- "Data quality is IT's problem"
- "We'll fix it in production"
- "The model will handle bad data"
- "Let's migrate everything to GCP first, then talk about AI"

Any of these from me signals I skipped the diligence.

## 17. Senior Closing

If I kept hitting this pattern, customer promises GenAI, data isn't ready, I'd package the 4-week readiness sprint, inventory template, and DQ framework as a reusable FDE module. Template repos for dbt canonical layers, starter Dataplex DQ rules, a BAA-plus-CMEK-plus-VPC-SC bootstrap for regulated customers. Product feedback to Google: Vertex AI and Dataplex integration is still clunky for regulated customers. Streamlining BAA, CMEK, and VPC-SC setup for GenAI workloads into a single opinionated blueprint would save weeks per deployment and lower the bar to the first pilot.

## 18. 90-Second Recall Summary

Customer wants GenAI on messy, duplicated, legacy data. Don't pick a use case first. Run a 4-week data readiness sprint. Week 1: inventory with owner, steward, classification per system. Week 2: deep dive on one slice with an 8-dimension DQ heatmap. Week 3: rank candidates on viability, value, compliance, time-to-pilot, ownership. Week 4: go/no-go with CIO, compliance, clinical ops. Architecture: Cloud Storage, BigQuery with dbt canonical, Dataplex for DQ and lineage, Data Catalog, Private Service Connect, VPC-SC, CMEK, Cloud DLP. Governance: Data Council with named owners. For Fortuna Health, pick discharge summary drafting over clinical Q&A because the data supports it and HITL is built in. Move straight from J&J MedTech: when data contradicts documented process, stop training the model and fix the operating model first. Decision support with confidence and override, not a black box on tribal data.
