#lang racket

(require racket/file
     racket/list
     racket/string
     math/base)

;; -------------------------
;; READ & PARSE INPUT FILE
;; -------------------------

(define input-str (file->string "input.txt"))

; string -> LoStrings
; take the input string and parse it by ','
(define (parse-input str) (string-split str ","))

; LoStrings -> LoStrings
; take each string from a LoStrings and split each of them by "-"
(define (split-ids los)
    (cond [(empty? los) '()]
          [#t (cons (string-split (car los) "-") (split-ids (cdr los)))]))

; List Of Number -> List Of Number
; return list of invalid ids
(define (find-invalid-ids lon)
    (cond [(empty? lon) '()]
          [(is-invalid-id? (car lon))
            (cons (car lon) (find-invalid-ids (cdr lon)))]
          [#t  (find-invalid-ids (cdr lon))]))

; number -> boolean
; return true is id is not valid
; an invalid id is sequence of digit repeated twice
(define (is-invalid-id? id)
    (let* (
        [string-id (number->string id)]
        [l (string-length string-id)])
       (if (odd? l)
            #f
            (let* ([half (/ l 2)]
                   [first-half  (substring string-id 0    half)]
                   [second-half (substring string-id half l)])
            (string=? first-half second-half)))))

(define (expand-range pr)
 (let ([start (string->number (string-trim (first  pr)))]
       [end   (string->number (string-trim (second pr)))])
       (range start (add1 end))))

(define all-ids
    (apply append (map expand-range (split-ids (parse-input input-str)))))

(displayln (sum (find-invalid-ids all-ids)))
