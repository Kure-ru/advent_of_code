# --- Day 2: Gift Shop ---

## Problem

Detecting repeated substrings (e.g., "1212" = "12" repeated).

## Core Idea

Some strings are formed by taking a substring X and repeating it:

- Part 1: "X X" (exactly twice)
- Part 2: "X X X ..." (two or more times)

Regex captures this pattern directly using:

`(.+)` → capture some non-empty substring

`\1` → refer back to that exact substring

`\1+` → refer back one or more times

`^` and `$` → enforce full-string match

When adding everything together:

- X repeated exactly once (XX)\
  `#px"^(.+)\\1$"`

- X repeated 2+ times\
  `#px"^(.+)\\1+$"`

> Important: Racket strings require escaping \ → \\1.

## Why This Approach Fits the Problem

The puzzle is literally:
_“Does this digit string consist of repeated copies of one substring?”_

Regex can describe this pattern exactly.
No loops, no slicing, no combinatorics.

Racket’s regexp-match? is fast and built for exactly this type of pattern recognition.

So instead of:

- checking all divisors of the string length

- trying every possible substring size

- comparing segments manually

We just let the regex engine do it.

## How to Use in Racket

1. Compile the regex using `#px`

   ```lisp
   (define repeated-twice #px"^(.+)\\1$")

   (define repeated-at-least2 #px"^(.+)\\1+$")
   ```

2. Convert number → string

   ```lisp
   (define s (number->string n))
   ```

3. Test it

   ```lisp
   (regexp-match? repeated-twice s)
   (regexp-match? repeated-at-least2 s)
   ```

4. Filter and sum
   ```lisp
   (for/sum ([n all-ids]
   #:when (regexp-match? repeated-at-least2 (number->string n)))
   n)
   ```

## Pros of Using Regex

- Expressive: backreferences match repeated structure with almost no code.

- Declarative: describe what you want, not how to compute it.

- Optimized: Racket’s regex engine is implemented in C — much faster than hand-rolled substring loops.

- Easy to modify: Part 1 → Part 2 required adding one character: `\1` → `\1+`

## Cons of Using Regex

- Requires learning the notation: `^(.+)\\1+$` isn’t exactly “beginner-friendly”.
- Backreferences are not true regular language features
- Some regexes can get slow on pathological inputs
  (not an issue here, but worth knowing).
- Sometimes plain string functions (substring, string-contains?, etc.) are clearer.
- Debugging complex patterns is painful

## When to Use Regex in Racket

Use regex when:

- The problem is fundamentally about string structure

- You need to detect repeated patterns or symmetric patterns

- Manual decomposition would involve many small steps

- Input size is large enough that efficiency matters

Avoid when:

- Patterns are nested or require counting beyond repetition

- Readability is more important than compactness

- You can solve the problem more clearly with normal recursion or higher-order functions
