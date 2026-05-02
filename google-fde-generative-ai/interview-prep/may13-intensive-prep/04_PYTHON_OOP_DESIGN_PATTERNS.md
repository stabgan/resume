# Python, OOP, And Design Patterns For Coding

The PDF explicitly mentions object-oriented programming and 30-50 lines of Python. That points to practical class-design problems as much as pure DSA.

## Python Fluency Checklist

Know these cold:

```python
from collections import defaultdict, Counter, deque
import heapq
from functools import lru_cache
```

Use:

- `dict` for key-value lookup.
- `defaultdict(list)` for grouping.
- `Counter` for frequencies.
- `deque` for queues and sliding windows.
- `heapq` for top-k and scheduling.
- `set` for membership and visited.
- `@lru_cache(None)` for memoized recursion.

Avoid:

- `pop(0)` on lists.
- Mutable default arguments.
- Overly clever lambdas.
- Long one-line comprehensions.

## Class Design Answer Shape

When asked to design a class:

1. Clarify operations.
2. Clarify complexity target.
3. Identify state.
4. Identify invariants.
5. Implement methods.
6. Dry-run method sequence.
7. Discuss cleanup/concurrency/scale if production.

Say:

> I will first define the internal state and invariant, then implement each method around that invariant.

## Pattern 1 - Map Plus Queue

Use for:

- Rate limiter.
- Logger limiter.
- Hit counter.
- Recent events.

Invariant:

- For each key, store only timestamps inside active window.

Template:

```python
from collections import defaultdict, deque

class RateLimiter:
    def __init__(self, limit, window):
        self.limit = limit
        self.window = window
        self.events = defaultdict(deque)

    def allow(self, user_id, timestamp):
        q = self.events[user_id]
        cutoff = timestamp - self.window

        while q and q[0] <= cutoff:
            q.popleft()

        if len(q) >= self.limit:
            return False

        q.append(timestamp)
        return True
```

Production discussion:

- Memory cleanup for inactive users.
- Distributed rate limiting needs Redis or sharded counters.
- Token bucket for smoother traffic.
- Clock skew in distributed systems.

## Pattern 2 - Map Plus Doubly Linked List

Use for:

- LRU cache.
- LFU cache variant.

Invariant:

- Hash map gives O(1) key -> node.
- List order gives recency.
- Head is most recent, tail is least recent.

Core methods:

- `_remove(node)`.
- `_add_to_front(node)`.
- `_move_to_front(node)`.
- `_evict_tail()`.

Interview strategy:

If time is short, state invariant first, then code cleanly. Interviewers often care whether you know why dict alone is insufficient.

## Pattern 3 - Map Plus Heap

Use for:

- Top K.
- Schedulers.
- Expiring items.
- Median finder with two heaps.

Invariant:

- Heap orders by priority.
- Map handles lookup/count/staleness if needed.

Pitfall:

- Python heap does not support efficient arbitrary deletion. Use lazy deletion or rebuild if needed.

## Pattern 4 - Trie

Use for:

- Prefix search.
- Autocomplete.
- Word dictionary.
- Word Search II.

Node:

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_word = False
```

Operations:

- insert.
- search.
- startsWith.

Production discussion:

- Memory-heavy.
- Compression/radix tree for large dictionaries.
- Ranking requires counts/scores at nodes.

## Pattern 5 - State Machine

Use for:

- Parser.
- Calculator.
- Workflow states.
- Agent orchestration simplification.

Think:

- Valid states.
- Transitions.
- Invalid input behavior.
- Terminal state.

This maps nicely to FDE agent workflows: do not let the model invent hidden transitions if the business process has explicit states.

## Pattern 6 - Strategy / Pluggable Policy

Use for:

- Payment method.
- Routing model.
- Scoring policy.
- Rate-limiting algorithm.

Interview version:

```python
class Router:
    def __init__(self, strategy):
        self.strategy = strategy

    def route(self, request):
        return self.strategy.choose(request)
```

Use in system design:

- Model router: cheap model for simple, strong model for complex.
- Retrieval strategy: keyword vs vector vs hybrid.

## Pattern 7 - Observer / Pub-Sub

Use for:

- Notifications.
- Event-driven workflows.
- Monitoring.
- Audit logs.

In interviews, describe more than code:

- Producer emits event.
- Queue/broker buffers.
- Consumers process independently.
- Retries and dead-letter queue.

## Pattern 8 - Factory

Use for:

- Creating connectors/tools by type.
- Model client selection.
- Parser by file type.

FDE use:

> A tool factory can instantiate customer-specific connectors while keeping the agent workflow stable.

## OOP Problems And Expected State

### Rate Limiter

State:

- `limit`
- `window`
- `events: user -> deque[timestamp]`

Must discuss:

- Rolling window.
- Multi-user.
- Boundary condition.
- Distributed scale.

### LRU Cache

State:

- `capacity`
- `cache: key -> node`
- dummy head/tail.

Must discuss:

- O(1) get/put.
- Update recency on get and put.
- Evict least recent.

### Time-Based Key-Value Store

State:

- `store: key -> list[(timestamp, value)]`

Method:

- set appends.
- get binary searches latest timestamp <= query.

Must discuss:

- Assumes timestamps increasing per key, or sort needed.

### File System

State:

- Trie-like directory tree.
- Node has children, content, is_file.

Methods:

- `ls(path)`
- `mkdir(path)`
- `addContentToFile(path, content)`
- `readContentFromFile(path)`

### Parking Lot

Keep simplified:

- Vehicle types.
- Spot types.
- Assign/free spot.
- Map ticket -> spot.

Avoid overengineering.

## No-Run Python Debug Habit

After writing code, scan:

- Did I import `deque` or `heapq`?
- Did I use `self.` everywhere in class methods?
- Did I update both map and linked list?
- Did I handle missing key?
- Did I handle capacity zero?
- Did I mutate while iterating?
- Does every loop terminate?

## Production Add-Ons For FDE Flavor

If interviewer asks "what about production":

- Concurrency: locks or external atomic store.
- Persistence: DB/Redis.
- Scale: shard by user/key.
- Observability: metrics and logs.
- Abuse: rate limits and quotas.
- Security: auth before state mutation.

Keep it brief unless asked. Coding round still needs working code.
