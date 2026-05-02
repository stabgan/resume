# 05a — Coding Solutions (Reference Key)

## How to use this file

This is the answer key for the 25 problems in `05_CODING_PROBLEM_SET.md`. The workflow is the same every day. Open a blank Google Doc, read only the problem name and signature from the problem set, then solve the problem cold on the Doc using the protocol in `04_CODING_PROTOCOL.md`. Talk through the invariant, dry-run one example by hand, then write the code. Only after you are done do you open this file and diff your work against the reference.

Mark each problem green, yellow, or red. Green means you solved it clean in under 15 minutes with a correct dry-run on the first try. Yellow means you got there but you hit a bug, or you needed a nudge on the data structure. Red means you did not converge. Red problems get redone 48 hours later. Yellow problems get redone once more the same week. Green problems get one refresh pass in the last 48 hours before the interview.

Do not memorize these solutions. Memorize the invariants and the one-line reason each pattern works. On a plain Doc with no autocomplete, clean recall of a pattern beats perfect recall of a specific line. Every solution here is written to be typed in 30 to 50 lines, no cleverness, no one-liners that break under pressure.

The imports block at the top of every solution is the same four-line block I have memorized. I retype it every morning as part of warmup (see end of file).

```python
from collections import defaultdict, Counter, deque
import heapq
from functools import lru_cache
from typing import List, Optional, Dict, Tuple
import bisect
```

---

## 01. Two Sum (LC #1)

**Pattern:** Hash map complement lookup
**Time:** O(n)
**Space:** O(n)
**Invariant:** At index i, the map holds every value seen before i mapped to its index, so I can check in O(1) whether target minus nums[i] has already appeared.

```python
from typing import List

class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        seen: dict[int, int] = {}
        for i, x in enumerate(nums):
            need = target - x
            if need in seen:
                return [seen[need], i]
            seen[x] = i
        return []
```

**Key insight:** One pass works because I only need to find a pair, not enumerate them. By checking the complement before inserting the current value, I avoid using the same index twice without needing a separate guard. The map stores value to index so the return shape is trivial.

**Common bug:** Inserting `seen[x] = i` before the `if need in seen` check, which lets `nums[i] + nums[i]` match itself when `2 * nums[i] == target`.

**What to say during the round:** "I will do one pass with a hash map keyed on value. Before inserting the current number I check if its complement is already in the map. That gives me O(n) time and avoids the double-count edge case."

---

## 02. Longest Substring Without Repeating Characters (LC #3)

**Pattern:** Sliding window with last-seen map
**Time:** O(n)
**Space:** O(min(n, alphabet))
**Invariant:** The window `[left, right]` contains only unique characters at all times; when I see a repeat, I jump `left` to one past the last occurrence of that character.

```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        last: dict[str, int] = {}
        left = 0
        best = 0
        for right, c in enumerate(s):
            if c in last and last[c] >= left:
                left = last[c] + 1
            last[c] = right
            best = max(best, right - left + 1)
        return best
```

**Key insight:** The `last[c] >= left` guard matters because stale entries from before the current window should not force the window to shrink. Jumping `left` in one move is the key to O(n); a naive shrink-by-one loop would be O(n squared) in the worst case on strings like "abcabcabc".

**Common bug:** Forgetting the `last[c] >= left` check and letting `left` jump backwards, producing wrong lengths like 4 on "abba".

**What to say during the round:** "Sliding window with a last-seen index map. When I see a character I have seen inside the current window I jump left past its last position in one step, which keeps it linear."

---

## 03. Group Anagrams (LC #49)

**Pattern:** Hash map with canonical key
**Time:** O(n * k log k) where k is max word length
**Space:** O(n * k)
**Invariant:** Two strings are anagrams if and only if their sorted character tuples are equal, so sorted-key buckets partition the input correctly.

```python
from collections import defaultdict
from typing import List

class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        groups: dict[str, list[str]] = defaultdict(list)
        for s in strs:
            key = "".join(sorted(s))
            groups[key].append(s)
        return list(groups.values())
```

**Key insight:** Any canonical form works as the key; sorted string is the shortest to type on a Doc. The tuple-of-counts variant (length-26 tuple) is O(n * k) instead of O(n * k log k), but on a whiteboard the sorted version is less error-prone and the constant factor usually does not matter for interview-sized inputs.

**Common bug:** Using a plain `dict` and writing `groups[key] = groups.get(key, []) + [s]`, which is O(n) per insert and balloons to O(n squared). `defaultdict(list)` with `.append` is the clean pattern.

**What to say during the round:** "I bucket by the sorted character key. `defaultdict(list)` keeps the insert clean. If the interviewer pushes on complexity I mention the length-26 count tuple as the O(n k) alternative."

---

## 04. Search in Rotated Sorted Array (LC #33)

**Pattern:** Modified binary search
**Time:** O(log n)
**Space:** O(1)
**Invariant:** At every step exactly one of the two halves `[lo, mid]` or `[mid, hi]` is sorted; I pick the half that is sorted, decide whether the target lies inside it, and discard the other half.

