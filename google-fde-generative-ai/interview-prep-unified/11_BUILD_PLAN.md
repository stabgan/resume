# 11_BUILD_PLAN — Turn JD Gaps Into GitHub Projects in 11 Days

## Why This Exists

The JD lists a specific stack: CrewAI, Google ADK, Vertex AI Agent Builder, Agent Engine, Vector Search, RAG Engine, deep OAuth 2.0 flows, MCP secure tool-calling. I have shipped with some of these (LangGraph, MCP servers, Microsoft Graph OAuth at J&J) and read docs on others (ADK, CrewAI, Vertex AI RAG Engine, A2A). The previous curriculum told me to avoid claiming CrewAI, ADK, Vertex AI products, or deep OAuth because I had not shipped with them. That framing was wrong. I have 11 days. I am a fast builder. I use AI agents daily. I can turn each gap into a small, real, public GitHub project in one day. Each repo becomes concrete evidence I can link from LinkedIn and reference in the interview.

Strategy: four to six small projects. Each one takes two to five hours end to end. Each one gets pushed to github.com/stabgan, linked from the resume, and becomes a talking point. The goal is not production polish. The goal is to move from "I know what it is" to "I shipped with it last week and here is the repo."

## Priority Order

Priority 1, must build, four projects, about twenty hours total:

- adk-agent-hello-world: working ADK agent deployed to Vertex AI Agent Engine
- crewai-vs-langgraph-comparison: side by side CrewAI and LangGraph on the same task
- oauth-integration-demo: GCP OAuth 2.0 with PKCE, Secret Manager, refresh flow
- vertex-rag-engine-demo: managed RAG with ACL-aware retrieval stub

Priority 2, nice to have, two projects, about ten hours:

- a2a-protocol-demo: two agents talking via the A2A protocol
- vpc-sc-terraform-reference: Terraform for a regulated-customer agent deployment

If Gracenote work gets heavy, I drop to Projects 1 and 2 only. If things go sideways, I build only Project 1. ADK is the most JD-critical and the most learnable in one evening.

## Scheduling, 11-Day View

| Date | Work block | Project |
|---|---|---|
| May 2 (today) | Evening, 3h | Start P1 adk-agent-hello-world. Install ADK, run the hello-world sample locally. |
| May 3 (Sat) | Morning, 4h | Finish adk-agent-hello-world. Deploy to Agent Engine. Write README. Commit and push. |
| May 4 (Sun) | Morning, 4h | Start and finish crewai-vs-langgraph-comparison. Write comparison README. |
| May 5 (Mon) | Evening, 2h | Start oauth-integration-demo. Register GitHub OAuth app, scaffold FastAPI. |
| May 6 (Tue) | Evening, 3h | Finish oauth-integration-demo. Secret Manager integration, refresh flow. Push. |
| May 7 (Wed) | Evening, 3h | Start and finish vertex-rag-engine-demo. Push. |
| May 8-9 | Stretch | Optional: a2a-protocol-demo or vpc-sc-terraform-reference if on schedule. |
| May 10-11 | Polish | Update resume Open Source section. Update LinkedIn with project links. |
| May 12-13 | Taper | No building. Review, rest, run through the casebook. |

## Project 1: adk-agent-hello-world

Repo: github.com/stabgan/adk-agent-hello-world
Effort: 6-7 hours
Goal: A working ADK agent deployed to Vertex AI Agent Engine that answers weather questions using a single tool. This proves hands-on ADK and Agent Engine, which are the two most JD-critical items I have not yet shipped.

### Scope

Python ADK agent. One tool, get_weather, that calls OpenWeatherMap free tier or returns a mock for demo stability. Deployed to Vertex AI Agent Engine. README with the deploy flow. A short GIF or screenshot showing the query and grounded response. That is it. No memory, no multi-agent, no eval harness. Minimum viable.

### Exact steps

Install the ADK and authenticate:

