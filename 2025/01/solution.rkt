#lang racket

(require racket/file
         racket/list
         racket/string)

;; -------------------------
;; DATA STRUCTURES
;; -------------------------

(define-struct click (direction distance) #:transparent)
(define-struct state (pos zeros) #:transparent)

;; -------------------------
;; FUNCTIONS
;; -------------------------

;; String -> Click
(define (parse-click str)
  (make-click (string-ref str 0)
              (string->number (substring str 1))))

;; Number Char -> Number
(define (step pos direction)
  (define delta (if (char=? direction #\R) 1 -1))
  (modulo (+ pos delta) 100))

;; Number Click -> (listof Number)
(define (click-path start c)
  (define dir (click-direction c))
  (define dist (click-distance c))
  (define (next-pos n pos)
    (if (zero? n)
        '()
        (let ([new-pos (step pos dir)])
          (cons new-pos (next-pos (sub1 n) new-pos)))))
  (next-pos dist start))

;; Number (listof Click) -> State
(define (count-zeros start clicks)
  (foldl
   (λ (c st)
     (define pos   (state-pos st))
     (define zeros (state-zeros st))
     (define path  (click-path pos c))
     (make-state (last path)
                 (+ zeros (length (filter zero? path)))))
   (make-state start 0)
   clicks))

;; -------------------------
;; EXECUTION
;; -------------------------

(define clicks
  (map parse-click (string-split (file->string "input.txt") "\n")))

(define st (count-zeros 50 clicks))

(displayln (format "Final position: ~a" (state-pos st)))
(displayln (format "Times passed 0: ~a" (state-zeros st)))
