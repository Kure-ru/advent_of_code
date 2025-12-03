# --- Day 3: Lobby ---

## Problem

- Given a string of digits, e.g., `"98765432111111"`
- Pick 12 digits (in order) to form the largest 12-digit number

Brute-force: all 12-element combinations

> 20 digits → 125,970 combinations\
> 30 digits → 86,493,225 combinations

→ **WAY too slow for large strings**

## Observations

1. We don't need all combinations
2. To make the largest number, just pick **largest digits in order**
3. This is a **greedy problem**

## How greedy approach works

1. Start from **left of string**
2. For first digit, only look at first `n - (k-1)` digits

   `n = length of string`\
   `k = digits left to pick`

3. Pick largest digit in that slice
4. Remove that digit, repeat for next position

> This works because the problem has optimal substructure: the largest 12-digit number contains the largest 11-digit number from the remaining string.

## When to use greedy?

### ✅ Pros

- Fast `0(n * k)` instead of combinatorial
- Simple
- Memory efficient as there is no need to store all combinations
- Greedy can provide good approximate solutions quickly

### ❌ Cons

- Doesn’t always guarantee global optimum
- Must check for **optimal substructure**
- Cannot backtrack if choice is wrong

## Recap

- Greedy algorithms optimize locally, hoping to end up with a global optimum.
- If you have an NP-hard problem, your best bet is to use an approximation algorithm.
- Greedy algorithms are easy to write and fast to run, so they make good approximation algorithms.

#### Sources:

- [Bhargava, A. (2024) Greedy algorithms. _Grokking Algorithms, Second Edition_, Manning Publications](https://learning.oreilly.com/library/view/grokking-algorithms-second/9781633438538/)
