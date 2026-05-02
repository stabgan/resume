# Google Cloud FDE RRK

This is the role-specific layer: customer discovery, Google Cloud vocabulary, enterprise integration, and FDE operating model.

## FDE Definition

> An FDE is an embedded builder who turns frontier AI into production reality inside a customer's actual environment.

The role is not:

- Pure SWE.
- Pure consultant.
- Pure sales engineer.
- Demo builder.

It is:

- Code.
- Debug.
- Integrate.
- Deploy.
- Evaluate.
- Operate.
- Feed product lessons back.

## RRK Answer Shape

Use this for every broad prompt:

1. Customer workflow.
2. Stakeholders.
3. Success metric.
4. Data and integration.
5. Architecture.
6. Security/privacy.
7. Reliability/scale.
8. Evals/observability.
9. Cost/latency.
10. Rollout and reusable product feedback.

## Customer Discovery Questions

Ask:

- What workflow are we improving?
- Who uses it daily?
- What is painful today?
- What metric matters to the business?
- What is the unacceptable failure?
- What data is needed and where does it live?
- Who owns security approval?
- What existing identity/network controls must remain?
- Who owns this after the pilot?
- What does success in 30 days look like?

## Google Cloud Product Map

### Agent / GenAI

- **Vertex AI:** Google Cloud ML/GenAI platform.
- **Gemini:** model family.
- **ADK:** Python/code-first agent framework.
- **Agent Engine:** managed runtime for agents.
- **Agent Builder / Gemini Enterprise agent platform:** umbrella for agent development, deployment, governance.
- **RAG Engine:** managed RAG workflows and connectors.
- **Vector Search:** vector retrieval at scale.
- **Model Garden:** model access and selection.

### Compute

- **Cloud Run:** simple autoscaled container services, good for APIs/agents when you want control without K8s.
- **GKE:** Kubernetes for complex/custom deployments or customer K8s standard.
- **App Engine:** managed app platform, less likely to choose for custom agent infra.
- **Compute Engine:** VM-level control.

### Data

- **BigQuery:** analytics, warehouse, structured grounding.
- **Cloud SQL:** relational OLTP.
- **AlloyDB:** high-performance PostgreSQL-compatible.
- **Spanner:** globally distributed relational with strong consistency.
- **Firestore:** document database.
- **Bigtable:** high-throughput wide-column.
- **Cloud Storage:** objects, documents, artifacts.

### Integration / Security

- **IAM:** permissions.
- **OAuth/OIDC:** delegated auth and identity.
- **IAP:** identity-aware access to apps.
- **VPC-SC:** service perimeter to reduce exfiltration.
- **Private Service Connect:** private connectivity to services/APIs.
- **Apigee:** enterprise API management.
- **Cloud KMS/CMEK:** encryption key control.
- **Workload Identity Federation:** access Google Cloud from external identity without long-lived keys.

### Observability

- **Cloud Logging.**
- **Cloud Monitoring.**
- **Cloud Trace.**
- **OpenTelemetry.**

## Agent Engine vs Cloud Run vs GKE

Use this decision tree:

### Agent Engine

Choose when:

- ADK/agent-native deployment.
- Need managed sessions/memory/eval/telemetry/governance.
- Want Google-managed agent runtime.

Tradeoff:

- Less custom infra control than raw containers.

### Cloud Run

Choose when:

- Containerized API/agent.
- Simpler deployment.
- Autoscaling.
- Need custom code/runtime but not full Kubernetes.
- Can front with IAP.

Tradeoff:

- You build more agent lifecycle pieces yourself.

### GKE

Choose when:

- Customer already standardizes on Kubernetes.
- Complex networking/sidecars/service mesh.
- GPU/custom scheduling.
- Deep operational control.

Tradeoff:

- More operational burden.

Soundbite:

> Agent Engine for managed agent lifecycle, Cloud Run for flexible containerized services, GKE for complex/customer-controlled Kubernetes environments.

## Enterprise Integration

### OAuth / OIDC

Know:

