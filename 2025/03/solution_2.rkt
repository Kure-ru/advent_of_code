#lang racket

(require racket/file
         racket/list
         racket/string)

;; ============================================================
;; DATA DEFINITIONS
;; ============================================================

;; A Bank is a String of digits, e.g., "98765432111111"
;; Batteries is a Natural Number

;; ============================================================
;; HELPER FUNCTIONS
;; ============================================================

;; string->digit-list : String -> (Listof Number)
;; convert a string of digits to a list of numbers
(define (string->digit-list s)
  (map (λ (c) (- (char->integer c) (char->integer #\0)))
                       (string->list s)))

;; (Listof Number) -> Number
;; returns the largest number in a list
(define (max-digit digits)
  (apply max digits))

;; Return the largest digit in a string as a char
(define (max-digit-char s)
  (integer->char (+ (max-digit (string->digit-list s))
                    (char->integer #\0))))

;; ============================================================
;; MAIN
;; ============================================================

;; Bank Batteries -> String
;; Returns the maximum joltage string of length Batteries from Bank
(define (max-joltage bank batteries)
  (cond
    [(= batteries 1) (string (max-digit-char bank))]
    [else
     (define prefix-len (- (string-length bank) (- batteries 1)))
     (define sub (substring bank 0 prefix-len))
     (define first-digit (max-digit-char sub))
     (define i (string-find bank (string first-digit)))
     (string-append
      (string first-digit)
      (max-joltage (substring bank (+ i 1)) (- batteries 1)))]))


;; (Listof Bank) Batteries -> (Listof String)
;; find the max combination in a list of banks for a given amount of batteries
(define (find-max-combinations banks batteries)
  (map (λ (bank) (max-joltage bank batteries)) banks))

;; Batteries -> Number
;; Computes the sum of max joltage strings for all banks
(define (solution batteries)
  (apply + (map string->number (find-max-combinations (string-split (file->string "input.txt") "\n") batteries))))

(displayln (solution 12))

