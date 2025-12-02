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
    (map (lambda (s) (string-split s "-")) los))

(define (split-string s chunk-size)
    (let ([l (string-length s)])
        (if (zero? (remainder l chunk-size))
            (for/list ([i (in-range 0 l chunk-size)])
                (substring s i (+ i chunk-size)))
                '())))

; a pattern cannot be longer than half the ID length 
; only consider pattern if 
; string length is divisible by its length
; if pattern repeat n < 2, skip (we want at least 2 repetitions)
(define (is-valid? n)
  (let* ([number (~a n)]
         [max-chunk-size (/ (string-length number) 2)])
         (for/and ([i (in-inclusive-range 1 max-chunk-size)])
          (let ([chunks (split-string number i)])
            (or (empty? chunks)
                (not (apply string=? chunks)))))))

(define (expand-range pr)
 (let ([start (string->number (string-trim (first  pr)))]
       [end   (string->number (string-trim (second pr)))])
       (range start (add1 end))))


(define all-ids
    (apply append (map expand-range (split-ids (parse-input input-str)))))

(define invalid-ids
    (filter (lambda (n) (not (is-valid? n))) all-ids))

(define solution (apply + invalid-ids))
(printf "Solution part 2: ~a~n" solution)