```python
from typing import List

class Solution:
    def search(self, nums: List[int], target: int) -> int:
        lo, hi = 0, len(nums) - 1
        while lo <= hi:
            mid = (lo + hi) // 2
            if nums[mid] == target:
                return mid
            if nums[lo] <= nums[mid]:
                if nums[lo] <= target < nums[mid]:
                    hi = mid - 1
                else:
                    lo = mid + 1
            else:
                if nums[mid] < target <= nums[hi]:
                    lo = mid + 1
                else:
                    hi = mid - 1
        return -1
```

**Key insight:** The rotation means the array is two sorted runs glued at a pivot. But at any `mid`, the left half or the right half is wholly sorted, and I can tell which by comparing `nums[lo]` to `nums[mid]`. Inside the sorted half I do a standard bounds check; outside I recurse on the other half where the pivot lives.

**Common bug:** Using strict `<` instead of `<=` in `nums[lo] <= nums[mid]`, which misbehaves when `lo == mid` (a two-element window). Also forgetting inclusive bounds on the target check and excluding the endpoint.

**What to say during the round:** "I binary-search but at each step I identify which half is sorted by comparing `nums[lo]` to `nums[mid]`. If the target is inside the sorted half I go there, else I go to the other half. Standard log n."

---

## 05. Valid Parentheses (LC #20)

**Pattern:** Stack with pairing map
**Time:** O(n)
**Space:** O(n)
**Invariant:** The stack holds every open bracket that has not yet been matched, in the order it was seen; a close bracket must match the top of the stack or the string is invalid.

```python
class Solution:
    def isValid(self, s: str) -> bool:
        pair = {")": "(", "]": "[", "}": "{"}
        stack: list[str] = []
        for c in s:
            if c in pair:
                if not stack or stack.pop() != pair[c]:
                    return False
            else:
                stack.append(c)
        return not stack
```

**Key insight:** The pairing map is keyed on close brackets so I can look up "what open should be on top" in one step. Returning `not stack` at the end handles the case where open brackets were never closed, e.g. `"(("`.

**Common bug:** Forgetting the `if not stack` guard before `stack.pop()` on the first character being a close bracket, which throws `IndexError`. Also returning `True` at the end without checking if the stack is empty.

**What to say during the round:** "Stack of open brackets. On a close bracket I pop and check the match. At the end the stack must be empty. Three edge cases: starts with close, ends with unmatched open, or wrong pairing in the middle."

---

## 06. Encode and Decode Strings (LC #271)

**Pattern:** Length-prefix framing
**Time:** O(n) encode, O(n) decode
**Space:** O(n)
**Invariant:** Every encoded segment is `length + '#' + payload`; the `#` cannot be confused with a length digit because length is parsed greedily until the first `#`.

```python
from typing import List

class Codec:
    def encode(self, strs: List[str]) -> str:
        return "".join(f"{len(s)}#{s}" for s in strs)

    def decode(self, s: str) -> List[str]:
        out: list[str] = []
        i = 0
        while i < len(s):
            j = s.index("#", i)
            n = int(s[i:j])
            out.append(s[j + 1 : j + 1 + n])
            i = j + 1 + n
        return out
```

**Key insight:** A delimiter-only scheme (like comma-separated) fails when the payload itself contains the delimiter. Length prefix is robust because the length tells the decoder exactly how many bytes to consume, so any characters including `#` can appear inside the payload.

**Common bug:** Using `s.split("#")` in decode, which breaks when a payload contains `#`. Also off-by-one on the slice end index when the payload is empty (length 0).

**What to say during the round:** "Length-prefix framing. Each string becomes `len + # + s`. Decode parses the length up to `#` and slices exactly that many chars. Robust to any characters in the payload including the delimiter."

---

## 07. Rate Limiter (OOP, sliding window per user)

**Pattern:** Map of user to deque of timestamps
**Time:** O(1) amortized per `allow`
**Space:** O(users * limit)
**Invariant:** For each user the deque holds every allowed request timestamp inside the current window; anything older than `now - window` is evicted before the length check.

```python
from collections import defaultdict, deque

class RateLimiter:
    def __init__(self, max_requests: int, window_seconds: float) -> None:
        self.max_requests = max_requests
        self.window = window_seconds
        self.log: dict[str, deque[float]] = defaultdict(deque)

    def allow(self, user_id: str, now: float) -> bool:
        q = self.log[user_id]
        cutoff = now - self.window
        while q and q[0] <= cutoff:
            q.popleft()
        if len(q) >= self.max_requests:
            return False
        q.append(now)
        return True
```

**Key insight:** Sliding window log gives exact per-window counts, unlike a fixed-window counter which has a boundary burst problem. The deque gives O(1) eviction from the front. Each timestamp is inserted once and evicted once so amortized cost per call is constant even though the while loop looks unbounded.

**Common bug:** Using `list.pop(0)` instead of `deque.popleft`, which is O(n). Also using `<` instead of `<=` on the cutoff and keeping one stale timestamp on the boundary.

**What to say during the round:** "Per-user deque of timestamps, sliding window. On every call I evict anything older than `now - window`, then compare length to the limit. Amortized O(1) per call. In production I would shard by user and back it with Redis ZSET if I needed cross-instance consistency."

---

## 08. Binary Tree Level Order Traversal (LC #102)

