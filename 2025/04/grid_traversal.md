# --- Printing Department ---

## Problem

Given a 2D grid of cells. Each cell can have properties, e.g., empty, obstacle, target.
Find or remove path based on neighbors.

> A grid of paper rolls (@) and floor (.), where forklifts can access rolls only if fewer than 4 neighboring rolls exist.

## Observations

A 2D grid can be modeled as a graph:

- Each cell = node
- Edges = connections to neighbors (4-way or 8-way)

> Iterating over all cells repeatedly can be slow, but grids are usually small and finite → okay for brute-force in many cases.

## Traversal Techniques

### Breadth-First Search (BFS)

Explores neighbors level by level.

**Useful for:**

- Finding shortest paths

- Layered processing (like removing accessible rolls layer by layer)

### Depth-First Search (DFS)

Explores as far as possible along one branch, then backtracks.

Useful for:

- Checking connectivity

- Flood-fill type operations (e.g., coloring regions)

## Neighbor Iteration

To process each cell, check neighbors:

```lisp
(define OFFSETS '((-1 -1) (0 -1) (1 -1)
                  (-1  0)        (1  0)
                  (-1  1) (0  1) (1  1)))
```

Access neighbors safely to avoid out-of-bounds errors:

```lisp
(define (grid-ref grid x y)
  (if (and (>= x 0) (< x cols) (>= y 0) (< y rows))
      (list-ref (list-ref grid y) x)
      #f))
```

## Fixed-Point Iteration on Grids

Some grid problems require repeated updates until no changes occur.

> Example: removing accessible paper rolls until no accessible rolls remain.

**Repeatedly apply a function F(grid) until F(grid) = grid.**

```lisp
(define (remove-until-none grid)
  (define-values (new-grid removed) (remove-rolls grid))
  (if (zero? removed)
      0
      (+ removed (remove-until-none new-grid))))
```

## Complexity

- Naive iteration: O(rows \* cols) per pass.
- Number of passes ≤ number of removable items (finite).

#### Sources:

- [Bhargava, A. (2024) Greedy algorithms. _Grokking Algorithms, Second Edition_, Manning Publications](https://learning.oreilly.com/library/view/grokking-algorithms-second/9781633438538/)
