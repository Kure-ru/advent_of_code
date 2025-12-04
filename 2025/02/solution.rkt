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

;; parse-ranges : String -> (listof (list String String))
;; Takes "A-B,C-D,E-F" → '(("A" "B") ("C" "D") ("E" "F"))
(define (parse-ranges str)
  (map (λ (s) (string-split s "-"))
       (string-split str ",")))

;; expand-range : (list String String) -> (listof Natural)
;; Convert '( "5" "10" ) → '(5 6 7 8 9 10)
(define (expand-range pr)
  (define start (string->number (string-trim (first pr))))
  (define end   (string->number (string-trim (second pr))))
  (range start (add1 end)))

;; is-invalid-id? : Natural -> Boolean
;; Uses regex to detect strings of the form XX (substring repeated twice)
;;
;; Regex: ^(.+)\\1$
;;  - "(.+)" captures some substring X
;;  - "\\1" requires the exact same substring again
;;  - ^ and $ enforce that the whole string is exactly X X
(define repeated-twice-regex         #px"^(.+)\\1$")
(define repeated-at-least-twice-regex #px"^(.+)\\1+$")

(define (is-invalid-id? id)
  (regexp-match? repeated-at-least-twice-regex (number->string id)))

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

(define ranges (parse-ranges input))

(define all-ids
  (apply append (map expand-range ranges)))

(define invalid-ids
  (find-invalid-ids all-ids))

(displayln (apply + invalid-ids))