**Pattern:** BFS with level batching
**Time:** O(n)
**Space:** O(n)
**Invariant:** At the top of each outer-loop iteration, the queue contains exactly the nodes of one level, in left-to-right order.

```python
from collections import deque
from typing import List, Optional

class TreeNode:
    def __init__(self, val: int = 0, left: "Optional[TreeNode]" = None, right: "Optional[TreeNode]" = None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def levelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        if not root:
            return []
        out: list[list[int]] = []
        q: deque[TreeNode] = deque([root])
        while q:
            level: list[int] = []
            for _ in range(len(q)):
                node = q.popleft()
                level.append(node.val)
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
            out.append(level)
        return out
```

**Key insight:** The `for _ in range(len(q))` snapshot is what separates levels. Capturing `len(q)` before the inner loop freezes the count so children appended inside the loop are not processed until the next outer iteration. This is the standard BFS-by-level trick and it shows up in zigzag traversal, right side view, and minimum depth as well.

**Common bug:** Writing `while q:` inside `for node in q:` and mutating the deque, which skips nodes or loops forever. Always snapshot with `range(len(q))`.

**What to say during the round:** "BFS with a level snapshot. I freeze the level size before the inner loop so children go to the next level. The same skeleton works for right side view, zigzag, and average per level."

---

## 09. Lowest Common Ancestor of a Binary Tree (LC #236)

**Pattern:** Post-order recursion
**Time:** O(n)
**Space:** O(h) recursion stack
**Invariant:** A call on a subtree returns non-None if and only if the subtree contains at least one of `p` or `q`; the first node whose left and right subtrees both return non-None is the LCA.

```python
from typing import Optional

class TreeNode:
    def __init__(self, val: int = 0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def lowestCommonAncestor(
        self, root: Optional[TreeNode], p: TreeNode, q: TreeNode
    ) -> Optional[TreeNode]:
        if root is None or root is p or root is q:
            return root
        left = self.lowestCommonAncestor(root.left, p, q)
        right = self.lowestCommonAncestor(root.right, p, q)
        if left and right:
            return root
        return left if left else right
```

**Key insight:** The recursion returns a node that is either `p`, `q`, or the LCA of whatever portion of `{p, q}` lives below. When both sides return non-None the current node is the split point, which is the LCA. This works for a general binary tree (no BST ordering required) because I never compare values.

**Common bug:** Returning early on the first match and missing the case where the second target is in the other subtree. The post-order structure, left then right then decide, is what prevents this.

**What to say during the round:** "Post-order recursion. Each call returns `p`, `q`, or the LCA if found. The node where both subtree calls return non-None is the split and therefore the answer."

---

## 10. Number of Islands (LC #200)

**Pattern:** Grid DFS with in-place marking
**Time:** O(m * n)
**Space:** O(m * n) recursion in worst case
**Invariant:** Once a cell is visited it is flipped to '0' in place, so I never re-enter it and each cell is processed at most once.

```python
from typing import List

class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        if not grid or not grid[0]:
            return 0
        m, n = len(grid), len(grid[0])

        def dfs(r: int, c: int) -> None:
            if r < 0 or r >= m or c < 0 or c >= n or grid[r][c] != "1":
                return
            grid[r][c] = "0"
            dfs(r + 1, c)
            dfs(r - 1, c)
            dfs(r, c + 1)
            dfs(r, c - 1)

        count = 0
        for r in range(m):
            for c in range(n):
                if grid[r][c] == "1":
                    count += 1
                    dfs(r, c)
        return count
```

**Key insight:** In-place marking avoids the extra `visited` set and saves both memory and a clarity step. The DFS floods one connected component per outer-loop trigger. If the interviewer disallows mutating input, swap in a `visited: set[tuple[int, int]]`.

**Common bug:** Comparing `grid[r][c] == 1` (int) instead of `"1"` (string); LC passes strings. Also forgetting the bounds check before the content check, which throws `IndexError` on the edges.

**What to say during the round:** "DFS from every '1' cell, mark in place as '0', count the triggers. I mention BFS as the iterative alternative if stack depth is a concern on very tall grids, and union-find if they ask for dynamic connectivity."

---

## 11. Course Schedule (LC #207)

**Pattern:** Topological sort via Kahn's BFS
**Time:** O(V + E)
**Space:** O(V + E)
**Invariant:** The queue holds every node whose incoming edges have all been removed; the graph has a topological order if and only if every node passes through the queue.

```python
from collections import defaultdict, deque
from typing import List

class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        graph: dict[int, list[int]] = defaultdict(list)
        indeg = [0] * numCourses
        for a, b in prerequisites:
            graph[b].append(a)
            indeg[a] += 1

        q: deque[int] = deque(i for i in range(numCourses) if indeg[i] == 0)
        taken = 0
        while q:
            course = q.popleft()
            taken += 1
            for nxt in graph[course]:
                indeg[nxt] -= 1
                if indeg[nxt] == 0:
                    q.append(nxt)
        return taken == numCourses
```

**Key insight:** If the graph has a cycle, the nodes inside the cycle will never hit in-degree zero, so `taken` ends below `numCourses`. Kahn's algorithm is cleaner to narrate on a Doc than the DFS three-color cycle detection, and it also gives a valid order for free by recording pops.

