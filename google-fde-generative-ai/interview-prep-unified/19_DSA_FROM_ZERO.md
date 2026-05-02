# 19 — DSA From Zero: The 10-Day Pattern Primer

## Why this file exists

You asked me to write prep material assuming you don't remember DSA. This is a self-contained primer, organized by the 8 patterns that cover 90% of what Google actually asks. Read it start to finish once. Re-read the pattern of the day before each coding drill. Type every template at least 3 times on a blank Google Doc.

This is not a textbook. It's a field guide. Every pattern has:

1. **What it is** in one paragraph.
2. **How to recognize it** when the interviewer reads you a prompt.
3. **The template code** you should be able to type from memory.
4. **The canonical problems** you drill to internalize the pattern.
5. **Common bugs** interviewers catch you on.
6. **One-line complexity justification** to say aloud.

Reference this alongside the full solutions in `05a_CODING_SOLUTIONS.md` and the narrated coding walkthrough in `14_NARRATED_WALKTHROUGHS.md`.

## The mindset shift

You are not going to out-volume seasoned LeetCoders. You're not going to solve Hards cold. That's fine. Google's rubric rewards **clear thinking, clean code, and spoken narration** over raw problem count. A candidate who says "this is a sliding window because the answer is a contiguous subarray" and writes a slightly buggy but correct-in-spirit solution scores higher than a silent candidate who types a perfect solution with no explanation.

**Your job for 10 days:** recognize 8 patterns on sight. Type the template for each. Solve 3-5 canonical problems per pattern out loud. That's it.

---

## The 8 patterns (in order of importance for Google)

| # | Pattern | Recognize it when... | Likelihood at Google |
|---|---|---|---|
| 1 | Hash map (complement / frequency / grouping) | You need O(1) lookup, counting, or grouping | VERY HIGH |
| 2 | Sliding window | Answer is a contiguous subarray/substring | VERY HIGH |
| 3 | Two pointers | Sorted array + pair/triplet problem | HIGH |
| 4 | Binary search | Sorted input OR monotonic condition | HIGH |
| 5 | BFS (level-order, shortest path) | Grid/graph + "shortest" or "level" | HIGH |
| 6 | DFS / Backtracking | Tree/graph traversal, all combinations | HIGH |
| 7 | Heap / top-K | "Top K", "Kth largest", scheduling | MEDIUM-HIGH |
| 8 | Stack | Parens, monotonic next-greater, parsing | MEDIUM |

If you learn these 8, understand WHY each works, and can type the template, you can attempt 90% of coding problems. Dynamic programming is a 9th pattern I'll cover at the end, but it's low-priority for 10-day prep — you can fall back to "this looks like DP but I'd need more time to work out the recurrence" and still pass.

---

## Pattern 1: Hash Map

### What it is

A hash map (dict in Python) gives O(1) average-case lookup, insert, and delete. You use it when you need to (a) check "have I seen this?" quickly, (b) count occurrences, or (c) group items by a key.

### How to recognize it

The problem mentions:
- "Find pair/triplet that sums to..." → look up the complement
- "How many times does X appear?" → counting
- "Group by property" → grouping
- "Deduplicate" or "find unique" → set (a hash map without values)

### The template (memorize this)

```python
# Pattern 1A: Complement lookup (Two Sum archetype)
def two_sum(nums, target):
    seen = {}  # value -> index
    for i, x in enumerate(nums):
        complement = target - x
        if complement in seen:
            return [seen[complement], i]
        seen[x] = i  # insert AFTER check; never match yourself
    return []

# Pattern 1B: Frequency counting
from collections import Counter
def most_frequent(nums, k):
    counts = Counter(nums)                       # value -> count in O(n)
    return [v for v, _ in counts.most_common(k)] # top-k in O(n log k)

# Pattern 1C: Grouping
from collections import defaultdict
def group_anagrams(words):
    groups = defaultdict(list)
    for word in words:
        key = "".join(sorted(word))              # canonical form is the key
        groups[key].append(word)
    return list(groups.values())
```

### Canonical problems

Drill these in this order, on a blank Google Doc:

- **Two Sum (LC 1)** — complement lookup. Classic.
- **Group Anagrams (LC 49)** — grouping by sorted-string key.
- **Top K Frequent (LC 347)** — Counter + heap OR bucket sort.
- **Valid Anagram (LC 242)** — two Counters compared.
- **Subarray Sum Equals K (LC 560)** — prefix sum + hash map lookup. Extends Two Sum pattern.
- **Longest Consecutive Sequence (LC 128)** — set membership, walk from sequence starts.