```bash
pip install google-cloud-aiplatform[adk,agent-engines]
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

Create the agent in agent.py:

```python
from vertexai.preview.reasoning_engines import AdkApp
from google.adk.agents import Agent

def get_weather(city: str) -> str:
    """Return current weather for a city. Demo uses a stub."""
    return f"Weather in {city}: 22C, partly cloudy, light wind."

weather_agent = Agent(
    name="weather_agent",
    model="gemini-2.5-flash",
    instruction=(
        "You are a weather assistant. "
        "Always use the get_weather tool when asked about weather. "
        "Do not invent values."
    ),
    tools=[get_weather],
)

app = AdkApp(agent=weather_agent)
```

Deploy to Agent Engine in deploy.py:

```python
import vertexai
from vertexai.preview import reasoning_engines
from agent import app

vertexai.init(
    project="YOUR_PROJECT_ID",
    location="us-central1",
    staging_bucket="gs://YOUR_STAGING_BUCKET",
)

remote_app = reasoning_engines.ReasoningEngine.create(
    app,
    requirements=["google-cloud-aiplatform[adk,agent-engines]"],
    display_name="Weather Agent Demo",
)

print("Deployed:", remote_app.resource_name)

resp = remote_app.query(input="What is the weather in Tokyo?")
print(resp)
```

### README structure

One-paragraph pitch. Three-line comparison of ADK versus LangChain versus CrewAI. ASCII or mermaid architecture diagram. Deploy command. Run command with expected output. Screenshot. Note on costs and how to tear the engine down with reasoning_engines.ReasoningEngine.delete.

### Interview talking point

"I built a working ADK agent and deployed it to Vertex AI Agent Engine last week. The repo shows the minimum viable pattern, agent definition, tool registration, the deploy call, and teardown. Here is the link. Happy to walk through the deploy flow or show the engine in the console."

## Project 2: crewai-vs-langgraph-comparison

Repo: github.com/stabgan/crewai-vs-langgraph-comparison
Effort: 5-6 hours
Goal: Same multi-agent workflow implemented twice, once in CrewAI and once in LangGraph, so I can speak to both mental models with evidence. This also signals I picked LangGraph for Gracenote deliberately, not because I did not know CrewAI.

### Scope

Task: research a company and write a one-page brief. Two agents, a Researcher and a Writer. Two implementation files, crew_version.py and langgraph_version.py. A comparison README with an honest table of tradeoffs.

### Exact steps

CrewAI version:

```bash
pip install crewai crewai-tools
```

```python
from crewai import Agent, Task, Crew

researcher = Agent(
    role="Research Analyst",
    goal="Find the most important facts about {company}",
    backstory="You summarize company information quickly and accurately.",
    verbose=True,
)

writer = Agent(
    role="Business Writer",
    goal="Write a concise one-page brief from research notes.",
    backstory="You are known for clear, no-fluff business writing.",
    verbose=True,
)

research_task = Task(
    description="Research {company} and note 5 key facts.",
    agent=researcher,
    expected_output="5 bullet points with facts and sources",
)

write_task = Task(
    description="Using the research notes, write a 300-word brief on {company}.",
    agent=writer,
    expected_output="300-word brief in markdown",
    context=[research_task],
)

crew = Crew(
    agents=[researcher, writer],
    tasks=[research_task, write_task],
    verbose=True,
)

result = crew.kickoff({"company": "Google Cloud"})
print(result)
```

LangGraph version on the same task:

```python
from typing import TypedDict
from langgraph.graph import StateGraph, END
from langchain_google_vertexai import ChatVertexAI

llm = ChatVertexAI(model="gemini-2.5-flash")

class State(TypedDict):
    company: str
    research: str
    brief: str

def research_node(state: State):
    prompt = f"Research and list 5 key facts about {state['company']}."
    research = llm.invoke(prompt).content
    return {"research": research}