**Common bug:** Reading the edge direction backwards. `[a, b]` in LC means "to take `a` you need `b`", so the edge goes `b -> a`. Flipping this gives the wrong answer on any non-symmetric input.

**What to say during the round:** "Kahn's topological sort. Build the graph and in-degree array, seed the queue with zero-indegree nodes, drain. If I drain all `numCourses` the graph is acyclic. Course Schedule II is the same code returning the pop order."

---

## 12. Kth Largest Element in an Array (LC #215)

**Pattern:** Min-heap of size k
**Time:** O(n log k)
**Space:** O(k)
**Invariant:** The heap always contains the k largest elements seen so far; its root is the k-th largest.

```python
import heapq
from typing import List

class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        heap: list[int] = []
        for x in nums:
            heapq.heappush(heap, x)
            if len(heap) > k:
                heapq.heappop(heap)
        return heap[0]
```

**Key insight:** `heapq` is a min-heap, so a size-k min-heap naturally evicts the smallest of the current top-k, leaving the k-th largest at the root. This is O(n log k) which beats a full sort's O(n log n) when k is much smaller than n. Quickselect gets O(n) average with Lomuto or Hoare partition, but it is bug-prone on a plain Doc under time pressure.

**Common bug:** Forgetting that `heapq` is min-only and trying to write a max-heap by pushing raw values. The standard workarounds are negate on push-pop for numbers, or push `(-priority, tie_breaker, item)` tuples when items are not comparable.

**What to say during the round:** "Min-heap of size k. The root is the k-th largest once I have processed all elements. I mention quickselect as the O(n) average alternative but note heap is less error-prone on a Doc."

---

## 13. Coin Change (LC #322)

**Pattern:** 1D bottom-up DP
**Time:** O(amount * len(coins))
**Space:** O(amount)
**Invariant:** `dp[a]` is the minimum number of coins summing exactly to `a`, or infinity if unreachable.

```python
from typing import List

class Solution:
    def coinChange(self, coins: List[int], amount: int) -> int:
        dp = [float("inf")] * (amount + 1)
        dp[0] = 0
        for a in range(1, amount + 1):
            for c in coins:
                if c <= a and dp[a - c] + 1 < dp[a]:
                    dp[a] = dp[a - c] + 1
        return dp[amount] if dp[amount] != float("inf") else -1
```

**Key insight:** Unbounded knapsack: each coin can be reused. The outer loop over amounts and inner loop over coins gives each subproblem access to the best of all coin choices. Initializing `dp[0] = 0` is the base case, and `inf` propagates naturally through unreachable sums.

**Common bug:** Forgetting to return `-1` for unreachable amounts and returning `inf` or a large int. Also swapping loops and computing bounded knapsack by accident, which is a different problem (0-1 knapsack forbids reuse and requires inside-to-outside iteration).

**What to say during the round:** "Bottom-up DP, `dp[a]` is min coins to make `a`. Outer loop over amounts so each coin can be reused. Return `-1` if `dp[amount]` is still infinity."

---

## 14. Top K Frequent Elements (LC #347)

**Pattern:** Counter plus heap or bucket sort
**Time:** O(n log k) with heap, O(n) with bucket sort
**Space:** O(n)
**Invariant:** The min-heap of size k always holds the k most frequent elements by count, so after one pass its contents are the answer.

```python
import heapq
from collections import Counter
from typing import List

class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        freq = Counter(nums)
        heap: list[tuple[int, int]] = []
        for num, count in freq.items():
            heapq.heappush(heap, (count, num))
            if len(heap) > k:
                heapq.heappop(heap)
        return [num for _, num in heap]
```

**Key insight:** Same min-heap of size k pattern as problem 12, but keyed on frequency. Bucket sort is the O(n) alternative: an array of `n + 1` buckets indexed by count, walk from high to low and collect k elements. On a Doc the heap version is shorter to write correctly.

**Common bug:** Pushing `(num, count)` instead of `(count, num)`, which makes the heap order by value rather than frequency and returns the wrong elements. The key always goes first in the tuple.

**What to say during the round:** "Counter to get frequencies, min-heap of size k keyed on count. If they want O(n) I switch to bucket sort by frequency, one bucket per possible count."

---

## 15. Merge Intervals (LC #56)

**Pattern:** Sort then one-pass merge
**Time:** O(n log n)
**Space:** O(n)
**Invariant:** After sorting by start, any two overlapping intervals are adjacent in the sorted order, so I only need to compare each new interval to the tail of the output.

```python
from typing import List

class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals.sort(key=lambda x: x[0])
        out: list[list[int]] = []
        for start, end in intervals:
            if out and start <= out[-1][1]:
                out[-1][1] = max(out[-1][1], end)
            else:
                out.append([start, end])
        return out
```

**Key insight:** Sort-by-start is the move that makes this linear after the sort. Without sorting, overlaps can be anywhere and the problem becomes quadratic. The `<=` in the overlap check treats touching intervals (`[1,2]` and `[2,3]`) as mergeable, which matches LeetCode's expected output.

