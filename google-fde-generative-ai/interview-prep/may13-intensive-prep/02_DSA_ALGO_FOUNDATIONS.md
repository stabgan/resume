# DSA And Algorithms Foundations

This is the revision sheet before problem volume. Read it, then solve.

## Complexity You Must Say Cleanly

- Array scan: O(n), O(1) space.
- Hash map lookup: average O(1), worst-case O(n), usually say average O(1).
- Sorting: O(n log n).
- Binary search: O(log n).
- Heap push/pop: O(log k) for heap size k.
- BFS/DFS graph: O(V + E).
- Grid DFS/BFS: O(rows * cols).
- DP: usually O(states * transition cost).
- Backtracking: exponential, explain branching factor and depth.

Python costs:

- `list.append`: amortized O(1).
- `list.pop()`: O(1).
- `list.pop(0)`: O(n), avoid.
- `deque.popleft`: O(1).
- `x in set/dict`: average O(1).
- slicing `s[i:j]`: O(length).
- string concatenation in loop: can become O(n^2); use list and join.

## Core Data Structures

### Array / List

Use for:

- Ordered data.
- Two pointers.
- Prefix sums.
- Binary search.
- DP arrays.

Pitfalls:

- Index boundaries.
- Mutating while iterating.
- Confusing value vs index.

### String

Patterns:

- Character frequency.
- Sliding window.
- Stack for parentheses.
- Expand around center.
- Prefix encoding.
- Trie for many prefixes.

Pitfalls:

- Slicing cost.
- Unicode not usually tested unless asked.
- Immutable; build output with list.

### Hash Map / Set

Use for:

- Count/group.
- Seen/complement.
- Index lookup.
- Visited states.
- Memoization.

Invariants:

- What is key?
- What is value?
- When do you update?
- Can duplicates change answer?

### Stack

Use for:

- Parentheses.
- Monotonic next greater/smaller.
- DFS iterative.
- Undo/backtracking state.
- Parsing.

Template:

```python
stack = []
for x in items:
    while stack and should_pop(stack[-1], x):
        stack.pop()
    stack.append(x)
```

### Queue / Deque

Use for:

- BFS.
- Sliding window timestamps.
- Level-order traversal.
- Rate limiter.

### Heap

Use for:

- Top K.
- Merge K sorted lists.
- Running median.
- Scheduling.
- Dijkstra.

Python:

- `heapq` is min-heap.
- Use negative values for max-heap.
- Keep heap size k for O(n log k).

### Linked List

Use for:

- LRU cache internals.
- Reversal.
- Cycle detection.
- Merge lists.

Core moves:

- Reverse pointers.
- Fast/slow pointer.
- Dummy head.

### Tree

Core traversal:

- Preorder: process, left, right.
- Inorder: left, process, right.
- Postorder: left, right, process.
- BFS: level order.

Recursive DFS shape:

```python
def dfs(node):
    if not node:
        return base
    left = dfs(node.left)
    right = dfs(node.right)
    return combine(node, left, right)
```

Senior signal:

> I need to distinguish what the helper returns to its parent from what global answer it updates.

### Graph

Representations:

- Adjacency list: `dict[node] -> list[node]`.
- Matrix/grid: implicit neighbors.
- Edge list: useful for union-find or Bellman-Ford.

BFS:

- Shortest path in unweighted graph.
- Level expansion.

DFS:

- Connected components.
- Cycle detection.
- Backtracking.

Topo:

- Directed acyclic dependencies.
- Course Schedule.

Union-Find:

- Dynamic connectivity.
- Redundant connection.
- Kruskal.

## Algorithm Patterns

### Two Pointers

Signal:

- Sorted array.
- Pair/triplet.
- Palindrome.
- In-place compaction.

Invariant:

- Moving one pointer discards impossible candidates.

Problems:

- Two Sum II.
- 3Sum.
- Container With Most Water.
- Trapping Rain Water.

