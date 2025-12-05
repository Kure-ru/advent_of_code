# --- Day 5: Cafeteria ---

## Problem

Given a list of integer intervals, merge all overlapping or adjacent intervals so that each unique number is represented exactly once.

Example input:
`[3,5], [10,14], [16,20], [12,18]`

Merged intervals: `[3,5], [10,20]`

The goal is to count or process all elements efficiently without double-counting overlapping ranges.

## Observations

Intervals can be represented as pairs `[start, end]`.

Overlaps occur when `current.start <= previous.end + 1` (adjacent or overlapping)

Otherwise, the intervals are **disjoint**.

Proper interval representation avoids creating huge lists of individual numbers.

## Merge Intervals

1. Sort intervals by start

2. Iterate through sorted intervals:

   - If current interval overlaps or touches the last merged interval → merge them
   - Else → add current interval to merged list

```lisp
(define (merge-ranges ranges)
  ;foldl builds a new list of merged intervals
  (foldl (lambda (r acc)
           (match acc
             ['() (list r)]
             [(cons last rest)
              (if (<= (car r) (+ (cdr last) 1))
                  (cons (cons (car last) (max (cdr last) (cdr r))) rest)
                  (cons r acc))]))
         '()
         ranges))
```

## Time Complexity = O(n log n)

Expanding each interval into individual elements would be O(sum of lengths), which can be huge. Interval representation avoids that.

## Real-World Applications

- Scheduling: merge overlapping meetings
- Resource allocation: track occupied time slots or ID ranges
- Graph algorithms: store visited nodes as interval sets for dense node IDs
- Memory management: compact ranges of allocated addresses

#### Sources:

- [ERWIG M. Diets for fat sets. Journal of Functional Programming. 1998;8(6):627-632. doi:10.1017/S0956796898003116](https://www.cambridge.org/core/journals/journal-of-functional-programming/article/diets-for-fat-sets/A4574A4130665EE6CF4FAE35FD302469)