**Common bug:** Setting `out[-1][1] = end` instead of `max(out[-1][1], end)`, which breaks on fully-contained intervals like `[1, 10]` followed by `[2, 3]`. Also using `<` and missing the touching-endpoints case.

**What to say during the round:** "Sort by start. Walk once, merging into the last interval in the output when they overlap, else append. The max on the end is important because of fully-contained intervals."

---

## 16. Subsets (LC #78)

**Pattern:** Backtracking with index pointer
**Time:** O(n * 2^n)
**Space:** O(n) recursion plus output
**Invariant:** At recursion depth d with start index s, `path` holds one prefix of a subset and every recursive call from `s` onward explores a disjoint branch.

```python
from typing import List

class Solution:
    def subsets(self, nums: List[int]) -> List[List[int]]:
        out: list[list[int]] = []
        path: list[int] = []

        def backtrack(start: int) -> None:
            out.append(path.copy())
            for i in range(start, len(nums)):
                path.append(nums[i])
                backtrack(i + 1)
                path.pop()

        backtrack(0)
        return out
```

**Key insight:** The `start` index prevents generating the same subset in different orders, which would both double-count and produce permutations. Appending `path.copy()` at the top of every call (not only at leaves) produces all `2^n` subsets including the empty set and the full set. The append-recurse-pop rhythm is the canonical backtracking shape.

**Common bug:** Appending `path` itself instead of `path.copy()`, which stores a reference that gets mutated by later pops, leaving the output full of empty or half-filled lists. Always copy on append.

**What to say during the round:** "Backtracking with a start index. Each call records the current path as a subset, then recurses on every later index, append-recurse-pop. The start index prevents reordering duplicates. Key detail: copy the path on record."

---

## 17. Word Search (LC #79)

**Pattern:** Grid backtracking with mark-unmark
**Time:** O(m * n * 4^L) where L is word length
**Space:** O(L) recursion
**Invariant:** During a search, every cell in the current path is marked with a sentinel so the DFS cannot reuse it; on backtrack the cell is restored so other paths remain valid.

```python
from typing import List

class Solution:
    def exist(self, board: List[List[str]], word: str) -> bool:
        m, n = len(board), len(board[0])

        def dfs(r: int, c: int, i: int) -> bool:
            if i == len(word):
                return True
            if r < 0 or r >= m or c < 0 or c >= n or board[r][c] != word[i]:
                return False
            tmp = board[r][c]
            board[r][c] = "#"
            found = (
                dfs(r + 1, c, i + 1)
                or dfs(r - 1, c, i + 1)
                or dfs(r, c + 1, i + 1)
                or dfs(r, c - 1, i + 1)
            )
            board[r][c] = tmp
            return found

        for r in range(m):
            for c in range(n):
                if dfs(r, c, 0):
                    return True
        return False
```

**Key insight:** Mark-unmark in place is cheaper than a `visited` set and makes backtracking obvious: the cell is "in the path" while we are below it in the recursion, and "free" otherwise. Using a distinctive sentinel character like `#` makes the content-check guard (`board[r][c] != word[i]`) also serve as the visited check.

**Common bug:** Forgetting to restore `board[r][c] = tmp` on the way out, which permanently blocks cells and causes later starting points to fail. Also returning early on `i == len(word) - 1` plus a match check, which is off-by-one and fragile; the `i == len(word)` base case is cleaner.

**What to say during the round:** "Grid DFS with mark-unmark backtracking. I start from every cell, recurse in four directions only when the letter matches, and restore the cell on the way out. A trie speeds up the multi-word version of this problem, Word Search II."

---

## 18. LRU Cache (LC #146)

**Pattern:** Doubly linked list + hash map
**Time:** O(1) per `get` and `put`
**Space:** O(capacity)
**Invariant:** The doubly linked list is always ordered most-recent at the head, least-recent at the tail; the hash map gives O(1) access to any node.

```python
class _Node:
    def __init__(self, key: int = 0, value: int = 0) -> None:
        self.key = key
        self.value = value
        self.prev: "_Node | None" = None
        self.next: "_Node | None" = None

class LRUCache:
    def __init__(self, capacity: int) -> None:
        self.cap = capacity
        self.map: dict[int, _Node] = {}
        self.head = _Node()
        self.tail = _Node()
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node: _Node) -> None:
        node.prev.next = node.next
        node.next.prev = node.prev

    def _add_front(self, node: _Node) -> None:
        node.next = self.head.next
        node.prev = self.head
        self.head.next.prev = node
        self.head.next = node

    def get(self, key: int) -> int:
        if key not in self.map:
            return -1
        node = self.map[key]
        self._remove(node)
        self._add_front(node)
        return node.value

    def put(self, key: int, value: int) -> None:
        if key in self.map:
            self._remove(self.map[key])
        node = _Node(key, value)
        self.map[key] = node
        self._add_front(node)
        if len(self.map) > self.cap:
            lru = self.tail.prev
            self._remove(lru)
            del self.map[lru.key]
```

**Key insight:** The sentinel head and tail dummy nodes remove every null check inside `_remove` and `_add_front`. Without sentinels I would have to special-case the first and last real nodes on every pointer update, which is where most bugs live. Python's `collections.OrderedDict` with `move_to_end` is the idiomatic shortcut, but interviewers usually want to see the DLL to confirm the candidate understands the structure.

