# DSA Recovery — 30 Problems, 10 Patterns, 2 Weeks

For a senior engineer who's rusty, not a new grad. The premise: you already know how to code. You've just lost pattern recognition and the muscle memory of typing without an IDE.

## The rules

1. **Pattern first, volume second.** 30 deeply understood problems > 200 skimmed.
2. **Plain text editor only.** Google Doc, no syntax highlighting, no linting, no autocomplete. This is what Round 2 runs on.
3. **Talk while you type.** If you can't explain your approach in 30 seconds before writing, you don't have one yet.
4. **30 min hard cap per problem.** If you're stuck at 20 min, look up the pattern (not the solution). Code it. Move on.
5. **Redo problems 24–48 hours later.** The goal is pattern recognition, which comes from spaced repetition.

## Why 30 problems and not 100?

At 5+ years of Python production experience, you don't need to learn algorithms. You need to **recognize** the pattern fast and **execute** without an IDE. Three problems per pattern is enough to rebuild recognition. Google's 2025 interview analysis shows ~10 patterns cover 80%+ of questions. Cover each cold.

---

# The 10 patterns (Days 2–12)

For each pattern: **why it exists**, the **signature signal** to recognize it, and **3 problems** ordered easy → medium → medium-hard.

---

## Pattern 1 — Arrays + Two Pointers *(Day 2)*

**Why it exists:** sorted or near-sorted arrays give you a second pointer to move intelligently.

**Signal:** "sorted array", "find pair/triplet", "in-place", "palindrome".

**Approach template:**
```
left, right = 0, len(arr) - 1
while left < right:
    # compute something with arr[left] and arr[right]
    if condition:
        left += 1  # or right -= 1
    else:
        ...
```

| # | Problem | LC | Why |
|---|---|---|---|
| 1 | Two Sum II — Sorted Array | 167 | Canonical two-pointer |
| 2 | 3Sum | 15 | Two-pointer inside a loop; duplicate handling |
| 3 | Trapping Rain Water | 42 | Two-pointer with state (max_left, max_right) |

---

## Pattern 2 — Sliding Window *(Day 3)*

**Why:** contiguous subarrays/substrings; avoid O(n²) brute force by shrinking/expanding a window.

**Signal:** "longest/shortest subarray or substring satisfying X", "exactly K distinct".

**Template:**
```
left = 0
for right in range(len(s)):
    # expand: add s[right] to window state
    while window_is_invalid():
        # shrink from left
        left += 1
    # record answer using current window
```

| # | Problem | LC | Why |
|---|---|---|---|
| 4 | Longest Substring Without Repeating Characters | 3 | Classic; hash set for window state |
| 5 | Longest Repeating Character Replacement | 424 | Window with "k replacements allowed" twist |
| 6 | Minimum Window Substring | 76 | The hardest sliding window; most Google-asked |

---

## Pattern 3 — Hashing *(Day 4)*

**Why:** O(1) lookup beats O(n) scan; the workhorse pattern.

**Signal:** "pairs/groups with property X", "count occurrences", "find anagrams", "first/last unique".

**Template:** `dict` or `Counter` — know when each helps. Python's `defaultdict(list)` for grouping.

| # | Problem | LC | Why |
|---|---|---|---|
| 7 | Group Anagrams | 49 | Canonical dict-of-lists grouping |
| 8 | Top K Frequent Elements | 347 | Counter + heap (or bucket sort) |
| 9 | Longest Consecutive Sequence | 128 | Set-based O(n) — clever, and a common Google asker |

---

## Pattern 4 — Binary Search *(Day 5)*

**Why:** O(log n) when the space is monotonic; comes up more than you'd think.

**Signal:** "sorted and find", "minimum X such that Y", any "search in sorted-then-rotated".

**Template:** Know both "first index where condition is true" and "last index where condition is true". Most bugs live in the `while left <= right` vs `while left < right` choice. Pick one and stick with it.

```
left, right = 0, len(arr) - 1
while left <= right:
    mid = (left + right) // 2
    if arr[mid] == target: return mid
    elif arr[mid] < target: left = mid + 1
    else: right = mid - 1
return -1
```

| # | Problem | LC | Why |
|---|---|---|---|
| 10 | Binary Search | 704 | Rebuild the muscle memory on the template |
| 11 | Search in Rotated Sorted Array | 33 | Classic Google question |
| 12 | Find Minimum in Rotated Sorted Array | 153 | Variant — know both |