### Common bugs

- Inserting into `seen` BEFORE the check in Two Sum → matches the current element with itself when `target = 2*nums[i]`.
- Using `dict.get(k, 0)` for counting when `Counter` or `defaultdict(int)` is cleaner.
- Comparing `counts1 == counts2` assuming dict order matters. It doesn't; `Counter` equality is by key-value pairs.

### Complexity (say aloud)

> O(n) time, O(n) space. Hash map operations are amortized O(1), so one pass is linear. The space is the size of the map.

---

## Pattern 2: Sliding Window

### What it is

You maintain a "window" (range of indices `[left, right]`) and slide it across the input. As `right` expands you add to the window state; as `left` shrinks you remove. Key invariant: the window always satisfies some property (fixed size, all-unique characters, sum below threshold).

### How to recognize it

The answer is a **contiguous subarray or substring** and the problem asks for:
- Longest / shortest / max / min window with property X
- Window of fixed size K
- "The maximum sum of any K consecutive elements"

If the window is non-contiguous (e.g., subset of elements), it's NOT sliding window. That's likely two-pointer or backtracking.

### The template (memorize this)

```python
# Variable-size sliding window (expand-and-contract)
def longest_valid_window(s):
    left = 0
    window_state = {}          # or int, or Counter, depending on problem
    best = 0
    for right, ch in enumerate(s):
        # 1. Expand: add s[right] to window state
        window_state[ch] = window_state.get(ch, 0) + 1
        
        # 2. Contract: while window invariant is violated, shrink from left
        while window_invariant_broken(window_state):
            old = s[left]
            window_state[old] -= 1
            if window_state[old] == 0:
                del window_state[old]
            left += 1
        
        # 3. Record answer (at this point, window is valid)
        best = max(best, right - left + 1)
    return best
```

### Canonical problems

- **Longest Substring Without Repeating Characters (LC 3)** — classic; invariant is "no duplicates."
- **Minimum Window Substring (LC 76)** — hardest high-yield window problem; invariant is "contains all chars from target."
- **Longest Repeating Character Replacement (LC 424)** — invariant is "at most K replacements."
- **Subarray Sum Equals K (LC 560)** — fixed target, uses prefix-sum variant, not classic sliding window.

### Common bugs

- Forgetting to check `while window_state[s[left]] == 0: del` when using a dict — stale entries break subsequent logic.
- Computing `best = max(best, right - left + 1)` INSIDE the while loop instead of outside → records bad lengths.
- Using strict `>` when the problem says "at most" vs `>=` when "more than." Read the prompt carefully.

### Complexity (say aloud)

> O(n) time because each element enters and leaves the window at most once, so total work is 2n. O(k) space where k is the alphabet size or the number of distinct elements in the window.

---

## Pattern 3: Two Pointers

### What it is

Two indices move across the input — typically one from the left and one from the right, converging. Used when the input is sorted (or can be sorted) and you're looking for pairs/triplets with a target property.

### How to recognize it

- Input is sorted, OR can be sorted in O(n log n) up front.
- You need to find a pair (or triplet after sorting) satisfying a condition.
- The problem involves reversing, partitioning, or merging sorted sequences.

### The template

```python
# Two pointers, converging
def two_sum_sorted(nums, target):
    left, right = 0, len(nums) - 1
    while left < right:
        s = nums[left] + nums[right]
        if s == target:
            return [left, right]
        elif s < target:
            left += 1    # need bigger sum, move left pointer right
        else:
            right -= 1   # need smaller sum, move right pointer left
    return []

# Two pointers, fast-slow (for linked lists or in-place dedup)
def remove_duplicates(nums):
    if not nums:
        return 0
    slow = 0  # write pointer
    for fast in range(1, len(nums)):
        if nums[fast] != nums[slow]:
            slow += 1
            nums[slow] = nums[fast]
    return slow + 1
```

### Canonical problems

- **Two Sum II — Input Array Is Sorted (LC 167)** — canonical converging pointers.
- **3Sum (LC 15)** — sort first, then for each `nums[i]`, two-pointer the rest.
- **Container With Most Water (LC 11)** — diverging-to-converging, compute area.
- **Trapping Rain Water (LC 42)** — two pointers with running max from each side. Classic Hard that maps neatly.
- **Valid Palindrome (LC 125)** — two pointers from outside in.

