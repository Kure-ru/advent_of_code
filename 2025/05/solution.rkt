#lang racket

(require racket/file
         racket/list
         racket/string)

;; -------------------------------------------------------------------
;; Reading input
;; -------------------------------------------------------------------

(define input-text (file->string "input.txt"))

(define input-sections (string-split input-text "\n\n"))

(define range-lines (string-split (first input-sections) "\n"))

;; -------------------------------------------------------------------
;; Parsing
;; -------------------------------------------------------------------

;; parse a single line like "3-5" into a range (cons start end)
(define (parse-range s)
  (define parts (string-split s "-"))
  (cons (string->number (first parts))
        (string->number (second parts))))

;; all ranges sorted by start
(define ranges
  (sort (map parse-range range-lines)
        < #:key car))

;; -------------------------------------------------------------------
;; Merging intervals
;; -------------------------------------------------------------------

;; merge a list of sorted ranges into non-overlapping ranges
;; sorted-ranges: list of (cons integer integer)
;; returns list of merged ranges
(define (merge-ranges sorted-ranges)
  (cond
    [(empty? sorted-ranges) '()]
    [(empty? (rest sorted-ranges)) sorted-ranges]
    [else
     (define r1 (first sorted-ranges))
     (define r2 (second sorted-ranges))
     (if (<= (car r2) (add1 (cdr r1))) ; overlap or adjacent
         (merge-ranges (cons (cons (car r1) (max (cdr r1) (cdr r2)))
                             (rest (rest sorted-ranges))))
         (cons r1 (merge-ranges (rest sorted-ranges))))]))

(define merged-ranges (merge-ranges ranges))

;; -------------------------------------------------------------------
;; Counting
;; -------------------------------------------------------------------

(define (range-size r)
  (+ 1 (- (cdr r) (car r))))

(define total-unique-ids
  (for/sum ([r merged-ranges])
    (range-size r)))

;; -------------------------------------------------------------------
;; Output
;; -------------------------------------------------------------------

(displayln "Total unique IDs:")
(displayln total-unique-ids)
