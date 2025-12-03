# --- Day 1: Secret Entrance ---

## Goal

Simulate a dial from 0-99 that rotates left/right and count how many times it passes through 0.

Treat the dial as a cyclic data value and apply each click one step at a time.

## Dial logic

The dial is integers **mod 100**.

In mathematical terms:\
`new-pos=(pos+step)mod100`

Unlike C or Java, Racket's [modulo](https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._modulo%29%29) matches **Euclidean division rules**, meaning: `(modulo a b)` returns a remainder `0 <= r < |b|`.

For the wraparound:

- if the dial goes left from 0, `(modulo -1 100)` → 99
- if we go right from 99, `(modulo 100 100)` → 0

#### Sources:

[Kneusel R. (2025) Number Theory, _Math for Programming_, No Starch Press](https://learning.oreilly.com/library/view/math-for-programming/9798341620063/)