---

## Pattern 5 — Trees (DFS + BFS) *(Day 8)*

**Why:** recursion on trees is the foundation for most tree problems; iterative is cleaner when you need level info.

**Signal:** "binary tree", "BST", "path", "level", "lowest common ancestor".

**Templates you MUST know cold:**
```python
# Recursive DFS
def dfs(node):
    if not node: return ...
    left = dfs(node.left)
    right = dfs(node.right)
    return combine(node.val, left, right)

# BFS (iterative, level-order)
from collections import deque
queue = deque([root])
while queue:
    for _ in range(len(queue)):  # level-by-level
        node = queue.popleft()
        # process
        if node.left: queue.append(node.left)
        if node.right: queue.append(node.right)
```

| # | Problem | LC | Why |
|---|---|---|---|
| 13 | Binary Tree Level Order Traversal | 102 | Canonical BFS |
| 14 | Lowest Common Ancestor | 236 | Canonical recursion |
| 15 | Binary Tree Maximum Path Sum | 124 | Postorder with "return value vs. update global" — trips people up |

---

## Pattern 6 — Graphs (BFS / DFS / Topological) *(Day 9)*

**Why:** most problems hide a graph — grids, dependencies, word ladders. Once you see it, BFS/DFS solves it.

**Signal:** "grid", "connections", "cycle", "dependencies", "can you reach".

**Two grid templates (memorize):**
```python
rows, cols = len(grid), len(grid[0])
visited = set()
for r in range(rows):
    for c in range(cols):
        if (r, c) not in visited and grid[r][c] == '1':
            # dfs or bfs from here

directions = [(0,1), (0,-1), (1,0), (-1,0)]
def dfs(r, c):
    if (r,c) in visited or not (0 <= r < rows and 0 <= c < cols) or grid[r][c] != '1':
        return
    visited.add((r,c))
    for dr, dc in directions:
        dfs(r+dr, c+dc)
```

| # | Problem | LC | Why |
|---|---|---|---|
| 16 | Number of Islands | 200 | Canonical DFS/BFS on grid |
| 17 | Course Schedule | 207 | Canonical topological sort |
| 18 | Word Ladder | 127 | BFS on implicit graph (strings); classic Google |

---

## Pattern 7 — Top K / Heap *(Day 10)*

**Why:** when you need K largest/smallest from a stream or large dataset.

**Signal:** "top K", "K closest", "K smallest", "merge K sorted", "running median".

**Template (Python uses min-heap; use negatives for max-heap):**
```python
import heapq

# Top K largest: keep a min-heap of size K
heap = []
for num in nums:
    heapq.heappush(heap, num)
    if len(heap) > k:
        heapq.heappop(heap)
return heap  # contains K largest
```

| # | Problem | LC | Why |
|---|---|---|---|
| 19 | Kth Largest Element | 215 | Canonical |
| 20 | K Closest Points to Origin | 973 | Common Google question |
| 21 | Find Median from Data Stream | 295 | Two-heap trick — impressive when done right |

---

## Pattern 8 — Dynamic Programming (1-D only) *(Day 11)*

**Why:** most DP problems at senior-level interviews are 1-D; 2-D DP is rarely asked unless you're targeting research roles.

**Signal:** "count ways", "min/max cost", "longest increasing", "can you partition".

**Template (bottom-up, usually beats top-down for clarity):**
```python
dp = [0] * (n + 1)
dp[0] = base_case
for i in range(1, n + 1):
    dp[i] = transition(dp[i-1], dp[i-2], ...)
return dp[n]
```

| # | Problem | LC | Why |
|---|---|---|---|
| 22 | Climbing Stairs | 70 | Simplest DP; relearn the shape |
| 23 | Coin Change | 322 | Classic DP; both top-down and bottom-up approaches |
| 24 | Longest Increasing Subsequence | 300 | O(n²) DP is fine; O(n log n) is a bonus |

