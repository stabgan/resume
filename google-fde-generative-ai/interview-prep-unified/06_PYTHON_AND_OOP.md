# Python Fluency + OOP

The coding round explicitly includes Python and OOP. This doc is your quick reference for language patterns, not a Python tutorial.

## Imports to memorize (write these first, every time)

```python
from collections import defaultdict, Counter, deque
import heapq
from functools import lru_cache
from typing import List, Optional, Dict, Tuple
```

90% of problems need nothing more.

## Python fluency checklist

Know these cold:

| Construct | When to use |
|---|---|
| `dict` | Key-value lookup |
| `defaultdict(list)` | Grouping (Group Anagrams) |
| `defaultdict(int)` | Counting when you want to avoid `dict.get(k, 0)` |
| `Counter` | Frequencies — `Counter(nums).most_common(k)` is elegant |
| `set` | Membership / visited / dedup |
| `deque` | Queues (BFS) and sliding windows |
| `heapq` | Top-k, scheduling, Dijkstra |
| `lru_cache(None)` | Memoizing recursive solutions (DP) |
| `bisect` | Binary search on sorted list |

### Avoid

- `list.pop(0)` — O(n). Use `deque.popleft()`.
- Mutable default arguments — `def f(x=[])` creates one shared list.
- Overly clever lambdas in `sorted(key=...)` — easy to misread on a Doc.
- One-line comprehensions that nest 3 levels — slow down the interviewer.

### Say this when using a specific choice

- *"I'm using `defaultdict(list)` to avoid the `dict.setdefault` dance."*
- *"`Counter` gives me frequency counts in one line."*
- *"`deque.popleft()` is O(1); `list.pop(0)` would be O(n)."*
- *"I'm using `bisect` here because the list stays sorted and I need O(log n) insert/lookup."*

Small language choices, confidently explained, read as senior.

## Data structure cheat sheet

### List
- Ordered, indexable, mutable.
- Good for: two pointers, prefix sums, binary search, DP arrays.
- Pitfalls: mutating while iterating; confusing index vs. value.

### String
- Immutable in Python. Build output with `list` + `"".join(list)`.
- Patterns: character frequency, sliding window, stack for parens, expand-around-center for palindromes, prefix encoding.

### Hash map / set
- Questions to ask before using one:
  - What is the key?
  - What is the value?
  - When do you update?
  - Can duplicates change the answer?

### Stack
- Use for: parens, monotonic next-greater, DFS iterative, parsing, undo.
- Template:
  ```python
  stack = []
  for x in items:
      while stack and should_pop(stack[-1], x):
          stack.pop()
      stack.append(x)
  ```

### Queue / deque
- Use for: BFS, sliding windows, rate limiter, level-order traversal.
- `deque.popleft()` is O(1); that's the point.

### Heap (min-heap in Python)
- `heapq.heappush(heap, x)` / `heapq.heappop(heap)`.
- For max-heap: push `-x`, negate on pop.
- Top-k:
  ```python
  heap = []
  for num in nums:
      heapq.heappush(heap, num)
      if len(heap) > k:
          heapq.heappop(heap)
  # heap now has k largest
  ```

## OOP class-design protocol (say this aloud when the question starts)

> I'll first define the internal state and the invariant, then implement each method around that invariant.

Then:

1. **Clarify operations.** What methods? Any constraints?
2. **Clarify complexity target.** O(1) or O(log n) per operation?
3. **Identify state.** What data structures? Why each?
4. **State the invariant.** The property that's always true.
5. **Implement each method** to preserve the invariant.
6. **Dry-run a method sequence.**
7. **Production concerns:** concurrency, memory cleanup, scale.

## The 3 OOP patterns to memorize

### Pattern 1: Map + Queue (RateLimiter, LoggerRateLimiter, HitCounter)

Invariant: per key, only timestamps within the active window are stored.

```python
from collections import defaultdict, deque

class RateLimiter:
    def __init__(self, limit: int, window_seconds: int) -> None:
        if limit <= 0 or window_seconds <= 0:
            raise ValueError("limit and window_seconds must be positive")
        self.limit = limit
        self.window = window_seconds
        self._events: dict[str, deque[int]] = defaultdict(deque)

    def allow(self, user_id: str, timestamp: int) -> bool:
        q = self._events[user_id]
        cutoff = timestamp - self.window

        while q and q[0] <= cutoff:
            q.popleft()

        if len(q) >= self.limit:
            return False

        q.append(timestamp)
        return True
```

Same signature as `04_CODING_PROTOCOL.md`, `05a_CODING_SOLUTIONS.md` problem 07, and `14_NARRATED_WALKTHROUGHS.md` walkthrough 1. Drill one spelling.

Production discussion:
- Memory: evict inactive users via TTL or LRU.
- Distributed: Redis ZSET with a Lua script for atomicity; avoids the cross-replica race.
- Token bucket for smoother traffic.
- Clock skew between distributed nodes.

### Pattern 2: Map + Doubly Linked List (LRU Cache)

Invariant: dict gives O(1) key→node lookup; list order gives recency. Head = most recent, tail = least recent.

