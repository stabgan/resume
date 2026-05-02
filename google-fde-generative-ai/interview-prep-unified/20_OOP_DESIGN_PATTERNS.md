# 20 — OOP and Design Patterns: The Round 2 Companion

## Why this file exists

The PDF explicitly says Round 2 covers OOP. `05a_CODING_SOLUTIONS.md` has 5 worked class problems (RateLimiter, LRU Cache, TimeMap, HitCounter, Logger, FileSystem). This file covers the meta-skills: what makes code "object-oriented," when to use inheritance vs composition, and the handful of classic design patterns that might come up as a follow-up ("now extend your Rate Limiter to support multiple strategies").

Scope: just enough to handle "extend your class to do X" follow-ups cleanly. Not a software-architecture textbook.

## The 4 OOP pillars (say these aloud if asked)

### 1. Encapsulation

Internal state is hidden; external access goes through methods. In Python this is a convention via underscore prefix (`_private`) rather than a keyword.

```python
class RateLimiter:
    def __init__(self, limit, window_seconds):
        self._events = defaultdict(deque)    # underscore = private
        self.limit = limit                   # no underscore = public read
    
    def allow(self, user_id, timestamp):     # public method
        ...
    
    def _evict(self, q, cutoff):             # private helper
        while q and q[0] <= cutoff:
            q.popleft()
```

**What to say:** *"I'm marking `_events` as private with the underscore convention so callers know it's internal state. The public API is just `allow`."*

### 2. Abstraction

Expose what the object does, hide how it does it. Your interviewer shouldn't need to know whether you're using a deque or a list inside.

**What to say:** *"From the caller's perspective, `allow(user, ts)` is atomic; they don't care whether I'm using a deque, a sorted list, or Redis ZSET underneath."*

### 3. Inheritance

Subclass reuses parent's code. Use when there's a clear "is-a" relationship. In Python:

```python
class Limiter:
    def allow(self, user_id, timestamp): raise NotImplementedError

class FixedWindowLimiter(Limiter):
    def allow(self, user_id, timestamp):
        ...

class SlidingWindowLimiter(Limiter):
    def allow(self, user_id, timestamp):
        ...
```

**When to use:** when 2+ variants share substantial code and have a clear base contract.

**When NOT to use:** when you just want to share utility methods. Prefer composition (below).

### 4. Polymorphism

Different classes implement the same method differently; caller doesn't care which one it has.

```python
limiters = [FixedWindowLimiter(10, 60), SlidingWindowLimiter(10, 60)]
for limiter in limiters:
    limiter.allow("user_1", 100)    # same call, different behavior
```

**What to say:** *"Both limiters implement the same `allow` contract, so the gateway can swap strategies without knowing which variant it holds."*

---

## Composition over inheritance (the senior instinct)

**Inheritance:** "A `SlidingWindowLimiter` IS-A `Limiter`."

**Composition:** "A `RateLimiter` HAS-A window strategy."

```python
# Inheritance approach (not always best)
class SlidingWindowLimiter(Limiter):
    def allow(self, user_id, timestamp):
        ...

# Composition approach (usually better)
class WindowStrategy:
    def evict_old(self, q, cutoff): raise NotImplementedError

class SlidingStrategy(WindowStrategy):
    def evict_old(self, q, cutoff):
        while q and q[0] <= cutoff:
            q.popleft()

class FixedStrategy(WindowStrategy):
    def evict_old(self, q, cutoff):
        if q and q[0] <= cutoff:
            q.clear()

class RateLimiter:
    def __init__(self, limit, window, strategy: WindowStrategy):
        self.limit = limit
        self.window = window
        self._strategy = strategy         # HAS-A, not IS-A
        self._events = defaultdict(deque)
    
    def allow(self, user_id, timestamp):
        q = self._events[user_id]
        self._strategy.evict_old(q, timestamp - self.window)
        if len(q) >= self.limit:
            return False
        q.append(timestamp)
        return True
```

**What to say when you compose:** *"I'm using composition here because the window behavior is a behavior of the rate limiter, not an identity of it. I can swap strategies without a new class hierarchy."*

Composition is almost always the right first instinct for senior interview signal. Use inheritance sparingly and only when there's a real "is-a" relationship.

---

## The design patterns that actually come up

There are 23 classic Gang-of-Four patterns. 90% of Google interviews that touch patterns only reference these 6. Memorize the name, shape, and when to use. Don't memorize full implementations.