*(Skip 2-D DP, Aho-Corasick, segment trees, Fenwick trees, etc. They're not worth the time in 2 weeks.)*

---

## Pattern 9 — Backtracking *(Day 12)*

**Why:** generate all X; find one valid X; permute/combine.

**Signal:** "all subsets", "all permutations", "valid combinations", "N-queens".

**Template:**
```python
def backtrack(path, choices):
    if is_valid(path):
        result.append(path[:])
        return
    for choice in choices:
        if valid_pick(choice, path):
            path.append(choice)
            backtrack(path, updated_choices)
            path.pop()  # undo
```

| # | Problem | LC | Why |
|---|---|---|---|
| 25 | Subsets | 78 | Backtracking template 101 |
| 26 | Permutations | 46 | Classic |
| 27 | Word Search | 79 | Backtracking on grid (combines Pattern 6 + 9) |

---

## Pattern 10 — Strings (patterns + manipulation) *(Distributed)*

**Why:** strings show up in ~15% of Google questions and often combine with other patterns.

**Signal:** "valid", "decode", "palindrome", "substring".

| # | Problem | LC | Why |
|---|---|---|---|
| 28 | Valid Parentheses | 20 | Stack-based; classic warmup |
| 29 | Longest Palindromic Substring | 5 | Expand-around-center; intermediate |
| 30 | Encode and Decode Strings | 271 | Shows up in Google LC frequently; tests string-length-prefix technique |

---

# The 30-problem schedule (mapped to `CURRICULUM.md`)

| Day | Problem | Pattern |
|---|---|---|
| 2 | Two Sum II (167) | Two pointers |
| — | 3Sum (15) | Two pointers |
| 3 | Longest Substring Without Repeating (3) | Sliding window |
| — | Longest Repeating Char Replacement (424) | Sliding window |
| 4 | Group Anagrams (49) | Hashing |
| — | Top K Frequent (347) | Hashing + heap |
| 5 | Binary Search (704) | Binary search |
| — | Search in Rotated Sorted (33) | Binary search |
| 6 | (mock + review) | — |
| 7 | (rest + redo weak ones) | — |
| 8 | Binary Tree Level Order (102) | Trees BFS |
| — | LCA (236) | Trees DFS |
| 9 | Number of Islands (200) | Graphs |
| — | Course Schedule (207) | Graphs + topo |
| 10 | Kth Largest (215) | Heap |
| — | K Closest Points (973) | Heap |
| 11 | Climbing Stairs (70) | DP |
| — | Coin Change (322) | DP |
| 12 | Subsets (78) | Backtracking |
| — | Permutations (46) | Backtracking |
| 13 | (mock) + Word Search (79) + Word Ladder (127) | Combined |
| 14 | (rest; don't grind) | — |

**Stretch problems (do only if ahead):** 42 (Trapping Rain Water), 76 (Min Window Substring), 124 (Binary Tree Max Path Sum), 295 (Median from Stream), 300 (LIS), 271 (Encode/Decode), 20 (Valid Parens), 5 (Longest Palindromic), 153 (Min Rotated).

---

# How to solve on a plain Google Doc

Practice this protocol on EVERY problem:

1. **0:00 — 0:03 (3 min) — Clarify out loud.** Restate the problem. Ask for the input shape, constraints, edge cases. Even alone, say it.
2. **0:03 — 0:08 (5 min) — Approach out loud.** Propose one solution. State time + space complexity. If brute force first, say "brute force is O(n²), can we do better?"
3. **0:08 — 0:23 (15 min) — Code.** Write clean, indented Python. No shortcuts. Use meaningful variable names (`left`, not `l`; `graph`, not `g`). Add a 1-line docstring for each function.
4. **0:23 — 0:28 (5 min) — Dry run.** Walk through 2 test cases by hand. Write out the variable state as you go.
5. **0:28 — 0:30 (2 min) — Optimize/discuss.** "If the input were N=1e9 instead of N=1e5, I'd switch to X."

**Total: 30 min. Hard cap.** At 20 min with no solution, look up the pattern (not the full solution), close the tab, re-code from memory.

---

# If you only have 1 week, not 2

Pick the **one highest-value problem per pattern** — 10 problems total. That's the floor. Don't go below.

Order:
1. LC 3 (sliding window)
2. LC 200 (graphs)
3. LC 49 (hashing)
4. LC 33 (binary search)
5. LC 236 (trees)
6. LC 215 (heap)
7. LC 322 (DP)
8. LC 78 (backtracking)
9. LC 15 (two pointers)
10. LC 20 (strings/stack)

Any of these shows up in a Google round.
