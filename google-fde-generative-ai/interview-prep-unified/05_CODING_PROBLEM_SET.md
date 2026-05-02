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

## Frequency-ranked gaps from the Google 30-day + 3-month list (May 2026)

I pulled the public LeetCode-Google mirror (`_leetcode_google_tags/` CSVs, snapshot Feb 2026) and cross-referenced Google's most-asked problems against your 22 core + 18 stretch + 5 OOP set. **Your 22 core is extremely well-calibrated.** 15 of the 25 problems in the top-30 Google 30-day list are already in your drill set, including Two Sum (100% freq), Container With Most Water, Trapping Rain Water, Longest Substring, Merge Intervals, Rotated Sorted Search, Valid Parens, Kth Largest, Subsets, Top K, Group Anagrams, Product of Array Except Self, LIS, Islands.

### The real gaps: 8 problems worth adding in the final 10 days

These appeared in BOTH the 30-day AND 3-month Google lists but aren't in your drill set. Ranked by combined signal. Each one is 30-45 minutes to learn and uses patterns you already know.

| Priority | LC # | Title | Difficulty | Pattern | Why it matters |
|---|---|---|---|---|---|
| 1 | 560 | Subarray Sum Equals K | Medium | Prefix sum + hashmap | Classic Google; extends your Two Sum hashmap pattern |
| 2 | 128 | Longest Consecutive Sequence | Medium | Hashmap + set walk | Tests whether you spot the O(n) trick vs naive O(n log n) |
| 3 | 5 | Longest Palindromic Substring | Medium | Expand-around-center | Pattern you don't have; 30 lines |
| 4 | 394 | Decode String | Medium | Stack + recursion | Your stack pattern extended |
| 5 | 242 | Valid Anagram | Easy | Counter comparison | Warmup; uses `collections.Counter` which you've memorized |
| 6 | 875 | Koko Eating Bananas | Medium | Binary search on answer | Meta-pattern: binary search NOT on an index. Google loves this. |
| 7 | 53 | Maximum Subarray (Kadane's) | Medium | 1D DP / greedy | Canonical interview problem; your DP coverage is thin without it |
| 8 | 31 | Next Permutation | Medium | Array / two-pointer find-and-swap | Trickiest of the 8; skip if time-tight |

### What you can safely SKIP from the Google list

Problems in the 30-day list that look tempting but are lower-ROI for you:
- LC 9 Palindrome Number, LC 14 Longest Common Prefix, LC 26 Remove Duplicates, LC 88 Merge Sorted Array, LC 169 Majority Element, LC 283 Move Zeroes, LC 70 Climbing Stairs — all trivial once you see them. If Google asks one of these, you'll solve it live. Don't drill.
- LC 2 Add Two Numbers, LC 206 Reverse Linked List — linked list problems, Google-classic but your sliding-window / graph / hash-map practice already covers the mental model.
- LC 4 Median of Two Sorted Arrays — LC Hard, 62.5% frequency but very rarely given to anyone below L6. If asked, say "I'd binary-search the partition" and move on.
- LC 175 Combine Two Tables, LC 1757 Recyclable Products, LC 3010 / 3637 / 3721 — SQL and contest problems. Not typical Google interview questions.
- LC 51 N-Queens — Hard backtracking. If your interviewer gives this, they've already decided. Not worth 2 hours.
- LC 1929 Concatenation of Array — trivial filler, free 5 minutes if it shows up.

### Day-by-day additions to `00_EXECUTION_PLAN.md`

Slot 2 gap problems per day from May 3 to May 6, replacing nothing in the existing plan (use the 30-min coding block slot):

| Date | New drill | Paired with |
|---|---|---|
| May 3 | LC 560 Subarray Sum Equals K | + existing LC 3 Longest Substring |
| May 4 | LC 128 Longest Consecutive Seq | + existing LC 49 Group Anagrams |
| May 5 | LC 5 Longest Palindromic Substring | + existing LC 33 Rotated Search |
| May 6 | LC 394 Decode String | + existing LC 20 Valid Parens |
| May 7 | LC 875 Koko Eating Bananas | + existing LC 215 Kth Largest |
| May 8 | LC 53 Maximum Subarray | + existing LC 200 Islands |

Skip LC 242 and LC 31 unless you finish the other 6 early. They're the weakest-ROI of the 8.

### How the CSVs are structured (raw data in `_leetcode_google_tags/`)

Five files, matching LeetCode Premium's exact time windowing:
- `thirty-days.csv` — 182 Google questions in last 30 days
- `three-months.csv` — 472 Google questions in last 3 months
- `six-months.csv` — 792 Google questions in last 6 months
- `more-than-six-months.csv` — 2058 older Google questions
- `all.csv` — all 2217 Google-tagged questions

Columns: `ID, URL, Title, Difficulty, Acceptance %, Frequency %`. Frequency is the relative occurrence rate within that time window; Two Sum at 100% means it's the most-asked question in that window.

Snapshot is Feb 21, 2026 (~10 weeks old). Good enough for pattern targeting; not guaranteed to match May 13's exact question pool.

## The one habit that wins the coding round

**Speak every line as you type it.** "I'm initializing a hash map... iterating over nums... for each value, computing the complement... checking if complement is in the map..." The interviewer's scorecard is 70% *how you think*, 30% the final code. Silence loses you the round.

Practice this starting Day 1.
