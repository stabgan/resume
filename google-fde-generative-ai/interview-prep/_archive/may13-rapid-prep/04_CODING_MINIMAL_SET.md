# Coding Minimal Set - 22 Problems, No-Run Python

The recruiter PDF says the coding round is 60 minutes, LeetCode/HackerRank style, includes OOP, expects 30-50 lines of Python, and you will not run/deploy the code.

So the goal is:

- Recognize the pattern fast.
- Write clean Python without execution.
- Dry-run edge cases out loud.
- Fix bugs by reasoning, not by interpreter.

This is not a 50-hard grind.

## The 40-Minute Interview Protocol

Use this every time.

### 0:00-0:03 - Clarify

Say:

> Let me restate the problem and clarify input size, edge cases, and expected output.

Ask:

- Can input be empty?
- Are values unique?
- Can values be negative?
- Is input sorted?
- Return index or value?
- What is the expected scale?
- Should I optimize for time or memory?

### 0:03-0:08 - Approach

Say:

> Brute force would be X. I think we can do Y using Z data structure, which gives time A and space B.

Do not code until you can state the invariant.

### 0:08-0:28 - Code

Rules:

- Use meaningful names.
- Keep functions small.
- Avoid clever Python tricks.
- Include helper functions only if they simplify reasoning.
- Speak while coding.

### 0:28-0:36 - Dry Run

Dry-run:

- One normal case.
- One edge case.
- One case that might break your invariant.

Write variable state in the shared editor if helpful.

### 0:36-0:40 - Optimize And Test

Say:

> I would add tests for empty input, single element, duplicates, and the boundary case that drives this algorithm.

## If You Get Stuck

Use one of these:

- "Let me step back and identify the invariant."
- "Let me try a brute force first, then optimize."
- "This feels like a graph because states are connected by transitions."
- "This feels like a sliding window because the answer is contiguous."
- "This feels like binary search because the condition is monotonic."
- "Let me dry-run the example manually to see the state I need."

Never apologize for being rusty.

## Python Templates To Memorize

### Hash Map

```python
def solve(nums):
    seen = {}
    for i, value in enumerate(nums):
        if value in seen:
            return seen[value], i
        seen[value] = i
    return None
```

### Sliding Window

```python
def solve(s):
    left = 0
    window = {}
    best = 0

    for right, ch in enumerate(s):
        window[ch] = window.get(ch, 0) + 1
        while window_is_invalid(window):
            old = s[left]
            window[old] -= 1
            if window[old] == 0:
                del window[old]
            left += 1
        best = max(best, right - left + 1)

    return best
```

### BFS

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

### DFS Grid

```python
def dfs(r, c):
    if r < 0 or r == rows or c < 0 or c == cols:
        return
    if grid[r][c] != "1" or (r, c) in visited:
        return

    visited.add((r, c))
    for dr, dc in directions:
        dfs(r + dr, c + dc)
```

### Binary Search

```python
def binary_search(nums, target):
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

### OOP Skeleton

```python
class RateLimiter:
    def __init__(self, limit, window_seconds):
        self.limit = limit
        self.window = window_seconds
        self.events = {}

    def allow(self, user_id, timestamp):
        if user_id not in self.events:
            self.events[user_id] = []

        cutoff = timestamp - self.window
        recent = [t for t in self.events[user_id] if t > cutoff]
        self.events[user_id] = recent

        if len(recent) >= self.limit:
            return False

        recent.append(timestamp)
        return True
