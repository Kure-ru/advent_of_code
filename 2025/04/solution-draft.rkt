#lang racket

(require racket/file
         racket/list
         racket/string)

(define grid
    (map string->list
        (string-split (file->string "input.txt") "\n")))

(define rows (length grid))
(define cols (length (car grid)))

;; Grid Number Number -> Char | Boolean
;; Use the row index (y-coordinate) to choose a row,
;; and the column index (x-coordinate) to choose a character within that row.
;; returns #f if coordinate is out of bounds
(define (grid-ref grid x y)
    (and (<= 0 y (sub1 rows))
         (<= 0 x (sub1 cols))
         (list-ref (list-ref grid y) x)))

;Define the eight directional offsets you want to examine.
;These represent the eight neighboring positions around a cell: up, down, left, right, and the four diagonals.
(define OFFSETS
  '((-1 -1) (0 -1) (1 -1)
    (-1  0)        (1  0)
    (-1  1) (0  1) (1  1)))

; Grid Char Char -> List of Char
;Find the eight neighbors of a position:
(define (find-neighbors grid x y)
    (for/list ([offset OFFSETS])
        (match-define (list dx dy) offset)
        (grid-ref grid (+ x dx) (+ y dy))))

;; Char -> Boolean
(define (roll-of-paper? c) (and (char? c) (char=? c #\@)))

;; Count neighbors that are rolls of paper (@)
(define (count-roll-neighbors neighbors)
  (count (λ (c) (and (char? c) (char=? c #\@))) neighbors))

(define (accessible? grid x y)
    (let ([c (grid-ref grid x y)])
    (and (roll-of-paper? c)
        (< (count-roll-neighbors (find-neighbors grid x y)) 4))))

(define (total-accessible-rolls)
    (for*/sum ([y (in-range rows)]
              [x (in-range cols)])
            (if (accessible? grid x y) 1 0)))

(displayln (total-accessible-rolls))
(displayln (accessible? grid 2 0))

(for ([y (in-range rows)])
  (for ([x (in-range cols)])
    (display (if (accessible? grid x y) #\x (grid-ref grid x y))))
  (newline))