### Common bugs

- In 3Sum, not skipping duplicates after finding a triplet → emits the same triplet multiple times.
- In fast-slow pointers, writing `slow` without incrementing, or incrementing before writing → loses the first unique element.
- Off-by-one on loop condition (`while left < right` vs `<=`). For converging pointers, always `<` to avoid comparing an element with itself.

### Complexity (say aloud)

> O(n) time for converging two-pointer after sorting, so O(n log n) total. O(1) extra space if sorted in place.

---

## Pattern 4: Binary Search

### What it is

You have a sorted range (or a monotonic predicate over a range) and you repeatedly halve the search space. O(log n) per search.

### How to recognize it

- Input is sorted. (Obvious case.)
- Not obviously sorted, but the problem has a **monotonic condition**: "find smallest X such that f(X) is true, where f is monotonic." This is binary-search-on-answer.
- "Find in rotated sorted array" — sorted with a twist.

### The template

```python
# Binary search on a sorted index (classic)
def search(nums, target):
    left, right = 0, len(nums) - 1
    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

# Binary search on the answer (monotonic predicate)
def min_rate(piles, hours):
    """Koko eating bananas: find min rate k such that eating time <= hours."""
    def can_finish(k):
        return sum((p + k - 1) // k for p in piles) <= hours  # ceil(p/k)
    lo, hi = 1, max(piles)
    while lo < hi:
        mid = (lo + hi) // 2
        if can_finish(mid):
            hi = mid        # mid works; try smaller
        else:
            lo = mid + 1    # mid too slow; need bigger
    return lo
```

### Canonical problems

- **Search in Rotated Sorted Array (LC 33)** — Google classic; binary search with pivot detection.
- **Koko Eating Bananas (LC 875)** — binary search on answer. High-frequency at Google.
- **Find First and Last Position (LC 34)** — two binary searches, one for left bound, one for right.
- **Median of Two Sorted Arrays (LC 4)** — Hard, L6-tier. Know the approach but don't drill.

### Common bugs

- `mid = (left + right) // 2` — correct in Python (arbitrary precision). In Java/C++ use `left + (right - left) // 2` to avoid overflow. Mention if asked.
- Choosing `while left <= right` + `return -1` vs `while left < right` + `return left` at the end — pick ONE template and stick with it. Mixing causes infinite loops.
- For binary-search-on-answer, confusing which side "satisfies" the predicate. Draw a yes/no number line on the Doc before coding.

### Complexity (say aloud)

> O(log n) time, O(1) space. Each iteration halves the search range.

---

## Pattern 5: BFS (Breadth-First Search)

### What it is

You explore a graph level by level using a FIFO queue (`collections.deque`). Good for shortest-path problems (unweighted), level-order traversal, and any problem where you need to visit the nearest-first.

### How to recognize it

- Grid problem with "shortest path" or "minimum steps"
- Tree problem with "level order"
- Graph reachability
- "Minimum number of operations to go from state A to state B"

### The template

```python
from collections import deque

# BFS on a grid (shortest-path style)
def shortest_grid_path(grid, start, target):
    rows, cols = len(grid), len(grid[0])
    queue = deque([(start[0], start[1], 0)])  # (row, col, distance)
    visited = {start}
    while queue:
        r, c, dist = queue.popleft()
        if (r, c) == target:
            return dist
        for dr, dc in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
            nr, nc = r + dr, c + dc
            if 0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] != "#" and (nr, nc) not in visited:
                visited.add((nr, nc))
                queue.append((nr, nc, dist + 1))
    return -1

# BFS on a binary tree (level order)
def level_order(root):
    if not root:
        return []
    result = []
    queue = deque([root])
    while queue:
        level = []
        for _ in range(len(queue)):       # process one level at a time
            node = queue.popleft()
            level.append(node.val)
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        result.append(level)
    return result
```

### Canonical problems

- **Binary Tree Level Order Traversal (LC 102)** — canonical level-by-level BFS.
- **Number of Islands (LC 200)** — BFS or DFS on each unvisited '1' cell.
- **Rotting Oranges (LC 994)** — multi-source BFS; seed the queue with all initial rotten oranges.
- **Word Ladder (LC 127)** — BFS on an implicit graph where nodes are words.

### Common bugs

