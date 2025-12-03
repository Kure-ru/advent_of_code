#lang racket

(require racket/file
         racket/list
         racket/string)

(define input (file->string "input.txt"))

; list of Banks -> List of Joltages
(define (find-max-combinations lob)
  (cond [(empty? lob) '()]
        [else (cons (find-max-combination (car lob))
                    (find-max-combinations (cdr lob)))]))

(define (find-max-combination bank)
  (define pairs (map list->string (combinations (string->list bank) 12)))
  (foldl (λ (a b) (if (string>? a b) a b)) "" pairs))


(define (solution input)
  (apply + (map string->number (find-max-combinations (string-split input "\n")))))

(displayln (solution input))
