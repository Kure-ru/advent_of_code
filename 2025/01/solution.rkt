#lang racket

(require racket/file
     racket/list
     racket/string)

;; -------------------------
;; DATA STRUCTURES
;; -------------------------

;; Direction: L or R
;; Steps [0, 99]
(define-struct click (direction distance) #:transparent)


;; -------------------------
;; READ & PARSE INPUT FILE
;; -------------------------

(define input-str (file->string "input.txt"))

;; string -> Click
;; convert a string input into a Click
(define (input->click str)
    (make-click (string-ref str 0)
               (string->number (substring str 1))))

;; string -> list of clicks
(define clicks
    (map input->click (string-split input-str "\n")))

;; -------------------------
;; FUNCTIONS
;; -------------------------

;; number list-of-clicks -> values (final-pos zero-count)
;; Count the number of times the dial passes through 0
(define (count-zeros start clicks)
  (for/fold ([pos start]
             [zero-count 0])
            ([c clicks])
    (define dir (click-direction c))
    (define dist (click-distance c))
    (define step (if (char=? dir #\R) 1 -1))
    ; list of intermediate positions dial passes during this click
    (define path
      (for/list ([i (in-range 1 (+ dist 1))])
        (modulo (+ pos (* i step)) 100)))
    (define new-zero-count (+ zero-count (length (filter (lambda (p) (= p 0)) path))))
    (values (last path) new-zero-count)))

;; -------------------------
;; EXECUTION
;; -------------------------
(define-values (final-pos zeros) (count-zeros 50 clicks))

(displayln (format "Final position: ~a" final-pos))
(displayln (format "Times passed 0: ~a" zeros))