- OAuth grants access tokens for delegated access.
- OIDC adds identity via ID token.
- Authorization Code + PKCE: user login flows.
- Client Credentials: service-to-service.
- Device Code: limited-input devices.

FDE line:

> The agent should never have more privilege than the user or workflow it represents.

### SSO / Federation

Customer may use:

- Okta.
- Azure AD / Entra.
- Google Workspace.
- SAML/OIDC.

Design:

- Federate identity.
- Propagate user identity to tools.
- Enforce row/document-level authorization.

### API Management

Use Apigee for:

- Auth.
- Quotas.
- Rate limits.
- Transformations.
- Analytics.
- Developer portal.
- Policy enforcement.

### Private Networking

Use:

- VPC-SC for Google service perimeter.
- PSC for private service access.
- VPC peering/VPN/Interconnect depending customer connectivity.
- Regional endpoints for data residency.

## RRK Deep-Dive Prompts

### Containers And Inference Pipelines

Answer:

- Container packages preprocessing, model server, dependencies.
- Autoscaled service handles online inference.
- Queue handles async/batch work.
- Model registry tracks version.
- Canary routes small traffic.
- Logs include input schema, model version, latency, errors.
- Monitoring catches drift and performance regressions.

If asked "what infrastructure differs":

- CPU vs GPU.
- Batch vs online.
- Autoscaling behavior.
- Cold start sensitivity.
- Model size and memory.
- Throughput and latency.
- Cost.

### Cloud Migration

Prompt:

> Customer wants to move from on-prem/AWS to GCP.

Answer:

1. Discover workloads and dependencies.
2. Classify by migration pattern: rehost, replatform, refactor.
3. Network connectivity and identity federation.
4. Data migration plan.
5. Security/compliance.
6. Pilot low-risk workload.
7. Cutover and rollback.
8. Cost governance.

### Customer Expectations Misaligned

Prompt:

> Client expects Google Cloud to deliver something not feasible.

Answer:

- Acknowledge goal.
- Separate desired outcome from requested implementation.
- Explain constraints with evidence.
- Offer feasible options and tradeoffs.
- Propose pilot to validate.
- Escalate product gap if repeatable.

## Google Cloud Value Proposition

For this role:

- Gemini models.
- Vertex AI platform.
- Agent ecosystem.
- Enterprise security/governance.
- Data cloud: BigQuery + analytics.
- Integration with existing enterprise systems.
- Google-scale infrastructure.

Say:

> The value is not just model quality. It is model plus data, security, deployment, observability, and enterprise integration.

## Field Feedback To Product

End FDE answers with:

- What pattern repeats?
- What reusable module can we build?
- What product gap should engineering know?
- What documentation/reference architecture should be created?

Examples:

- OAuth connector template.
- RAG eval harness.
- Agent deployment checklist.
- VPC-SC/PSC reference architecture.
- Prompt-injection test pack.

## Your Strongest Role Fit Lines

Use these carefully:

- "I have already done the embedded-builder pattern at J&J."
- "My Gracenote work maps directly to production GenAI: agents, evals, latency, cost."
- "My MCP work gives me a tool-integration lens."
- "I do not treat GenAI as a wrapper. I treat it as a production system."
- "The field-to-product feedback loop is how my side projects have happened."

## RRK Failure Modes

Avoid:

- Jumping to Gemini/RAG before clarifying customer workflow.
- Ignoring security.
- Ignoring data readiness.
- Ignoring cost.
- Treating eval as optional.
- Giving AWS-only answer without mapping to GCP.
- Talking like a researcher instead of a builder.
- Talking like a consultant instead of a hands-on engineer.

## Must-Know One-Liners

- MCP connects agents to tools/data.
- A2A connects agents to other agents.
- ADK builds agents.
- Agent Engine runs agents.
- IAP protects apps with identity-aware access.
- VPC-SC reduces data exfiltration risk around Google services.
- PSC provides private connectivity.
- Apigee manages enterprise APIs.
- BigQuery is analytical, Cloud SQL is transactional.
- Cloud Run is simple containers, GKE is Kubernetes control.
