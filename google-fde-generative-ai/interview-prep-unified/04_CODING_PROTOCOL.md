# Coding Protocol — Virtual Interview Platform, No Execution

## The exact environment you'll face

There's a conflict between two sources on the coding environment. Believe neither exclusively; prep for both.

**Recruiter's PDF (official):**
- "Virtual Interview Platform that provides formatting/syntax highlighting."
- "You will not be running / deploying the code."
- 30–50 lines of Python.
- Object-oriented programming is in scope.

**Priyanka (your recruiter, by email):**
- Plain Google Doc, whiteboard-style.
- No IDE features.

**Action:** send Priyanka a confirmation email before May 13 with this exact line: *"Quick confirmation on the coding environment — will it be a plain Google Doc or a virtual coding platform with syntax highlighting? The PDF mentions one, you mentioned the other, so I want to match my warmup exactly."*

**Until you hear back, practice on a plain Google Doc.** If the real environment has syntax highlighting, that's a bonus, not a blocker. If it's plain Doc, you're already calibrated.

## Why this environment is hard (and what to train against)

| Challenge | Counter-practice |
|---|---|
| May be no autocomplete — remember exact imports | Memorize the 6 Python imports below |
| May be no indentation helper — easy to misalign nested blocks | Type `for/while/if` with 4-space indent on a Doc until it's automatic |
| No run — can't see output | Dry-run mentally; track variable state as text on the Doc |
| Limited find/replace | Pick variable names carefully before typing; don't improvise |
| No syntax check — typo ships silently | Slow down. Speak each line as you type it. |

## The 6 imports you must memorize

```python
from collections import defaultdict, Counter, deque
import heapq
from functools import lru_cache
from typing import List, Optional
```

That's it. 90% of coding problems use nothing beyond this.

## Pre-interview muscle-memory priming

Before any coding round or Pramp mock, spend **30 seconds** on this:

1. Open a blank Google Doc.
2. Type these 3 lines verbatim:
   ```python
   def solve(nums: List[int]) -> int:
       left, right = 0, len(nums) - 1
       while left <= right:
           mid = (left + right) // 2
   ```
3. Fingers remember the Doc is not auto-indenting or auto-completing. You save yourself from "wait, how do I type `:` then tab here?" during the real round.

Do this **every single morning of the 11-day prep.**

## The 40-minute protocol (use it every problem, every time)

```
 0:00 – 0:03   CLARIFY        Restate the problem. Ask input shape, size,
                              edge cases, expected output. Out loud.

 0:03 – 0:08   APPROACH       Propose one idea. State time + space complexity.
                              If brute force: "O(n²). Can we do better?" Then
                              propose the optimized approach.

 0:08 – 0:28   CODE           Write clean Python. Say each line aloud as you
                              type it. Use meaningful variable names.

 0:28 – 0:35   DRY-RUN        Walk through 2 test cases by hand. Write
                              variable state as strings ON THE DOC below the
                              code. Yes, in text. The interviewer watches.

 0:35 – 0:40   DISCUSS        Trade-offs. What if N were 10⁹? Memory bounds?
                              What tests would I add in production?
```

Hard cap: 30 min to working code. If you're stuck at 20 min with no solution, say aloud *"Let me step back and identify the invariant"* and reset.

## The 10 phrases that signal senior-level thinking

Use these naturally across the round. Don't script them, but know they're your tools.

1. *"Let me restate the problem so I make sure I understand."*
2. *"What's the expected size of N?"*
3. *"Can I assume the input is valid, or do I need to handle bad input?"*
4. *"The brute force is O(n²). Let me think about whether we can do better."*
5. *"I'm going to use a hash map here to get O(1) lookup — the trade-off is O(n) extra space."*
6. *"Let me walk through an edge case first to make sure my approach handles it."*
7. *"I'll skip imports / boilerplate for now and focus on the logic — we can add them at the end."* (saves 30 seconds, signals senior judgment)
8. *"Before I write more, let me dry-run what I have."*
9. *"If N were 10⁹ instead of 10⁵, I'd switch to X."*
10. *"One thing I'd add in production: a test for the empty-input case."*

## The 5 classic failure modes (don't do these)