### 1. Strategy

**What:** Encapsulate interchangeable algorithms. Caller picks one at runtime.

**Shape:** Interface + multiple implementations + a class that holds one.

**When asked to apply it:** "Now support both sliding window and fixed window." Solution: extract `WindowStrategy` interface, 2 implementations. Example above.

### 2. Factory

**What:** A function or method that creates objects, hiding the construction details.

**Shape:**

```python
def make_limiter(kind: str, limit: int, window: int):
    if kind == "sliding":
        return RateLimiter(limit, window, SlidingStrategy())
    if kind == "fixed":
        return RateLimiter(limit, window, FixedStrategy())
    if kind == "redis":
        return RedisLimiter(limit, window)
    raise ValueError(f"Unknown kind: {kind}")
```

**When asked to apply it:** "How would you configure this from a config file?" Factory translates config strings to object instances.

### 3. Singleton

**What:** A class with exactly one instance, globally accessible.

**Shape in Python (simpler than Java):**

```python
_instance = None
def get_rate_limiter():
    global _instance
    if _instance is None:
        _instance = RateLimiter(100, 60)
    return _instance
```

**When asked to apply it:** "There's only one connection pool; how do you ensure only one instance?" Singleton.

**Senior caveat to mention:** Singletons make testing harder (you can't easily mock global state) and create hidden coupling. Prefer dependency injection unless the global-ness is truly essential.

### 4. Observer / Pub-Sub

**What:** Object (subject) maintains a list of dependents (observers); state changes trigger notifications.

**Shape:**

```python
class EventBus:
    def __init__(self):
        self._subscribers = defaultdict(list)
    
    def subscribe(self, event_type: str, callback):
        self._subscribers[event_type].append(callback)
    
    def publish(self, event_type: str, payload):
        for cb in self._subscribers[event_type]:
            cb(payload)
```

**When asked to apply it:** "When rate limit is exceeded, alert the monitoring system AND log to audit AND bump a metric." All three are observers of the same event.

### 5. Decorator

**What:** Add behavior to an object without changing its class. In Python, functions too (with `@` syntax).

**Shape (function decorator):**

```python
def log_calls(func):
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__} with {args}")
        result = func(*args, **kwargs)
        print(f"  Returned: {result}")
        return result
    return wrapper

@log_calls
def allow(user_id, timestamp):
    ...
```

**When asked to apply it:** "Add logging to all rate-limiter calls without modifying the class." Decorate the `allow` method.

### 6. Iterator

**What:** Object that knows how to walk through a collection one element at a time.

**Shape in Python:**

```python
class ReverseIterator:
    def __init__(self, items):
        self._items = items
        self._index = len(items) - 1
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self._index < 0:
            raise StopIteration
        value = self._items[self._index]
        self._index -= 1
        return value

for x in ReverseIterator([1, 2, 3]):
    print(x)  # 3, 2, 1
```

**When asked to apply it:** "Walk through the events for a user without exposing the internal deque." Return a custom iterator.

---

## Class design follow-up questions and how to answer them

These are the questions Google interviewers actually ask after you finish the core class. Memorize the shape of each response.

### "How would you make this thread-safe?"

Say:

> I'd protect the critical section with a `threading.Lock`. The shared state is `_events`, so I'd acquire the lock at the top of `allow` and release on return. For high-contention scenarios I'd consider a reader-writer lock or a sharded lock (one lock per user bucket) to avoid global contention.

```python
import threading

class RateLimiter:
    def __init__(self, limit, window):
        ...
        self._lock = threading.Lock()
    
    def allow(self, user_id, timestamp):
        with self._lock:
            # critical section
            ...
```

### "How would you make this distributed across 5 servers?"

Say:

> In-memory state doesn't work across replicas. Three options: (1) sharded Redis ZSET per user with a Lua script for atomicity, which is the canonical answer; (2) a central coordinator service, which adds latency and is a SPOF; (3) accept eventual consistency with local limiters plus a global audit. I'd default to option 1.

### "How would you add TTL-based memory cleanup?"

Say:

> A background thread or scheduled task runs every N seconds and evicts any user whose most-recent event is older than the window. Alternatively, on every `allow` call I lazily check if the user's deque is empty after eviction and delete the entry. The TTL approach is cleaner for steady state; lazy cleanup handles bursty access better.

### "How would you test this class?"

Say:

> Unit tests for each state transition: empty user's first call returns True. Filling the deque to `limit` blocks the next call. Time-based eviction frees up a slot. Concurrent access (if thread-safe) produces consistent counts. I'd also write a property-based test that no user ever exceeds `limit` calls in any window of `window_seconds`.

### "How would you extend this for 10M users?"

Say:

> Three concerns at that scale. Memory: `dict` of 10M keys takes ~1GB; I'd switch to Redis or shard by user hash. CPU: single-process becomes a bottleneck; horizontal sharding by user ID. Skew: 80/20 rule means 2M users drive most traffic; I'd add a secondary cache for hot users.

### "How would you add a different rate-limit policy?"

This is the Strategy pattern in disguise. See above.

### "How would you persist state across restarts?"

Say:

> I'd serialize the `_events` dict periodically to Redis or disk, and load on startup. For strict durability I'd write to a WAL on every accept. For best-effort, a periodic snapshot (every 5 seconds) is fine since rate-limiter state being slightly stale after a crash is acceptable.

---

## When to mention these in Round 2

Don't force pattern vocabulary. But when your interviewer asks "now extend this to do X," reaching for the right pattern name signals senior-level design thinking. Rough mapping:

| Follow-up | Pattern to invoke |
|---|---|
| "Support multiple algorithms" | Strategy |
| "Configure from config file" | Factory |
| "Only one instance should exist" | Singleton (with caveats) |
| "Notify multiple systems when X happens" | Observer |
| "Add logging / retries / caching without changing the class" | Decorator |
| "Walk through the elements without exposing internals" | Iterator |
| "Hide construction complexity" | Factory / Builder |
| "Adapt one interface to another" | Adapter |

Memorize these 8 mappings. You'll recognize 90% of follow-ups.

---

## The 5-minute Python OOP refresher (in case you forgot)

### Class basics

```python
class Car:
    # Class variable (shared by all instances)
    wheels = 4
    
    # Constructor
    def __init__(self, brand, speed=0):
        self.brand = brand           # instance variable
        self.speed = speed
    
    # Instance method
    def accelerate(self, delta):
        self.speed += delta
        return self.speed
    
    # Class method (no self, has cls)
    @classmethod
    def default(cls):
        return cls("Generic")
    
    # Static method (no self, no cls)
    @staticmethod
    def is_valid_speed(s):
        return 0 <= s <= 300
    
    # Dunder method (called by Python itself)
    def __repr__(self):
        return f"Car(brand={self.brand!r}, speed={self.speed})"
```

### Key dunder methods

- `__init__`: constructor
- `__repr__`: debug representation. **Always add this for design problems.**
- `__str__`: user-facing string
- `__eq__(self, other)`: equality (requires `__hash__` if used in dict/set)
- `__lt__(self, other)`: less-than (for sorting, heaps)
- `__len__`: called by `len(obj)`
- `__iter__` + `__next__`: make the object iterable
- `__enter__` + `__exit__`: context manager (`with` block)

### Type hints you'll actually use

```python
from typing import Optional, List, Dict, Tuple

def lookup(key: str, store: Dict[str, int]) -> Optional[int]:
    return store.get(key)
```

---

## Cheat block for May 13 morning

Read these 5 rules once in the morning. Don't re-read the whole file.

1. **Composition over inheritance.** Default to `HAS-A`. Use `IS-A` sparingly.
2. **State the invariant aloud before coding.** Every class has a property that must always be true. Say it.
3. **Mark private state with underscore.** `self._events`, not `self.events`.
4. **For "extend this" follow-ups, reach for Strategy or Decorator.** 90% of the time one of those is the answer.
5. **For scale follow-ups, the answer shape is always:** identify the state, move it to Redis or shard it, add observability. Memory → Redis. CPU → shard. Skew → cache hot keys.

---

## How to use this file alongside `05a_CODING_SOLUTIONS.md`

`05a` gives you 5 fully worked classes (RateLimiter, LRU, TimeMap, HitCounter, Logger, FileSystem) with invariants, code, and bugs. This file gives you the meta-skills for extending them.

Typical Round 2 flow:
1. Interviewer gives you a class problem → solve using `05a` template.
2. Interviewer asks "now extend it" → reach for Strategy / Decorator / Observer.
3. Interviewer asks "scale this to 10M" → use the scale answer template above.

You need both files. `05a` is the foundation; this one is the bridge to senior signal.