def write_node(state: State):
    prompt = (
        f"Using these facts, write a 300-word brief on {state['company']}:\n\n"
        f"{state['research']}"
    )
    brief = llm.invoke(prompt).content
    return {"brief": brief}

workflow = StateGraph(State)
workflow.add_node("research", research_node)
workflow.add_node("write", write_node)
workflow.set_entry_point("research")
workflow.add_edge("research", "write")
workflow.add_edge("write", END)

app = workflow.compile()
result = app.invoke({"company": "Google Cloud", "research": "", "brief": ""})
print(result["brief"])
```

### README content

One-paragraph summary. Code snippets side by side or linked files. A table of what is easier in each framework, covering prototyping speed, state control, checkpointing, human in the loop, observability, and deployment. A short section titled "Which would I pick for Gracenote-style production and why."

### Interview talking point

"I built both because I wanted to answer for myself when CrewAI's role and task mental model beats LangGraph's graph and state model. The repo has the honest comparison. At Gracenote I picked LangGraph because I needed stateful checkpointing and human-in-the-loop interrupts. CrewAI is faster to prototype when the workflow is a fixed pipeline of roles."

## Project 3: oauth-integration-demo

Repo: github.com/stabgan/oauth-integration-demo
Effort: 6-7 hours
Goal: A real OAuth 2.0 Authorization Code flow with PKCE, using GCP Secret Manager for token storage and a working refresh path. This demonstrates OAuth depth beyond "I used Microsoft Graph OAuth at J&J."

### Scope

Python FastAPI service. GitHub OAuth integration, free and fast to set up. Authorization Code plus PKCE flow. Tokens stored in GCP Secret Manager, one secret per user. Access token used to hit the GitHub user endpoint. Refresh on 401. Logout endpoint that revokes the token.

### Exact steps

Register a GitHub OAuth app at github.com/settings/developers. Set the callback to http://localhost:8000/callback. Scopes: read:user.

Install dependencies:

```bash
pip install fastapi uvicorn httpx google-cloud-secret-manager python-dotenv
```

PKCE helpers and Secret Manager glue:

```python
import secrets, hashlib, base64, json
from google.cloud import secretmanager

PROJECT_ID = "YOUR_PROJECT_ID"

def generate_pkce():
    verifier = secrets.token_urlsafe(32)
    challenge = (
        base64.urlsafe_b64encode(hashlib.sha256(verifier.encode()).digest())
        .rstrip(b"=")
        .decode()
    )
    return verifier, challenge

def _sm_client():
    return secretmanager.SecretManagerServiceClient()

def store_tokens(user_id: str, access_token: str, refresh_token: str | None):
    client = _sm_client()
    secret_id = f"oauth_tokens_{user_id}"
    parent = f"projects/{PROJECT_ID}"
    try:
        client.create_secret(
            request={
                "parent": parent,
                "secret_id": secret_id,
                "secret": {"replication": {"automatic": {}}},
            }
        )
    except Exception:
        pass
    payload = json.dumps(
        {"access_token": access_token, "refresh_token": refresh_token}
    ).encode()
    client.add_secret_version(
        request={
            "parent": f"projects/{PROJECT_ID}/secrets/{secret_id}",
            "payload": {"data": payload},
        }
    )

def read_tokens(user_id: str) -> dict:
    client = _sm_client()
    name = f"projects/{PROJECT_ID}/secrets/oauth_tokens_{user_id}/versions/latest"
    resp = client.access_secret_version(request={"name": name})
    return json.loads(resp.payload.data.decode())
```

FastAPI routes, sketched:

```python
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import RedirectResponse
import httpx, os, uuid

app = FastAPI()
CLIENT_ID = os.environ["GITHUB_CLIENT_ID"]
CLIENT_SECRET = os.environ["GITHUB_CLIENT_SECRET"]
REDIRECT_URI = "http://localhost:8000/callback"
_session = {}  # demo only; real app uses signed cookies or Redis