| Don't | Instead |
|---|---|
| Silent typing for 5 min | Narrate. Even `"hmm, I'm thinking about whether to use a hash map or a sorted list"` beats silence. |
| Single-letter variables (`l`, `r`, `a`) | `left`, `right`, `nums`, `graph`. Plain Docs make short names ambiguous. |
| Fixing syntax errors 30 lines in | Think in full before writing. Talk out the whole approach first. |
| Skipping the dry-run | Always. Always dry-run two cases. It's what senior engineers do. |
| Apologizing | Never. Not once. Not for being rusty, not for using AI tools daily, not for a typo. |

## If you freeze mid-interview

1. **Acknowledge:** *"Let me pause for 30 seconds and think about this."*
2. **Restate:** *"So I have X input, I need Y output, I've been trying approach Z."*
3. **Narrow a question:** *"Can I assume the list is sorted, or would I need to sort it first?"*

Interviewers expect pauses. They reward structured pauses. They penalize silent panic.

## If asked "do you use AI for coding?"

Answer honestly and briefly, don't apologize:

> Yes, heavily. I treat it like a staff engineer pairing with me — it handles boilerplate and scaffolding so I can spend my time on architecture, trade-offs, and edge cases. For this interview I've been practicing without it to make sure the fundamentals are sharp.

Move on. Don't linger on this topic.

## OOP — the class-design expectation

The recruiter PDF explicitly mentions OOP. Expect one of the two coding questions to be class-design. Use this protocol for class questions:

1. Clarify the operations (e.g., for `RateLimiter`: `allow(user_id, timestamp)` — anything else?).
2. Clarify complexity target.
3. Identify **internal state**.
4. Identify **invariants** (the thing that must always be true).
5. Implement each method around that invariant.
6. Dry-run a method sequence.
7. Discuss production concerns: concurrency, cleanup, scale.

Say:

> I'll first define the internal state and the invariant, then implement each method around that invariant.

Then code. Interviewers love this opening.

## OOP templates to memorize (3 patterns cover most questions)

### Pattern 1: Map + Queue (rate limiter, logger, hit counter)

Invariant: **for each key, only timestamps within the active window are stored.**

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

This signature is identical to the one in `05a_CODING_SOLUTIONS.md` and the walkthrough in `14_NARRATED_WALKTHROUGHS.md`. Drill one spelling.

Production discussion points:
- Memory cleanup for inactive users (evict via TTL or LRU).
- Distributed rate limiting needs Redis or sharded counters (Redis ZSET + Lua script for atomicity is the canonical Google-answer pattern).
- Token bucket for smoother traffic profile.
- Clock skew between distributed nodes.

### Pattern 2: Map + Doubly Linked List (LRU Cache)

Invariant: **dict gives O(1) key→node lookup; list order gives recency. Head = most recent, tail = least recent.**

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
        # Sentinel nodes simplify edge cases
        self.head = Node(0, 0)
        self.tail = Node(0, 0)
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

If you're short on time during the interview, state the invariant out loud first and then code. Interviewers often care whether you know *why* a dict alone is insufficient more than whether you type the whole class.

### Pattern 3: Map + Sorted List (TimeMap, versioned store)

Invariant: **per key, store (timestamp, value) in append-only sorted order. Lookup uses binary search for the latest timestamp ≤ query.**

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
        # Find rightmost entry with timestamp <= target
        idx = bisect.bisect_right(entries, (timestamp, chr(127)))
        if idx == 0:
            return ""
        return entries[idx - 1][1]
```

## Algorithm templates (memorize these 6)

### Hash map (Two Sum pattern)

```python
def two_sum(nums: List[int], target: int) -> List[int]:
    seen = {}
    for i, value in enumerate(nums):
        complement = target - value
        if complement in seen:
            return [seen[complement], i]
        seen[value] = i
    return []
```

### Sliding window

```python
def longest_unique(s: str) -> int:
    left = 0
    window = {}
    best = 0

    for right, ch in enumerate(s):
        window[ch] = window.get(ch, 0) + 1
        while window[ch] > 1:
            old = s[left]
            window[old] -= 1
            if window[old] == 0:
                del window[old]
            left += 1
        best = max(best, right - left + 1)

    return best
```

### BFS (level-order, grid, shortest path)

```python
from collections import deque