- Using `list.pop(0)` instead of `deque.popleft()`. The first is O(n), the second O(1). This turns your BFS from O(V+E) into O(V²).
- Forgetting to add to `visited` BEFORE appending to the queue → revisits the same node, potential infinite loop.
- Marking visited when you pop vs when you push: always mark on push.
- Level-order BFS: using `for node in queue` instead of `for _ in range(len(queue))` → loops over newly-added nodes too.

### Complexity (say aloud)

> O(V + E) time where V is nodes and E is edges. For a grid, V = rows × cols and E is 4V, so O(rows × cols). O(V) space for the visited set and queue.

---

## Pattern 6: DFS and Backtracking

### What it is

DFS explores depth-first via recursion (or an explicit stack). Backtracking is DFS where you "undo" the choice after exploring (add to state → recurse → remove from state).

### How to recognize it

- Tree traversal (in-order, pre-order, post-order)
- Graph connectivity on grids (islands, connected components)
- "Generate all possible..." / "Find all combinations that..." → backtracking
- "Find a path in a tree/graph satisfying X"

### The templates

```python
# DFS on a grid (connected components; NO undo)
def count_islands(grid):
    rows, cols = len(grid), len(grid[0])
    visited = set()
    count = 0
    
    def dfs(r, c):
        if r < 0 or r == rows or c < 0 or c == cols:
            return
        if grid[r][c] != "1" or (r, c) in visited:
            return
        visited.add((r, c))
        for dr, dc in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
            dfs(r + dr, c + dc)
    
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == "1" and (r, c) not in visited:
                count += 1
                dfs(r, c)
    return count

# Backtracking (WITH undo)
def subsets(nums):
    result = []
    path = []
    
    def backtrack(start):
        result.append(path[:])          # snapshot current path
        for i in range(start, len(nums)):
            path.append(nums[i])        # CHOOSE
            backtrack(i + 1)            # RECURSE
            path.pop()                  # UNDO (this is the "back" in backtrack)
    
    backtrack(0)
    return result
```

### Canonical problems

- **Number of Islands (LC 200)** — DFS connected components.
- **Lowest Common Ancestor (LC 236)** — recursive tree DFS with a clean invariant.
- **Subsets (LC 78)** — canonical backtracking template.
- **Word Search (LC 79)** — backtracking on a grid; mark-and-unmark via temporary character swap.
- **Clone Graph (LC 133)** — DFS with a hash map tracking cloned nodes; classic cycle-safe clone.

### Common bugs

- In backtracking, forgetting to undo (`path.pop()`) → state leaks between sibling branches.
- In DFS on a grid, not marking visited BEFORE recursing → infinite recursion on self-loops.
- In tree problems, returning `None` vs a default value inconsistently → NoneType errors.
- In Word Search, restoring the cell to its original character after the recursion fails. Use `board[r][c], tmp = '#', board[r][c]` pattern.

### Complexity (say aloud)

> DFS is O(V + E), same as BFS. Backtracking is exponential in the worst case — branching factor times depth. Say the branching factor and depth explicitly.

---

## Pattern 7: Heap / Top-K

### What it is

A heap (priority queue) maintains the min (or max) element at the top with O(log n) insert and O(log n) extract-min. Python's `heapq` is a min-heap; for max-heap push negatives.

### How to recognize it

- "Top K", "Kth largest", "smallest K"
- "Merge K sorted lists/streams"
- "Find the median as a stream comes in" (two heaps)
- Scheduling: "run the most important task first"

### The template

```python
import heapq

# Top-K largest (keep a min-heap of size K)
def top_k_largest(nums, k):
    heap = []
    for num in nums:
        heapq.heappush(heap, num)
        if len(heap) > k:
            heapq.heappop(heap)        # remove smallest; keep top K
    return heap                        # list of K largest, unsorted

# Top-K frequent (heap of tuples)
from collections import Counter
def top_k_frequent(nums, k):
    counts = Counter(nums)
    return heapq.nlargest(k, counts.keys(), key=counts.get)

# Running median (two heaps)
class MedianFinder:
    def __init__(self):
        self.lo = []  # max-heap (push negatives)
        self.hi = []  # min-heap
    
    def add(self, num):
        heapq.heappush(self.lo, -num)
        heapq.heappush(self.hi, -heapq.heappop(self.lo))
        if len(self.hi) > len(self.lo):
            heapq.heappush(self.lo, -heapq.heappop(self.hi))
    
    def median(self):
        if len(self.lo) > len(self.hi):
            return -self.lo[0]
        return (-self.lo[0] + self.hi[0]) / 2
```

### Canonical problems