**Common bug:** Forgetting to delete the evicted key from the map, which causes stale references and eventual wrong answers. Also not re-inserting on `put` when the key already exists, which leaves the node in its old LRU position.

**What to say during the round:** "Hash map to nodes plus a doubly linked list with sentinel head and tail. `get` moves the node to the front, `put` inserts at the front and evicts from the back. I mention `OrderedDict` as the one-liner alternative but implement the DLL since that is usually what they are testing."

---

## 19. 3Sum (LC #15)

**Pattern:** Sort + two-pointer
**Time:** O(n squared)
**Space:** O(1) extra (ignoring output)
**Invariant:** After sorting, for each fixed `i` the two pointers `l` and `r` converge while skipping duplicates, so every unique triplet `(nums[i], nums[l], nums[r])` is emitted exactly once.

```python
from typing import List

class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        nums.sort()
        out: list[list[int]] = []
        n = len(nums)
        for i in range(n - 2):
            if nums[i] > 0:
                break
            if i > 0 and nums[i] == nums[i - 1]:
                continue
            l, r = i + 1, n - 1
            while l < r:
                s = nums[i] + nums[l] + nums[r]
                if s == 0:
                    out.append([nums[i], nums[l], nums[r]])
                    l += 1
                    r -= 1
                    while l < r and nums[l] == nums[l - 1]:
                        l += 1
                    while l < r and nums[r] == nums[r + 1]:
                        r -= 1
                elif s < 0:
                    l += 1
                else:
                    r -= 1
        return out
```

**Key insight:** Sorting collapses the problem from O(n cubed) brute force to O(n squared) because the two-pointer sweep is linear per fixed `i`. Duplicate-skipping has to happen at three places: the outer `i`, the inner `l` after a hit, and the inner `r` after a hit. Missing any of the three produces duplicate triplets.

**Common bug:** Forgetting the inner duplicate-skip after a hit, producing outputs like `[[-1, -1, 2], [-1, -1, 2]]`. Also starting the outer skip at `i == 0` with no guard, which skips valid first elements.

**What to say during the round:** "Sort, then fix `i` and two-pointer the rest toward `-nums[i]`. Skip duplicates at `i`, and after each hit advance both pointers past their duplicates. The early break on `nums[i] > 0` is a small optimization because nothing later can sum to zero."

---

## 20. Minimum Window Substring (LC #76)

**Pattern:** Sliding window with need-map
**Time:** O(n + m) where m is `len(t)`
**Space:** O(alphabet)
**Invariant:** `have` counts the number of distinct characters in `t` whose required count is fully met inside the current window; when `have == need` the window is valid and I try to shrink it.

```python
from collections import Counter

class Solution:
    def minWindow(self, s: str, t: str) -> str:
        if not t or not s:
            return ""
        need_count = Counter(t)
        need = len(need_count)
        have = 0
        window: dict[str, int] = {}
        best = (float("inf"), 0, 0)
        l = 0
        for r, c in enumerate(s):
            window[c] = window.get(c, 0) + 1
            if c in need_count and window[c] == need_count[c]:
                have += 1
            while have == need:
                if r - l + 1 < best[0]:
                    best = (r - l + 1, l, r)
                window[s[l]] -= 1
                if s[l] in need_count and window[s[l]] < need_count[s[l]]:
                    have -= 1
                l += 1
        return s[best[1] : best[2] + 1] if best[0] != float("inf") else ""
```

**Key insight:** Tracking `have == need` on the number of fully-satisfied distinct characters avoids comparing two dictionaries on every step, which would make the inner work linear. The window grows by `r` and shrinks by `l`; both pointers only move forward, so the whole sweep is linear.

**Common bug:** Comparing `window == need_count` every iteration instead of maintaining the `have` counter, turning the algorithm into O(n * alphabet) with a very expensive constant. Also decrementing `have` on every `window[s[l]] -= 1` instead of only when it drops below the needed count.

**What to say during the round:** "Classic shrinking window. Grow right, and while valid, shrink left to find the minimum. The `have` counter against `need` tracks satisfied distinct characters so each step is O(1). I track the best window as `(length, l, r)` so I can slice at the end."

---

## 21. Clone Graph (LC #133)

**Pattern:** DFS (or BFS) with clone-map
**Time:** O(V + E)
**Space:** O(V)
**Invariant:** `clones[node]` always exists by the time any neighbor of `node` is processed, so cycles are handled without infinite recursion.

```python
from typing import Optional

class Node:
    def __init__(self, val: int = 0, neighbors: "list[Node] | None" = None):
        self.val = val
        self.neighbors = neighbors if neighbors is not None else []

class Solution:
    def cloneGraph(self, node: Optional[Node]) -> Optional[Node]:
        if node is None:
            return None
        clones: dict[Node, Node] = {}

        def dfs(cur: Node) -> Node:
            if cur in clones:
                return clones[cur]
            copy = Node(cur.val)
            clones[cur] = copy
            for nei in cur.neighbors:
                copy.neighbors.append(dfs(nei))
            return copy

        return dfs(node)
```