def bfs(start):
    queue = deque([start])
    visited = {start}

    while queue:
        node = queue.popleft()
        for nxt in neighbors(node):
            if nxt not in visited:
                visited.add(nxt)
                queue.append(nxt)
```

### DFS (trees, graphs, grid)

```python
def dfs(r: int, c: int):
    if r < 0 or r == rows or c < 0 or c == cols:
        return
    if grid[r][c] != "1" or (r, c) in visited:
        return

    visited.add((r, c))
    for dr, dc in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
        dfs(r + dr, c + dc)
```

### Binary search (template — pick one, stick with it)

```python
def binary_search(nums: List[int], target: int) -> int:
    left, right = 0, len(nums) - 1

    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target:
            return mid
        if nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return -1
```

### Top-K heap

```python
import heapq

def top_k(nums: List[int], k: int) -> List[int]:
    heap = []
    for num in nums:
        heapq.heappush(heap, num)
        if len(heap) > k:
            heapq.heappop(heap)
    return heap  # contains k largest
```

## What to say about complexity

Keep it crisp:
- *"Time is O(n) because each element enters and leaves the window at most once."*
- *"Space is O(k), where k is the number of distinct characters in the window."*
- *"The heap stays size k, so time is O(n log k)."*
- *"DFS visits each cell once, so O(rows × cols)."*
- *"Topological sort is O(V + E)."*

## Common Python bugs to avoid

- Mutating a list while iterating over it.
- Forgetting `nonlocal` for nested DFS counters.
- Using `list.pop(0)` instead of `deque.popleft()` (the first is O(n), the second O(1)).
- Off-by-one in binary search (`while left <= right` vs. `left < right`).
- Shared mutable default arguments (`def f(x=[])`).
- Forgetting to remove from `visited` in backtracking.
- Returning the tree node instead of its value.
- Confusing index and value in Two Sum.

## Test-case habit

For every problem, name these tests (say them aloud even if you don't type them):

- Empty input.
- Single element.
- All duplicates.
- Boundary size.
- No solution.
- All same.
- Negative numbers (if numeric).
- Already sorted / reverse sorted (if order matters).

## What the interviewer hears from a strong candidate

> I'll start with a straightforward correct solution and then optimize. The key invariant is that left and right pointers never cross except when the array is exhausted.

> Let me dry-run the boundary case before claiming this works.

> If I could run this, the first tests I'd add are empty input and single element.

> The tradeoff here is O(n) memory for O(n) time; if memory were tight I'd pivot to the two-pass version.

These phrases matter more than solving one extra problem. **Practice them out loud.**

## What Google's own interviewers look for (from the PDF-linked coding demo video)

The recruiter PDF links to the official Google Careers video "How to: Work at Google — Example Coding/Engineering Interview." Full transcript in `_transcripts/coding_interview.txt`. The canonical good signals the Google interviewer (Becky) calls out at the end, in order:

1. **Clarification before coding.** "Could they be negative? Floating point? Repeating elements?" Your clarification block already models this.
2. **Think out loud constantly.** "Thinking out loud is probably the best thing you can do... it lets the interviewee see your thought process and course-correct or ask follow-ups that help you demonstrate knowledge further."
3. **Talk before you write.** The example candidate went through two iterations (brute force → binary search → two-pointer → hash map) purely verbally before typing anything. Don't type the first version that comes to mind.
4. **Test in real time.** "If your interviewer doesn't give you an example, make one up. Test your solution. Think about edge cases (empty input, etc.) and bring them up."
5. **Handle the distractor.** The interviewer ends with "now assume the input is not sorted" — this is the standard Google move. Have a pivot ready.

Your `40-minute protocol` above maps 1:1 onto this. The only addition worth making on May 12 night: watch the 25-minute video once at 1.5x to hear the cadence, not to memorize the answer.

## Emergency rescue moves if you're lost

- *"Let me step back and identify the invariant."*
- *"Let me try brute force first, then optimize."*
- *"This feels like a graph because states are connected by transitions."*
- *"This feels like a sliding window because the answer is contiguous."*
- *"This feels like binary search because the condition is monotonic."*
- *"Let me dry-run the example manually to see the state I need."*

Never apologize. Just say one of these and keep going.