```python
class Node:
    def __init__(self, key, value):
        self.key = key
        self.value = value
        self.prev = None
        self.next = None

class LRUCache:
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.map = {}
        self.head = Node(0, 0)  # sentinel
        self.tail = Node(0, 0)  # sentinel
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev

    def _add_to_front(self, node):
        node.next = self.head.next
        node.prev = self.head
        self.head.next.prev = node
        self.head.next = node

    def get(self, key: int) -> int:
        if key not in self.map:
            return -1
        node = self.map[key]
        self._remove(node)
        self._add_to_front(node)
        return node.value

    def put(self, key: int, value: int):
        if key in self.map:
            self._remove(self.map[key])
        node = Node(key, value)
        self._add_to_front(node)
        self.map[key] = node
        if len(self.map) > self.capacity:
            lru = self.tail.prev
            self._remove(lru)
            del self.map[lru.key]
```

If short on time during the interview: **say the invariant aloud first**, then code. Interviewers often care more that you know *why* dict alone is insufficient than that you typed every method.

### Pattern 3: Map + Sorted List with Binary Search (TimeMap)

Invariant: per key, store (timestamp, value) in append-only sorted order. Lookup uses binary search for the latest timestamp ≤ query.

```python
from collections import defaultdict
import bisect

class TimeMap:
    def __init__(self):
        self.store = defaultdict(list)  # key -> list of (timestamp, value)

    def set(self, key: str, value: str, timestamp: int):
        self.store[key].append((timestamp, value))

    def get(self, key: str, timestamp: int) -> str:
        if key not in self.store:
            return ""
        entries = self.store[key]
        idx = bisect.bisect_right(entries, (timestamp, chr(127)))
        if idx == 0:
            return ""
        return entries[idx - 1][1]
```

## Other useful class patterns (all fully solved in `05a_CODING_SOLUTIONS.md`)

| Class | Key data structure | Solution location |
|---|---|---|
| `MinStack` | Two stacks (values + running mins) | `05a` problem 23 |
| `TimeMap` | Per-key sorted list + `bisect` | `05a` problem 24 |
| `HitCounter` | Deque of hit timestamps, sliding 300s window | `05a` problem 25 |
| `Logger` (LC #359) | Map of message to next-allowed timestamp | `05a` problem 26 |
| `FileSystem` (LC #588) | Trie of `_Node` with `__slots__`, `_walk` helper | `05a` problem 27 |
| `Trie` (prefix tree) | Nested dict `{char: {...}}` | Not pre-solved; pattern in `04_CODING_PROTOCOL.md` |
| `UnionFind` | Parent array with path compression | Not pre-solved |
| `RandomizedSet` | List + map (for O(1) random removal) | Not pre-solved |

When an interviewer leads you toward one of the first five, the solution is pre-drilled; just say the invariant aloud, then reproduce from memory.

## Idiom reference

### Iterating with index
```python
for i, value in enumerate(nums):
    ...
```

### Iterating a dict
```python
for key, value in d.items():
    ...
```

### Sorting with custom key
```python
arr.sort(key=lambda x: (x[0], -x[1]))  # ascending x[0], descending x[1]
```

### Tuple unpacking
```python
left, right = 0, len(nums) - 1
x, y = point
```

### Default dict idiom
```python
groups = defaultdict(list)
for word in words:
    key = tuple(sorted(word))
    groups[key].append(word)
return list(groups.values())
```

### Counter shortcuts
```python
c = Counter(nums)
most_common = c.most_common(k)       # list of (num, count) tuples
single_count = c[x]                   # 0 if missing, no KeyError
```

### Min/max over dict
```python
best_key = max(counter, key=counter.get)   # key with max count
```

### Early return — ASCII-clean
```python
if not nums:
    return 0
```

## Common Python bugs (rehearse these so you don't make them)

1. Mutating list while iterating:
   ```python
   # BUG
   for x in nums:
       if bad(x):
           nums.remove(x)
   # FIX
   nums = [x for x in nums if not bad(x)]
   ```

2. Nested DFS counter without `nonlocal`:
   ```python
   def count_paths(root):
       total = 0
       def dfs(node):
           nonlocal total     # <-- easy to forget
           if not node: return
           if valid(node): total += 1
           dfs(node.left)
           dfs(node.right)
       dfs(root)
       return total
   ```

3. Off-by-one in binary search: pick `while left <= right` with `return -1` at the end and stick to it.

4. Returning the tree node instead of its `.val`:
   ```python
   # BUG
   return dfs(root.left)
   # FIX
   return dfs(root.left).val if dfs(root.left) else None
   ```

5. Missing `visited.add` before recursion in DFS grid.

6. Forgetting to remove from `visited` in backtracking (unlike DFS, backtracking often needs to un-mark).

## Python-specific things to mention when useful

Saying these shows fluency without being showy:

- *"Python lists are dynamic arrays, so appends are amortized O(1)."*
- *"Dicts are insertion-ordered since Python 3.7."*
- *"`heapq` is a min-heap; for a max-heap I push negatives."*
- *"I'm using `defaultdict` to avoid the `KeyError` check."*
- *"`bisect.bisect_right` vs. `bisect_left` matters when there are duplicates."*

## Type hints — when to use them

Use type hints on function signatures. They help you think, help the interviewer read your code, and take 5 seconds to add:

```python
def two_sum(nums: List[int], target: int) -> List[int]:
    ...

def add_node(self, key: int, value: int) -> None:
    ...
```

Skip type hints inside the function body — they slow you down and don't add much.

## What NOT to do in Python during the round

- Don't use walrus `:=` unless it genuinely simplifies the code.
- Don't use `itertools` for common problems — interviewers want to see you write the logic.
- Don't use `functools.reduce` — a for-loop reads clearer.
- Don't use `*args, **kwargs` unless the problem demands it.
- Don't write a decorator unless they ask for one.
