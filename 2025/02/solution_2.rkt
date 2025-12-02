#lang racket

(require racket/file
         racket/list
         racket/string)

;; ============================================================
;; CONSTANTS
;; ============================================================

(define input (file->string "input.txt"))

;; ============================================================
;; HELPERS
;; ============================================================

;; parse-input : String -> (listof String)
;; Split raw input into comma-separated range strings.
(define (parse-input str)
  (string-split str ","))

;; split-range-string : String -> (list String String)
;; Convert "A-B" into '(A B)
(define (split-range-string s)
  (string-split s "-"))

;; split-ids : (listof String) -> (listof (list String String))
;; Apply split-range-string to each element.
(define (split-ids los)
  (map split-range-string los))

;; expand-range : (list String String) -> (listof Natural)
;; Convert '( "5" "10" ) → '(5 6 7 8 9 10)
(define (expand-range pr)
  (define start (string->number (string-trim (first pr))))
  (define end   (string->number (string-trim   (second pr))))
  (range start (add1 end)))


;; ============================================================
;; STRING REPETITION
;; ============================================================

;; repeat-string : String Natural -> String
;; Append pattern to itself n times.
;; Structural recursion on n.
(define (repeat-string pattern n)
  (cond [(zero? n) ""]
        [else (string-append pattern
                             (repeat-string pattern (sub1 n)))]))


;; ============================================================
;; is-invalid-id? : Natural -> Boolean
;;
;; An ID is invalid if:
;;   - it consists of some substring repeated k times
;;   - where k >= 2
;;
;; Steps:
;;   1. convert ID to string
;;   2. try all possible pattern lengths 1..floor(len/2)
;;   3. a pattern length p is valid only if p divides string length
;;   4. check whether repeating substring forms the string
;; ============================================================

(define (is-invalid-id? id)
  (define s (number->string id))
  (define L (string-length s))

  ;; check-pattern : Natural -> Boolean
  ;; try pattern lengths starting from p
  (define (check-pattern p)
    (cond
      [(> p (quotient L 2))  #f]  ; no more patterns possible
      [(zero? (modulo L p))       ; pattern size divides length
       (define repeats (/ L p))
       (define pat (substring s 0 p))
       (define rebuilt (repeat-string pat repeats))
       (if (and (>= repeats 2) (string=? rebuilt s))
           #t
           (check-pattern (add1 p)))]

      [else
       (check-pattern (add1 p))])) ; pattern size doesn’t divide → skip
  (check-pattern 1))

;; find-invalid-ids : (listof Natural) -> (listof Natural)
;; Structural recursion.
(define (find-invalid-ids lon)
  (cond [(empty? lon) '()]
        [(is-invalid-id? (car lon))
         (cons (car lon) (find-invalid-ids (cdr lon)))]
        [else
         (find-invalid-ids (cdr lon))]))


;; ============================================================
;; MAIN
;; ============================================================

(define ranges
  (split-ids (parse-input input)))

(define all-ids
  (apply append (map expand-range ranges)))

(print (apply + (find-invalid-ids all-ids)))
