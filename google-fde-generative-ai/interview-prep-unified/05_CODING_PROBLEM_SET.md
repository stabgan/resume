# Coding Problem Set

For 11 days. **Solve every problem on a blank Google Doc.** No VS Code. No execution. No Copilot.

## The 22-problem core set (do all of these)

Order matches `00_EXECUTION_PLAN.md`.

| # | Problem | LC # | Pattern | Why |
|---|---|---|---|---|
| 1 | Two Sum | 1 | Hash map | Warmup, index/value clarity |
| 2 | Longest Substring Without Repeating Characters | 3 | Sliding window | Most important string/window pattern |
| 3 | Group Anagrams | 49 | Hashing | Clean grouping with `defaultdict` |
| 4 | Search in Rotated Sorted Array | 33 | Binary search | Google classic |
| 5 | Valid Parentheses | 20 | Stack | String/stack warmup |
| 6 | Encode and Decode Strings | 271 | String design | Length-prefix technique; 30-line practical |
| 7 | Rate Limiter | — | OOP / map+queue | Very plausible Google-style practical problem |
| 8 | Binary Tree Level Order Traversal | 102 | BFS | Canonical BFS |
| 9 | Lowest Common Ancestor | 236 | Tree DFS | Recursion invariant |
| 10 | Number of Islands | 200 | Graph / grid DFS | Essential graph pattern |
| 11 | Course Schedule | 207 | Topological sort | Dependencies + cycle detection |
| 12 | Kth Largest Element | 215 | Heap / quickselect | Top-k thinking |
| 13 | Coin Change | 322 | 1D DP | Minimal DP coverage |
| 14 | Top K Frequent Elements | 347 | Hashing + heap | Counter + heap OR bucket sort |
| 15 | Merge Intervals | 56 | Sorting | Interval pattern |
| 16 | Subsets | 78 | Backtracking | Recursive generation template |
| 17 | Word Search | 79 | Backtracking + grid | Combines DFS + state |
| 18 | LRU Cache | 146 | OOP / map + DLL | Canonical class design |
| 19 | 3Sum | 15 | Two pointers | Sorted + duplicate handling |
| 20 | Minimum Window Substring | 76 | Sliding window | Hardest high-yield window |
| 21 | Clone Graph | 133 | Graph DFS | Node cloning with hash map |
| 22 | Product of Array Except Self | 238 | Arrays / prefix | Clever O(n) with O(1) extra — frequent Google question |

## The 12-problem emergency set (if time collapses)

Pick these if Gracenote work blows up and you have only 3–4 days:

1. Two Sum (1)
2. Longest Substring Without Repeating Characters (3)
3. Group Anagrams (49)
4. Search in Rotated Sorted Array (33)
5. Valid Parentheses (20)
6. Encode and Decode Strings (271)
7. **Rate Limiter** (OOP — do not skip)
8. Binary Tree Level Order Traversal (102)
9. Number of Islands (200)
10. Course Schedule (207)
11. Kth Largest Element (215)
12. **LRU Cache** (OOP — do not skip)

Any of these shows up in Google rounds.

## The 18-problem stretch set (for days with extra time)

Only touch these after the core 22 are done:

| # | Problem | LC # | Pattern |
|---|---|---|---|
| 23 | Valid Palindrome | 125 | Two pointers |
| 24 | Two Sum II | 167 | Two pointers (sorted) |
| 25 | Container With Most Water | 11 | Two pointers |
| 26 | Trapping Rain Water | 42 | Two pointers + state |
| 27 | Best Time to Buy and Sell Stock | 121 | Array / DP |
| 28 | Daily Temperatures | 739 | Monotonic stack |
| 29 | Min Stack | 155 | Stack / OOP |
| 30 | Time Based Key-Value Store | 981 | OOP / binary search |
| 31 | Invert Binary Tree | 226 | Tree recursion |
| 32 | Maximum Depth of Binary Tree | 104 | Tree recursion |
| 33 | Validate Binary Search Tree | 98 | Tree DFS with bounds |
| 34 | Binary Tree Maximum Path Sum | 124 | Tree DFS (tricky) |
| 35 | Rotting Oranges | 994 | Multi-source BFS |
| 36 | Pacific Atlantic Water Flow | 417 | Grid DFS |
| 37 | Word Ladder | 127 | BFS on implicit graph |
| 38 | K Closest Points to Origin | 973 | Heap |
| 39 | Find Median from Data Stream | 295 | Two heaps |
| 40 | Longest Increasing Subsequence | 300 | 1D DP |

## The 3 OOP problems you MUST practice

The recruiter PDF explicitly lists OOP. Expect one of the two coding questions to be a class-design question.