- **Kth Largest Element in an Array (LC 215)** — heap of size K, or quickselect (mention both, code heap).
- **Top K Frequent Elements (LC 347)** — Counter + heap.
- **Find Median from Data Stream (LC 295)** — two heaps. Classic Hard.
- **Merge K Sorted Lists (LC 23)** — heap of list heads. Hard but pattern is clean.

### Common bugs

- `heapq` is a min-heap; forgetting to negate for max-heap.
- Pushing tuples where the second element isn't comparable → `TypeError` when two priorities tie. Fix: add a tiebreaker like an index or a counter.
- For top-K with heap of size K, forgetting the `if len(heap) > k: heappop` — the heap grows unbounded.

### Complexity (say aloud)

> O(n log k) for top-K with a size-K heap. O(k + (n-k) log k) is more precise but `n log k` is the canonical answer.

---

## Pattern 8: Stack

### What it is

Last-in-first-out. Useful for parsing, matching, and maintaining monotonic sequences (next greater / previous smaller).

### How to recognize it

- Parentheses / brackets matching
- "Next greater element" / "previous smaller element"
- Depth-first traversal without recursion
- Expression parsing / calculator

### The template

```python
# Stack for matching (parens, brackets)
def is_valid(s):
    pairs = {')': '(', ']': '[', '}': '{'}
    stack = []
    for ch in s:
        if ch in '([{':
            stack.append(ch)
        elif ch in ')]}':
            if not stack or stack.pop() != pairs[ch]:
                return False
    return not stack  # leftover opens = unmatched

# Monotonic stack (next greater element)
def next_greater(nums):
    result = [-1] * len(nums)
    stack = []    # stack of indices, nums[stack] is monotonically DECREASING from bottom
    for i, x in enumerate(nums):
        while stack and nums[stack[-1]] < x:
            result[stack.pop()] = x
        stack.append(i)
    return result
```

### Canonical problems

- **Valid Parentheses (LC 20)** — canonical match-and-pop.
- **Daily Temperatures (LC 739)** — monotonic decreasing stack.
- **Decode String (LC 394)** — stack of (repeat, current_string) tuples. High Google frequency.
- **Min Stack (LC 155)** — design problem; two stacks (value + running min).

### Common bugs

- In matching problems, returning early vs checking `not stack` at the end. Both are needed; one alone fails edge cases like `"(("` or `")))"`.
- In monotonic stack, mixing up `<` vs `<=` when resolving ties. For "strictly next greater" use `<`. For "next greater-or-equal" use `<=`.
- Using `list.pop()` (top) vs `list.pop(0)` (bottom). Stack = top.

### Complexity (say aloud)

> O(n) time. Each element is pushed and popped at most once, so total work is 2n. O(n) space for the stack.

---

## Pattern 9 (lower priority): Dynamic Programming

### What it is