**Key insight:** Register the clone in the map before recursing into neighbors. That ordering is what breaks cycles: when the recursion comes back around to a node already being cloned, the map lookup returns the in-progress clone instead of starting a new one. If I register after recursing I get stack overflow on any cycle.

**Common bug:** Creating the clone after the neighbor loop, which recurses forever on any cycle. Also iterating with `for nei in cur.neighbors` and forgetting to attach the returned clone to `copy.neighbors`.

**What to say during the round:** "DFS with a clone map. Create and register the clone before recursing, then recurse into each neighbor. The map breaks cycles. BFS with the same map works identically."

---

## 22. Product of Array Except Self (LC #238)

**Pattern:** Prefix and suffix products in two passes
**Time:** O(n)
**Space:** O(1) extra (output array does not count)
**Invariant:** After the left pass, `out[i]` is the product of everything to the left of `i`; after the right pass, it is multiplied by the product of everything to the right.

```python
from typing import List

class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        n = len(nums)
        out = [1] * n
        left = 1
        for i in range(n):
            out[i] = left
            left *= nums[i]
        right = 1
        for i in range(n - 1, -1, -1):
            out[i] *= right
            right *= nums[i]
        return out
```

**Key insight:** No division is allowed, so I cannot compute the total product and divide out each element. Instead I build the prefix product in one pass and fold the suffix product into the same array on the way back. Both `left` and `right` are single scalars; there are no auxiliary arrays.

**Common bug:** Writing `out[i] *= left` on the first pass, which leaves the original `1` baseline in place and scrambles the prefix. The first pass must assign `out[i] = left`, the second pass multiplies.

**What to say during the round:** "Two passes. Left pass writes the prefix product into `out`. Right pass multiplies by the running suffix. O(1) extra space because I reuse the output array."

---

## 23. Min Stack (LC #155)

**Pattern:** Two stacks, one for values, one for running min
**Time:** O(1) per operation
**Space:** O(n)
**Invariant:** The top of `min_stack` is always the minimum of all values currently in `stack`.

```python
class MinStack:
    def __init__(self) -> None:
        self.stack: list[int] = []
        self.min_stack: list[int] = []

    def push(self, val: int) -> None:
        self.stack.append(val)
        if not self.min_stack or val <= self.min_stack[-1]:
            self.min_stack.append(val)

    def pop(self) -> None:
        val = self.stack.pop()
        if val == self.min_stack[-1]:
            self.min_stack.pop()

    def top(self) -> int:
        return self.stack[-1]

    def getMin(self) -> int:
        return self.min_stack[-1]
```

**Key insight:** The min-stack only grows when a new value is less than or equal to the current min, and shrinks only when that min value is popped from the main stack. The `<=` (not `<`) is essential for duplicates: pushing `[2, 1, 1]` needs both ones on the min stack, otherwise popping one of them drops the min and corrupts the invariant.

**Common bug:** Using `<` instead of `<=` in `push`, which breaks on duplicate mins. Also forgetting to pop the min stack when the popped value equals the current min.

**What to say during the round:** "Two stacks. Main stack holds values, min-stack holds the running minimum. I push to the min-stack only when the new value is less than or equal, and pop from it only when the popped value matches. Less-than-or-equal handles duplicate mins."

---

## 24. Time Based Key-Value Store (LC #981)

**Pattern:** Per-key sorted timestamp list + binary search
**Time:** O(1) set, O(log n) get
**Space:** O(n)
**Invariant:** For each key, timestamps are inserted in strictly increasing order (per the problem contract), so the per-key list is always sorted and supports `bisect`.

```python
import bisect
from collections import defaultdict

class TimeMap:
    def __init__(self) -> None:
        self.times: dict[str, list[int]] = defaultdict(list)
        self.values: dict[str, list[str]] = defaultdict(list)

    def set(self, key: str, value: str, timestamp: int) -> None:
        self.times[key].append(timestamp)
        self.values[key].append(value)

    def get(self, key: str, timestamp: int) -> str:
        if key not in self.times:
            return ""
        arr = self.times[key]
        i = bisect.bisect_right(arr, timestamp)
        if i == 0:
            return ""
        return self.values[key][i - 1]
```

**Key insight:** `bisect_right(arr, timestamp)` returns the insertion point just after any equal timestamps, so `i - 1` is the largest index with `arr[i - 1] <= timestamp`, which is exactly "the latest value at or before `timestamp`". Using two parallel lists instead of a list of tuples keeps `bisect` simple since `bisect` on tuples also works but reads more awkwardly.

**Common bug:** Using `bisect_left` instead of `bisect_right`, which excludes equal timestamps and returns the previous value when an exact match exists. Also forgetting to handle the `i == 0` case (no timestamp at or before the query).

**What to say during the round:** "Per-key parallel lists of timestamps and values, append-only so they stay sorted. `get` does `bisect_right` on the timestamp list and returns `i - 1`, with an empty string if nothing is early enough. O(log n) per `get`."

---

## 25. HitCounter (LC #362)

**Pattern:** Deque of hit timestamps, sliding 300s window
**Time:** O(1) amortized per `hit`, O(window) worst-case per `getHits` during eviction
**Space:** O(hits within window)
**Invariant:** The deque holds every hit timestamp from the last 300 seconds; evictions push old timestamps out on every call.

