#lang racket

(require racket/file
         racket/list
         racket/string)

;; ------------------------------------------------------------
;; CONSTANTS
;; ------------------------------------------------------------

(define input (file->string "input.txt"))

;; ------------------------------------------------------------
;; FUNCTIONS
;; ------------------------------------------------------------

;; parse-input : String -> (listof String)
;; Split raw input into comma-separated range strings
(define (parse-input str)
  (string-split str ","))

;; split-range-string : String -> (list String String)
;; Convert "A-B" into '(A B)
(define (split-range-string s)
  (string-split s "-"))

;; split-ids : (listof String) -> (listof (list String String))
;; Apply split-range-string to each element
(define (split-ids los)
  (map split-range-string los))

;; expand-range : (list String String) -> (listof Natural)
;; Convert '( "5" "10" ) → '(5 6 7 8 9 10)
(define (expand-range pr)
  (define start (string->number (string-trim (first pr))))
  (define end   (string->number (string-trim (second pr))))
  (range start (add1 end)))

;; is-invalid-id? : Natural -> Boolean
;; An ID is invalid if it consists of some substring repeated twice
;; (e.g. 1212, 5050, 9999, 123123)
;;
;; HtDF recipe:
;;   - convert number to string
;;   - if odd length → cannot be doubled → valid (#f)
;;   - split into halves
;;   - compare halves
(define (is-invalid-id? id)
  (let* ([string-id (number->string id)]
         [l (string-length string-id)])
    (define (repeat-append pattern n)
      (define (repeat-append-inner str n)
        (if (<= n 0)
            str
            (repeat-append-inner (string-append str pattern) (- n 1))))
      (repeat-append-inner "" n))
    (define (check-pattern p)
      (cond
        [(> p (floor (/ l 2))) #f]
        [(zero? (modulo l p))
         (let* ([repetition-count (/ l p)]
                [pattern (substring string-id 0 p)]
                [repeated (repeat-append pattern repetition-count)])
           (if (and (>= repetition-count 2) (string=? repeated string-id))
               #t
               (check-pattern (+ p 1))))] ; recurse
        [else (check-pattern (+ p 1))])) ; recurse if modulo fails
    (check-pattern 1)))


;; find-invalid-ids : (listof Natural) -> (listof Natural)
;; Structural recursion
(define (find-invalid-ids lon)
  (cond [(empty? lon) '()]
        [(is-invalid-id? (car lon))
         (cons (car lon)
               (find-invalid-ids (cdr lon)))]
        [else (find-invalid-ids (cdr lon))]))


;; ------------------------------------------------------------
;; MAIN
;; ------------------------------------------------------------

(define range
  (split-ids (parse-input input)))

(define all-ids
  (apply append (map expand-range ranges)))

(define invalid-ids
  (find-invalid-ids all-ids))

(displayln (apply + invalid-ids))