@app.get("/login")
def login():
    verifier, challenge = generate_pkce()
    state = str(uuid.uuid4())
    _session[state] = verifier
    url = (
        "https://github.com/login/oauth/authorize"
        f"?client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}"
        f"&scope=read:user&state={state}"
        f"&code_challenge={challenge}&code_challenge_method=S256"
    )
    return RedirectResponse(url)

@app.get("/callback")
async def callback(code: str, state: str):
    verifier = _session.pop(state, None)
    if not verifier:
        raise HTTPException(400, "Invalid state")
    async with httpx.AsyncClient() as c:
        r = await c.post(
            "https://github.com/login/oauth/access_token",
            data={
                "client_id": CLIENT_ID,
                "client_secret": CLIENT_SECRET,
                "code": code,
                "redirect_uri": REDIRECT_URI,
                "code_verifier": verifier,
            },
            headers={"Accept": "application/json"},
        )
    tokens = r.json()
    # Fetch user id, then store tokens keyed by user id
    async with httpx.AsyncClient() as c:
        u = await c.get(
            "https://api.github.com/user",
            headers={"Authorization": f"Bearer {tokens['access_token']}"},
        )
    user = u.json()
    store_tokens(str(user["id"]), tokens["access_token"], tokens.get("refresh_token"))
    return {"user": user["login"], "stored": True}
```

Add /api/user that fetches from Secret Manager, hits GitHub, refreshes on 401, and /logout that revokes via GitHub's revoke endpoint.

### README content

Architecture diagram showing browser, FastAPI, GitHub, and Secret Manager. Sequence diagram for the Authorization Code with PKCE flow. A section on security choices: PKCE, state parameter for CSRF, Secret Manager over local storage, scope minimization. A short note on what a production version would add: signed session cookies, rotation of encryption keys, audit logging to Cloud Logging.

### Interview talking point

"I have shipped OAuth in production at J&J using Microsoft Graph. To sharpen up for this interview I built an end to end GitHub OAuth integration with Authorization Code plus PKCE, GCP Secret Manager for token storage, and a working refresh flow. The repo shows the full flow. I am happy to talk through the tradeoffs, service account versus user delegated, scope minimization, and what I would add to take it to production."

## Project 4: vertex-rag-engine-demo

Repo: github.com/stabgan/vertex-rag-engine-demo
Effort: 4-5 hours
Goal: A small Vertex AI RAG Engine demo with a corpus of public docs and an ACL-aware retrieval stub. Demonstrates hands-on with the managed RAG product, which shows up repeatedly in the JD.

### Scope

Upload fifty to one hundred sample docs to Cloud Storage. Create a RAG Engine corpus. Ingest the files. FastAPI endpoint, /query, that returns a grounded answer with citations. An ACL stub: each doc is tagged public or internal in metadata, and the query path enforces the caller's role before returning the answer. A README with architecture.

### Exact steps

```python
import vertexai
from vertexai.preview import rag

vertexai.init(project="YOUR_PROJECT_ID", location="us-central1")

corpus = rag.create_corpus(display_name="demo-corpus")

rag.import_files(
    corpus_name=corpus.name,
    paths=["gs://YOUR_BUCKET/sample_docs/"],
    chunk_size=512,
    chunk_overlap=100,
)

response = rag.retrieval_query(
    rag_resources=[rag.RagResource(rag_corpus=corpus.name)],
    text="What is the refund policy?",
    similarity_top_k=5,
)
for ctx in response.contexts.contexts:
    print(ctx.source_uri, ctx.text[:200])
```

ACL stub at query time:

```python
def query_with_acl(user_role: str, question: str):
    raw = rag.retrieval_query(
        rag_resources=[rag.RagResource(rag_corpus=CORPUS_NAME)],
        text=question,
        similarity_top_k=10,
    )
    allowed = [
        c for c in raw.contexts.contexts
        if user_role == "internal" or c.metadata.get("acl") == "public"
    ]
    return grounded_answer(question, allowed[:5])