```python
from collections import deque

class HitCounter:
    def __init__(self) -> None:
        self.hits: deque[int] = deque()

    def hit(self, timestamp: int) -> None:
        self.hits.append(timestamp)

    def getHits(self, timestamp: int) -> int:
        cutoff = timestamp - 300
        while self.hits and self.hits[0] <= cutoff:
            self.hits.popleft()
        return len(self.hits)
```

**Key insight:** Same sliding-window-log structure as the rate limiter but single-tenant. The eviction happens lazily on `getHits` (and could also happen on `hit` if we wanted stricter memory behavior). For very high QPS the interviewer usually asks about the follow-up with buckets: 300 second-buckets of `(timestamp, count)` pairs, which caps memory at O(300) regardless of QPS.

**Common bug:** Using `<` instead of `<=` on the cutoff. The spec says "past 5 minutes" meaning strictly within 300 seconds, so a hit at `timestamp - 300` is already out of the window. Getting this wrong is a one-off error that slips through easy cases.

**What to say during the round:** "Deque of timestamps. `hit` appends, `getHits` evicts anything at or before `timestamp - 300` then returns the length. Amortized O(1) per hit. I mention the 300-bucket variant for the high-QPS follow-up where I do not want per-hit memory."

---

## Last 48 hours — muscle-memory refresh (night of May 11)

Pick these five for the final drill the night before the prep buffer. They are chosen for typo risk and pattern density, not difficulty. If I can type all five clean on a blank Doc in 90 minutes, the patterns are set.

1. **LRU Cache (18).** The doubly linked list is the longest thing I will have to type. Repetition is the only way to keep the sentinel setup and the `_remove` / `_add_front` pointer updates typo-free.
2. **Minimum Window Substring (20).** The `have` versus `need` bookkeeping has the highest off-by-one density of any problem in the set. One retype the night before prevents a freeze on round day.
3. **Search in Rotated Sorted Array (04).** The two-halves-one-sorted invariant is easy to botch with wrong inequality directions. Retyping locks the `<=` positions.
4. **3Sum (19).** Three duplicate-skip blocks in three different places; muscle memory matters.
5. **Course Schedule (11).** Kahn's scan is short but the edge direction confusion (`[a, b]` means `b -> a`) is the kind of silent bug that only pattern recognition catches.

---

## What NOT to type on a Google Doc

On a plain Doc with no syntax highlighting and no execution, clarity beats cleverness every time. These Python patterns look good in an IDE and turn into bug factories on a Doc under time pressure.

- **Nested comprehensions three levels deep.** `[[x for x in row if x > 0] for row in matrix if any(row)]` is readable in a file. On a Doc it hides the iteration order and makes off-by-ones invisible. Write a normal `for` loop.
- **Walrus operator `:=`.** Clever in `while (chunk := f.read(8192)):`. On a Doc the interviewer has to parse the assignment-and-test and you lose narration time. Use a regular loop.
- **`functools.reduce`.** Every `reduce` call can be a three-line loop with a named accumulator that the interviewer can follow at a glance. Use the loop.
- **`filter(None, iterable)`.** Relies on Python's truthiness rules and silently drops `0`, `""`, `[]`, `False`, and `None` together. A list comprehension with an explicit `if x is not None` or `if x` shows intent.
- **Lambda with a `key` that has a ternary.** `sorted(xs, key=lambda x: x if x > 0 else -x)` is fine on a good day. Under pressure this gets typed wrong. Define `abs_val` as a `def` or use `abs`.
- **Chained ternaries.** `a if cond1 else b if cond2 else c` parses ambiguously in readers' heads. An `if`/`elif`/`else` is three extra lines and zero cognitive cost.
- **`*args, **kwargs` when not needed.** Adds noise to signatures and invites type questions. Spell out the parameters.
- **Dict comprehension with a conditional expression inside the value.** Same issue as chained ternaries; split into a loop.
- **List/set/dict comprehension with side effects.** `[print(x) for x in ...]` or comprehensions that mutate a shared list. Confusing and hard to narrate.
- **`else` on a `for` loop.** Valid Python. Almost nobody remembers what it does under interview pressure. Use a boolean flag.

The rule of thumb: if I cannot read my line aloud in one breath and have the interviewer parse it correctly, rewrite it.

---

## Morning warmup block (retype every day)

Retype the ten lines below on a blank Doc every morning of prep. The goal is not to run the code; the goal is to prime the four-line imports, the Solution-class shape, the type hints, and the `defaultdict`/`deque` instincts so that on round day none of this surface-level mechanics costs me thinking cycles.

```python
from collections import defaultdict, Counter, deque
import heapq
from functools import lru_cache
from typing import List, Optional, Dict, Tuple
import bisect

class Solution:
    def solve(self, nums: List[int]) -> int:
        seen: dict[int, int] = {}
        q: deque[int] = deque()
        return 0
```

If I can type this from memory in under 30 seconds with no typos, I have recovered the baseline fluency I need for the round. If I hit a typo, I retype until I do not. Then I pick the day's problem from `05_CODING_PROBLEM_SET.md` and start on a fresh Doc.
