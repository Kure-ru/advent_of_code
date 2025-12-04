#lang racket

(require racket/file
         racket/list
         racket/string)

;; =======================
;; Data Definitions
;; =======================

;; A Grid is a (listof (listof Char))
;; Rows and columns can be derived from the grid
;; Read grid from file
(define grid
  (map string->list
       (string-split (file->string "input.txt") "\n")))

(define rows (length grid))
(define cols (length (car grid)))

;; Directions for 8 neighbors
(define OFFSETS
  '((-1 -1) (0 -1) (1 -1)
    (-1  0)        (1  0)
    (-1  1) (0  1) (1  1)))

;; =======================
;; Helper Functions
;; =======================

;; grid-ref: Grid Number Number -> (U Char #f)
;; Returns the character at (x, y) or #f if out of bounds
(define (grid-ref grid x y)
  (define rows (length grid))
  (define cols (length (car grid)))
  (if (and (>= x 0) (< x cols)
           (>= y 0) (< y rows))
      (list-ref (list-ref grid y) x)
      #f))

;; roll-of-paper?: Char -> Boolean
(define (roll-of-paper? c)
  (and (char? c) (char=? c #\@)))

;; find-neighbors: Grid Number Number -> (listof (U Char #f))
(define (find-neighbors grid x y)
  (map (λ (offset)
         (match-define (list dx dy) offset)
         (grid-ref grid (+ x dx) (+ y dy)))
       OFFSETS))

;; count-roll-neighbors: (listof (U Char #f)) -> Number
(define (count-roll-neighbors neighbors)
  (count roll-of-paper? neighbors))

;; accessible?: Grid Number Number -> Boolean
;; A roll is accessible if it exists and has fewer than 4 neighboring rolls
(define (accessible? grid x y)
  (and (roll-of-paper? (grid-ref grid x y))
       (< (count-roll-neighbors (find-neighbors grid x y)) 4)))

;; =======================
;; Core Functions
;; =======================

;; remove-rolls: Grid -> (Values Grid Number)
;; Produces a new grid where accessible rolls are removed (marked #\x)
;; Returns number of removed rolls as well
(define (remove-rolls grid)
  (define-values (new-grid removed)
    (for/fold ([rows '()] [removed 0])
              ([y (in-range rows)])
      (define-values (new-row row-removed)
        (for/fold ([cells '()] [r 0])
                  ([x (in-range cols)])
          (if (accessible? grid x y)
              (values (cons #\x cells) (+ r 1))
              (values (cons (grid-ref grid x y) cells) r))))
      ;; Add row to rows accumulator
      (values (cons (reverse new-row) rows) (+ removed row-removed))))
  (values (reverse new-grid) removed))


;; remove-until-none: Grid -> Number
;; Repeatedly remove accessible rolls until none remain
(define (remove-until-none grid)
  (define-values (new-grid removed) (remove-rolls grid))
  (if (zero? removed)
      0
      (+ removed (remove-until-none new-grid))))

;; =======================
;; Run
;; =======================

(define total-removed (remove-until-none grid))
(displayln total-removed)