```

Wrap this in FastAPI with a fake header, X-User-Role, that carries "public" or "internal" for the demo.

### README content

Architecture diagram: FastAPI, RAG Engine managed corpus, Gemini for generation. A note on why ACL at the app layer is a stub and what real ACL propagation looks like with BigQuery grounding or custom metadata filters. Sample queries showing the same question returning different results for the two roles.

### Interview talking point

"I built a Vertex AI RAG Engine demo with an ACL-aware retrieval stub to practice the managed corpus and retrieval flow. The repo shows the ingest, the query path, and how I would propagate user role into retrieval. For a real customer I would want to go deeper on ACL propagation across BigQuery grounding, but the pattern is the same."

## Project 5, Optional: a2a-protocol-demo

Repo: github.com/stabgan/a2a-protocol-demo
Effort: 3-4 hours
Goal: Two ADK agents communicating via the A2A protocol, deployed on Cloud Run. Proves I understand the A2A versus MCP distinction concretely, not just by definition.

### Scope

Agent A, a Researcher, exposes an agent card. Agent B, a Writer, discovers Agent A via its card and calls it for research before writing the brief. Both on Cloud Run. README shows the agent cards, the protocol handshake, and a sequence diagram. Small, focused, one afternoon.

### Interview talking point

"To make the A2A versus MCP distinction concrete, I built two ADK agents that talk to each other via A2A. The repo has the agent cards and the execution trace. A2A is agent to agent, MCP is agent to tool. The demo makes that literal."

## Project 6, Optional: vpc-sc-terraform-reference

Repo: github.com/stabgan/vpc-sc-terraform-reference
Effort: 4-5 hours
Goal: A Terraform reference module for deploying an agent in a regulated-customer environment. Shows I understand VPC Service Controls, Private Service Connect, and IAP patterns.

### Scope

One Terraform module. Deploys Cloud Run for the agent, IAP in front for user auth, a VPC Service Controls perimeter, and Private Service Connect endpoints to Vertex AI and Secret Manager. README with an architecture diagram and a threat model note. No real deploy required. The module itself is the artifact.

### Interview talking point

"I wrote a Terraform reference module for deploying an agent in a regulated-customer environment, VPC-SC perimeter, Private Service Connect to Vertex AI, IAP for user auth. It does not need to run to make the point. The module shows the security pattern and the IAM surface."

## Post-Build: Update LinkedIn and Resume

After each project is pushed, I update two surfaces.

LinkedIn profile, Projects or Featured section. Each repo gets a one-line description and a link. On the headline and About, I add a line that reads "recently shipped ADK agent on Vertex AI Agent Engine, Vertex AI RAG Engine demo, OAuth 2.0 with PKCE on GCP."

Resume, resume_google_fde.tex, Open Source section. Something like:

```latex
\section{Open Source and MCP Ecosystem}
\begin{itemize}
  \item \textbf{@stabgan/openrouter-mcp-multimodal} production MCP server on npm, 300+ LLMs
  \item \textbf{@stabgan/steelmind-mcp} research-grounded verification MCP
  \item \textbf{adk-agent-hello-world} working ADK agent deployed to Vertex AI Agent Engine
  \item \textbf{crewai-vs-langgraph-comparison} side-by-side multi-agent framework study
  \item \textbf{oauth-integration-demo} OAuth 2.0 Authorization Code + PKCE + Secret Manager
  \item \textbf{vertex-rag-engine-demo} Vertex AI RAG with ACL-aware retrieval stub
  \item 8 fine-tuned Gemma 3 1B checkpoints on HuggingFace, clinical NLP
