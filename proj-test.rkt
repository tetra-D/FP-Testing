#lang racket
(require racket/gui/base)
;events
(define tstE (λ(obj e)(send tstBtn set-label "Click")))

;;;;;;;;;; GUI
;; Main window
(define frame (new frame% [label "Example"]))

;; Label
(define msgLbl (new message% [parent frame]
                    [label "No events so far..."]))
;; Button
(define tstBtn (new button% [parent frame]
                    [label "Click Me"]
                    ; Callback procedure for a button click:
                    [callback tstE]))

;; Show window
(send frame show #t)
