#lang racket (require racket/file
                      racket/list
                      racket/string)

;; DATA STRUCTURES

;; Direction: L or R
;; Steps [0, 99]
(define-struct click (direction distance) #:transparent)

(define input-str (file->string "input.txt"))

;; string -> Click
;; convert a string input into a click
(define (input->click str)
    (make-click (string-ref str 0)
    (string->number (substring str 1))))

;; list of clicks
(define clicks
    (map input->click
        (string-split input-str "\n")))

;; rotate all list of clicks
(define (rotate-loc start loc)
(cond [(empty? loc) start]
      [#t (define new-pos (rotate start (car loc)))
                          (rotate-loc new-pos (cdr loc))]))

;; number -> number
;; if number = 0, count 1
(define (count-zeros start clicks)
    (for/fold
        ([pos start]
         [zero-count 0])
         ([c clicks ])
        (define new-pos (rotate pos c))
            (values new-pos (if (= new-pos 0) (add1 zero-count) zero-count))))

;; pos Click -> Pos
;; give a new position from a starting pos and a given pos
(define (rotate start click)
    (if (char=? (click-direction click) #\R)
    (check-num (+ start (click-distance click)))
    (check-num (- start (click-distance click)))))

;; number -> number
(define (check-num num)
    (modulo num 100))

;; Print solution
(define-values (final-pos zeros) (count-zeros 50 clicks))
(displayln (format "Final position: ~a" final-pos))
(displayln (format "Times at 0: ~a" zeros))