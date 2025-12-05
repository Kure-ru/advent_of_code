#lang racket

(require racket/file
         racket/list
         racket/string
         racket/set)

(define input (string-split (file->string "input.txt") "\n\n" ))

(define range-lines (string-split (first input) "\n"))
(define available-ingredients (map string->number (string-split (second input) "\n")))

;3-5  -> '(3 . 5)
(define (parse-range r)
 (cons (string->number (first r))
    (string->number (second r))))

(define ranges
  (map (λ (line)
         (parse-range (string-split line "-")))
       range-lines))

;; Check if x is inside ANY range: low <= x <= high
(define (in-any-range? x ranges)
    (for/or ([r ranges])
        (and (<= (car r) x)
        (<= x (cdr r)))))

(define (sum-food ranges ingredients)
    (for/sum ([i ingredients])
        (if (in-any-range? i ranges) 1 0)))

(displayln (sum-food ranges available-ingredients))