Break a problem into overlapping subproblems, memoize. For the interview, 1D DP (like Kadane's) is the highest-ROI. 2D DP (knapsack, edit distance) is harder and probably overkill for 10-day prep.

### How to recognize it

- "Number of ways to..."
- "Minimum/maximum cost/sum/length..."
- Problem has optimal substructure (the answer for N depends on answer for N-1, N-2, etc.)

### The 1D DP templates

```python
# Kadane's (maximum subarray)
def max_subarray(nums):
    best = current = nums[0]
    for x in nums[1:]:
        current = max(x, current + x)    # extend OR restart
        best = max(best, current)
    return best

# Coin change (min coins to make amount)
def coin_change(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    for i in range(1, amount + 1):
        for c in coins:
            if i >= c:
                dp[i] = min(dp[i], dp[i - c] + 1)
    return dp[amount] if dp[amount] != float('inf') else -1

# Climbing stairs (Fibonacci-style)
def climb(n):
    if n <= 2:
        return n
    a, b = 1, 2
    for _ in range(3, n + 1):
        a, b = b, a + b
    return b
```

### Canonical problems

- **Maximum Subarray (LC 53)** — Kadane's. 30 lines. Must know.
- **Climbing Stairs (LC 70)** — easiest Fibonacci-style.
- **Coin Change (LC 322)** — 1D bottom-up DP.
- **House Robber (LC 198)** — decision-at-each-step DP.
- **Longest Increasing Subsequence (LC 300)** — LIS. Know O(n²) DP, mention O(n log n) with binary search.

### If the interviewer gives you a DP problem and you're stuck

Say this:

> This looks like DP. The subproblem is "maximum X ending at position i" and the transition is either extending or restarting. Let me try to write a brute force first, then see if memoization collapses the repeated subproblems.

Then write the brute force recursion. Even if you don't finish, you get partial credit for the setup.

### Complexity (say aloud)

> For 1D DP: O(n × k) time where k is the transition cost. For Kadane's, O(n) time, O(1) space since we only need the previous state.

---

## The 15-minute pattern-recognition drill (do this daily)

Before you drill a problem, spend 90 seconds on this:

1. Read the prompt once.
2. Out loud, say: *"The answer is a [contiguous subarray / pair / graph / tree path / count / top-K]. That maps to pattern [N]."*
3. State the invariant you expect to maintain.
4. State the complexity target.

Only then start coding. Most interview failures come from skipping step 1-4 and diving into code.

---

## Narration cheatsheet (the single most important skill)

For every problem you solve, say these 5 things in order, out loud:

1. *"Let me restate: the input is X, the output is Y, and the constraint is Z."*
2. *"The brute force is O(n²). Let me think if we can do better."* (Even if the answer IS O(n²), saying this signals thought.)
3. *"The pattern here is [sliding window / hash map / etc.] because [reason]."*
4. *"The invariant I'll maintain is [condition]."*
5. *"Time is O(...), space is O(...), because [one-sentence reason]."*

Say all 5 even if the interviewer says nothing. That's narration. That's the skill Google grades for.

---

## Day-by-day 10-day pattern schedule

Aligned with `00_EXECUTION_PLAN.md`. Each day: 90 min learning (read pattern + watch NeetCode video) + 60 min typing (drill problems on blank Doc).

| Day | Pattern | Drill |
|---|---|---|
| May 3 | **1 Hash Map** | Two Sum (1), Group Anagrams (49), Valid Anagram (242), Subarray Sum K (560) |
| May 4 | **2 Sliding Window** | Longest Substring Unique (3), Longest Consecutive (128), Min Window Substring (76) |
| May 5 | **3 Two Pointers** | Two Sum II (167), 3Sum (15), Container With Most Water (11) |
| May 6 | **4 Binary Search** | Search Rotated (33), Koko Bananas (875), Binary Search (704) |
| May 7 | **5 BFS** | Level Order (102), Number of Islands (200), Rotting Oranges (994) |
| May 8 | **6 DFS + Backtracking** | LCA (236), Subsets (78), Word Search (79), Clone Graph (133) |
| May 9 | **7 Heap** + **8 Stack** | Kth Largest (215), Top K Frequent (347), Valid Parens (20), Decode String (394) |
| May 10 | **9 DP** (light) + **OOP** | Max Subarray (53), Coin Change (322), LRU Cache (146), Rate Limiter |
| May 11 | **Pattern recognition mock** | Random 3 problems across patterns, timed. Score against `10_INTERVIEW_DAY.md` rubric. |
| May 12 | **Taper** | Re-type templates from memory (20 min). Read 1 pattern. Rest. |

---

## How to use this file with NeetCode

NeetCode's "Roadmap" view is organized by pattern too. For each day above:

1. Open NeetCode's pattern roadmap for the day (e.g., "Sliding Window").
2. Watch 2 videos at 1.5x (the introductory one + the hardest one).
3. Read the corresponding section above.
4. Type the template from memory on a blank Google Doc.
5. Solve the drill problems in this file's schedule.

NeetCode gives you the video mental model; this file gives you the template and the narration. You need both.

---

## What NOT to spend time on

Because you have 10 days and are starting near-zero:

- **Hard problems** (LC Hard tier) — skip unless the pattern is canonical. Trapping Rain Water is the only Hard you drill.
- **Dynamic programming on 2D grids** — skip. Too much cognitive load for too little interview-day return.
- **Segment trees, Fenwick trees, advanced graph algorithms** (Dijkstra, Floyd, Kosaraju) — skip. Google rarely asks these at L4/L5.
- **Bit manipulation** — skip. If asked, say "I'd need a whiteboard to work out the bit tricks" and move on.
- **Greedy algorithms** as a separate category — skip. Most "greedy" problems are DP in disguise; if you handle them via Pattern 9 (DP) that's fine.

---

## One hard rule

**Never skip saying the invariant out loud before coding.** The invariant is what separates L5 thinking from L4. L4 says "I'll use a hash map." L5 says "The invariant is: at the end of each iteration, `seen` contains every value processed so far mapped to its index." Say the invariant. Every time.