### 1. Rate Limiter *(from the 22-set)*

Prompt: Implement `allow(user_id, timestamp)` that permits at most N requests per user in a rolling window.

Template is in `04_CODING_PROTOCOL.md` (Map + Queue pattern). Memorize this one cold — it's the most likely OOP prompt.

**Practice additions:**
- What if we have 10M users? (cleanup, memory, TTL)
- Make it distributed — what changes?
- Token bucket variant.

### 2. LRU Cache *(from the 22-set)*

Prompt: Implement `get(key)` and `put(key, value)` in O(1).

Template is in `04_CODING_PROTOCOL.md` (Map + DLL pattern).

**Practice additions:**
- LFU variant.
- Time-aware eviction.
- Write-back vs. write-through.

### 3. Encode and Decode Strings *(from the 22-set)*

Prompt: Encode a list of strings into one string and decode it back.

Design: length-prefix encoding. `"3#foo2#hi"` encodes `["foo", "hi"]`.

**Practice additions:**
- Strings containing the delimiter.
- Empty strings.
- Multi-digit length.

## How to work through each problem (40 min, hard cap)

From `04_CODING_PROTOCOL.md`:

1. 0:00–0:03 Clarify aloud.
2. 0:03–0:08 Approach + complexity aloud.
3. 0:08–0:28 Code on blank Google Doc.
4. 0:28–0:35 Dry-run two cases aloud.
5. 0:35–0:40 Trade-offs and tests.

If stuck at minute 20 with no solution: **say "let me step back and identify the invariant"**, look up only the pattern (not the solution), close the hint, re-code from memory.

## Mark every problem one of 3 colors

Keep a simple log:

| Color | Meaning | Action |
|---|---|---|
| 🟢 Green | Solved cleanly under 30 min, clear explanation | Done; re-solve in 48 hours to confirm |
| 🟡 Yellow | Solved but hit a bug or exceeded 30 min | Re-solve in 24 hours |
| 🔴 Red | Could not solve without hint | Re-solve in 24 hours; if still red, re-solve again in 48 hours |

Re-solving is where retention happens. Spaced repetition beats volume.

## Pattern Recognition Cheat Sheet (glance at this daily)

- Contiguous substring/subarray → **sliding window**
- Pair/triplet in sorted input → **two pointers**
- Fast membership / count / grouping → **hash map / set**
- Sorted or monotonic condition → **binary search**
- Nested dependency / cycle → **graph + topological sort**
- Grid connected components → **DFS / BFS**
- Top K / bottom K → **heap or quickselect**
- Generate all valid combinations → **backtracking**
- Min/max ways over choices → **DP**
- Recent / frequent / history class → **OOP + dict + queue/list**
- Parentheses / next greater / parsing → **stack**
- Tree path / height / LCA → **DFS recursion**
- Shortest path / levels → **BFS**
- Versioned lookup → **binary search on sorted append-only list**

## What to say about complexity (memorize)

- Array scan: O(n), O(1) space.
- Hash map lookup: average O(1), worst O(n). Say "average O(1)."
- Sorting: O(n log n).
- Binary search: O(log n).
- Heap push/pop: O(log k).
- BFS/DFS graph: O(V + E).
- Grid DFS/BFS: O(rows × cols).
- DP: O(states × transition cost).
- Backtracking: exponential; mention branching factor × depth.

## Python cost pitfalls

- `list.append`: amortized O(1). ✓
- `list.pop()`: O(1). ✓
- `list.pop(0)`: O(n). ✗ — use `deque.popleft()` instead.
- `x in set/dict`: average O(1). ✓
- `x in list`: O(n). ✗
- Slicing `s[i:j]`: O(length). Don't slice in tight loops.
- String concatenation in loop: can be O(n²). Use `list` + `"".join(list)`.

## Common Google-asked problems NOT on the core 22

If you've finished the core and the stretch and still want more, these are frequent at Google specifically. Note: **Design In-Memory File System and Logger Rate Limiter now have full solutions in `05a_CODING_SOLUTIONS.md`** (problems 26 and 27), so they're pre-drilled.

- Meeting Rooms II (253) — interval + heap
- Word Break (139) — DP
- Design In-Memory File System (588) — pre-solved in `05a`
- Logger Rate Limiter (359) — pre-solved in `05a`
- Alien Dictionary (269) — topological sort from constraints
- Longest Palindromic Substring (5) — expand around center

## The one habit that wins the coding round

**Speak every line as you type it.** "I'm initializing a hash map... iterating over nums... for each value, computing the complement... checking if complement is in the map..." The interviewer's scorecard is 70% *how you think*, 30% the final code. Silence loses you the round.

Practice this starting Day 1.