\end{itemize}
```

## The Interview Narrative

Interviewer: "Do you have hands-on experience with ADK?"

Before these projects: "I have read the docs and I understand the pattern."
After these projects: "Yes. I built an ADK agent and deployed it to Vertex AI Agent Engine last week. It is on my GitHub. Let me walk you through the deploy flow."

That is the difference. Real evidence, not hedging. The interviewer does not need to open the repo. The fact that I can name it, describe the deploy call, and offer to show it changes the conversation.

Same pattern for CrewAI: "I built a side by side comparison with LangGraph on the same task. Here is the repo. At Gracenote I picked LangGraph because of checkpointing and interrupts, but I am comfortable in both."

Same pattern for Vertex AI RAG Engine: "I built a small demo with the managed corpus and an ACL-aware retrieval stub. I understand the ingest and query flow. For a real customer I would go deeper on ACL propagation across BigQuery grounding."

Same pattern for OAuth: "I have shipped OAuth with Microsoft Graph at J&J. I recently built a GitHub OAuth with PKCE and Secret Manager demo to practice the GCP flow."

## Time Box and Quality Bar

Each project is minimum viable. Not production. The bar is:

- Builds and runs on a clean environment following the README
- README is clear enough that another engineer could replicate it
- Commit history shows real engineering, small focused commits, not a single AI-generated dump
- No broken links, no 404 images
- No exposed API keys, .env in .gitignore, secrets read from env vars or Secret Manager
- Reasonable .gitignore for Python or Terraform
- A short "What I would do next for production" section in every README

I will not over-polish. No CI badges, no contribution guidelines, no issue templates. These are interview assets, not portfolio centerpieces. If I find myself in hour six on project one, I cut scope, ship what I have, and move on.

## If Time Is Tight

If Gracenote work gets heavy mid-week, the fallback order is clear.

Three projects only: drop the RAG Engine demo. ADK, CrewAI versus LangGraph, and OAuth cover the three biggest gaps.

Two projects only: drop OAuth. ADK and CrewAI cover the two most JD-critical framework gaps, and I can fall back on the J&J OAuth story.

One project only: build adk-agent-hello-world. ADK is the single most JD-critical and most learnable piece. Twelve hours of real work is worth more than fifty hours of doc reading.

Zero projects, worst case: I still have the MCP servers on npm, the fine-tuned Gemma checkpoints, the Gracenote LangGraph system, and the J&J OAuth story. That is the floor. Anything I build from here is upside.

## Specific Honesty Framing

When the interviewer asks about each topic, I want to be honest about depth. Overclaiming will get caught in a follow-up. Underclaiming wastes the evidence.

ADK: "I built a hello-world demo last week and deployed it to Agent Engine. I understand the deploy pattern and the tool registration model. For production, I would need to go deeper on Memory Bank, session management, and multi-agent orchestration with ADK."

CrewAI: "I built a comparison repo against LangGraph on the same task. Both mental models are clear. For the Gracenote kind of workload, stateful and long-running with human in the loop, I still prefer LangGraph for the checkpointing and interrupts. For a fast pipeline of fixed roles, CrewAI is quicker."

Vertex AI RAG Engine: "I built a demo with the managed corpus and an ACL stub at the app layer. I understand the ingest and retrieval flow. For a real customer I would need to learn more about ACL propagation across BigQuery grounding and how the managed index handles large corpora with mixed sensitivity."

OAuth: "I shipped OAuth at J&J with Microsoft Graph for an enterprise service. I recently built a GitHub OAuth with PKCE and Secret Manager demo. For deep protocol design on a new customer, I would partner with a security specialist early, especially on token lifetime policy, revocation, and audit logging."

MCP: "I publish a production MCP server on npm, openrouter-mcp-multimodal, and steelmind-mcp. I understand the protocol end to end. For Google customer work, I would map MCP onto ADK's tool interface and wrap secure tool-calling patterns around it."

A2A: "If I get the optional project done, I will have two ADK agents talking via A2A on Cloud Run. Otherwise I speak to the protocol by spec and map it to MCP conceptually, A2A is agent to agent, MCP is agent to tool."

Honesty earns trust. Real evidence in the form of public repos earns more. Eleven days is enough to move every one of these from claim to proof.