### Sliding Window

Signal:

- Contiguous substring/subarray.
- Longest/shortest with condition.

Invariant:

- Window `[left, right]` is valid, or we shrink until valid.

Problems:

- Longest Substring Without Repeating.
- Longest Repeating Character Replacement.
- Minimum Window Substring.
- Permutation in String.

### Prefix Sum

Signal:

- Range sums.
- Subarray sum equals k.
- Need O(1) range query.

Invariant:

- `sum(i..j) = prefix[j] - prefix[i-1]`.

Problems:

- Subarray Sum Equals K.
- Product Except Self.
- Range Sum Query.

### Binary Search

Signal:

- Sorted.
- "Minimum X such that condition true."
- Search answer space.

Invariant:

- The answer remains inside `[left, right]`.

Problems:

- Binary Search.
- Search Rotated Sorted Array.
- Find Minimum Rotated.
- Koko Eating Bananas.
- Median of Two Sorted Arrays (stretch).

### Monotonic Stack

Signal:

- Next greater/smaller.
- Daily temperatures.
- Histogram.

Invariant:

- Stack is monotonic by value or index.

Problems:

- Daily Temperatures.
- Largest Rectangle in Histogram.
- Car Fleet.

### Tree DFS

Signal:

- Path.
- Height.
- LCA.
- Validate BST.

Questions:

- What does the helper return?
- Do I need global max?
- Is null base 0, -inf, True, or None?

### Graph BFS/DFS

Signal:

- Grid islands.
- Word transformations.
- Dependencies.
- Reachability.

Questions:

- Is graph directed?
- Is shortest path required?
- Are cycles possible?
- What is a node?

### Topological Sort

Signal:

- Prerequisites.
- Build order.
- Dependency resolution.

Kahn template:

- Build indegree.
- Queue zero-indegree.
- Pop, decrement neighbors.
- If processed count != n, cycle.

### Backtracking

Signal:

- Generate all.
- Choose/explore/unchoose.
- Constraints prune search.

Template:

```python
def backtrack(path, start):
    if complete(path):
        result.append(path[:])
        return
    for i in range(start, len(choices)):
        path.append(choices[i])
        backtrack(path, i + 1)
        path.pop()
```

### Dynamic Programming

Signal:

- Count ways.
- Best min/max over choices.
- Repeated subproblems.

Steps:

1. Define state.
2. Define transition.
3. Define base case.
4. Define answer.
5. Decide iteration order.

Common states:

- `dp[i]`: best/count up to i.
- `dp[i][j]`: best/count using prefixes.
- `dp[node]`: tree DP.
- `memo(index, remaining)`: recursion + cache.

### Greedy

Signal:

- Local choice can be proven safe.
- Intervals.
- Scheduling.
- Jump Game.

Always explain why greedy is safe.

## Python Interview Toolkit

Imports to know:

```python
from collections import defaultdict, Counter, deque
import heapq
from functools import lru_cache
```

Common patterns:

```python
counts = Counter(s)
groups = defaultdict(list)
queue = deque([start])
heapq.heappush(heap, item)
item = heapq.heappop(heap)
```

Avoid:

- Overusing clever comprehensions.
- Writing one-liners that are hard to dry-run.
- Using library functions that hide the algorithm if the problem tests it.

## No-Run Debug Checklist

Before saying done:

- Empty input?
- One item?
- Duplicate values?
- Negative values?
- All same?
- No valid answer?
- Boundary index?
- Did I update visited at the right time?
- Does recursion terminate?
- Does binary search shrink every iteration?
- Does heap size stay bounded?
- Did I state time/space?

## What To Memorize Cold

Code shapes:

- Binary search.
- BFS with deque.
- DFS grid.
- Tree DFS.
- Sliding window.
- Topological sort.
- Backtracking.
- 1-D DP.
- LRU invariant.
- Rate limiter invariant.

You do not need to memorize every solution. You need to memorize invariants and templates.