```

## The 22-Problem Set

Do these in order if possible. If time is short, do the first 12 and the OOP set.

| # | Problem | Pattern | Why It Is Here |
|---|---|---|---|
| 1 | Two Sum | Hash map | Fast warmup, index/value clarity |
| 2 | Two Sum II | Two pointers | Sorted invariant |
| 3 | 3Sum | Two pointers | Duplicate handling |
| 4 | Longest Substring Without Repeating Characters | Sliding window | Most important string/window pattern |
| 5 | Minimum Window Substring | Sliding window | Hardest high-yield window |
| 6 | Group Anagrams | Hashing | Clean grouping |
| 7 | Top K Frequent Elements | Hashing/heap | Counter plus heap/bucket tradeoff |
| 8 | Binary Search | Binary search | Template fluency |
| 9 | Search In Rotated Sorted Array | Binary search | Google classic |
| 10 | Valid Parentheses | Stack | OOP/string warmup |
| 11 | Encode And Decode Strings | String design | 30-line practical coding |
| 12 | LRU Cache | OOP/design | Class design, hash map, linked list |
| 13 | Rate Limiter | OOP/design | Very plausible Google-style practical problem |
| 14 | Binary Tree Level Order Traversal | BFS | Tree traversal |
| 15 | Lowest Common Ancestor | DFS recursion | Tree invariant |
| 16 | Number Of Islands | Graph/grid DFS | Essential graph pattern |
| 17 | Course Schedule | Graph/topological | Dependencies and cycle detection |
| 18 | Kth Largest Element | Heap/quickselect | Top-k thinking |
| 19 | Merge Intervals | Sorting | Interval pattern |
| 20 | Subsets | Backtracking | Recursive generation |
| 21 | Coin Change | 1-D DP | Minimal DP coverage |
| 22 | Word Search | Backtracking/grid | Combines DFS and state |

## The 12-Problem Emergency Set

If interviews move earlier:

1. Two Sum.
2. Longest Substring Without Repeating Characters.
3. Group Anagrams.
4. Search In Rotated Sorted Array.
5. Valid Parentheses.
6. Encode And Decode Strings.
7. Rate Limiter.
8. Binary Tree Level Order.
9. Number Of Islands.
10. Course Schedule.
11. Kth Largest Element.
12. Coin Change.

## OOP Problems To Practice

### 1. Rate Limiter

Prompt:

> Implement a rate limiter with `allow(user_id, timestamp)` that permits at most N requests per user in a rolling window.

Expected design:

- Class with constructor.
- Dictionary: user_id -> queue/list of timestamps.
- Remove timestamps outside window.
- Return boolean.

Edge cases:

- First request.
- Exactly at boundary.
- Multiple users.
- Many stale events.

Optimization discussion:

- Use `deque` per user to avoid list filtering.
- Clean inactive users in production.

### 2. LRU Cache

Prompt:

> Implement `get(key)` and `put(key, value)` in O(1).

Expected design:

- Dictionary key -> node.
- Doubly linked list for recency.
- Move on get/put.
- Evict tail when capacity exceeded.

If too long:

> I can write the full linked-list implementation, but first I will outline the invariant: head is most recent, tail is least recent, map points to nodes, every access moves node to head.

### 3. Encode And Decode Strings

Prompt:

> Encode a list of strings into one string and decode it back.

Expected design:

- Length prefix: `len + "#" + value`.
- Decode by reading digits until `#`, then consume length.

Edge cases:

- Empty string.
- String containing `#`.
- Multi-digit lengths.

## Pattern Recognition Cheat Sheet

- Contiguous subarray/substring: sliding window.
- Pair/triplet in sorted input: two pointers.
- Need fast membership/count/grouping: hash map/set.
- Sorted or monotonic condition: binary search.
- Nested dependency/cycle: graph/topological sort.
- Grid connected components: DFS/BFS.
- Top/bottom K: heap or quickselect.
- Generate all valid combinations: backtracking.
- Min/max ways over choices: DP.
- Recent/frequent/history class behavior: OOP + dict + queue/list.

## What To Say About Complexity

Keep it crisp:

- "Time is O(n) because each element enters and leaves the window once."
- "Space is O(k), where k is the number of distinct characters in the window."
- "The heap stays size k, so time is O(n log k)."
- "DFS visits each cell once, so O(rows * cols)."
- "Topological sort is O(V + E)."

## Test Case Habit

For every problem, name tests:

- Empty input.
- Single element.
- Duplicate values.
- Boundary size.
- No solution.
- All same.
- Negative numbers if numeric.
- Already sorted/reverse sorted if ordering matters.

## Common Python Bugs To Avoid

- Mutating a list while iterating over it.
- Forgetting `nonlocal` for nested DFS counters.
- Using `list.pop(0)` instead of `deque.popleft()`.
- Off-by-one in binary search.
- Sharing mutable default arguments.
- Forgetting to remove from `visited` in backtracking.
- Returning node instead of node value in tree problems.
- Confusing index and value in Two Sum.

## The Interviewer Should Hear This

Strong coding candidates sound like this:

> I will start with a straightforward correct solution and then optimize. The key invariant is...

> Let me dry-run the boundary case before claiming this works.

> If I could run this, the first tests I would add are...

> The tradeoff is O(n) memory for O(n) time.

Say these naturally. They are more important than solving an extra hard problem.
