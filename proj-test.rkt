#lang racket
(require racket/gui/base)
(require racket/draw)

(define mouse-d-pos (list 0 0))

;events
(define tstE (λ(obj e)(begin (send canv-bitmap-dc clear)
                             (set! obj-list (list '(0 0 0 0)))
                             (send m-wnd-canv refresh-now))))


(define tst (λ(obj e) 'a))
(define p-callback (λ (canvas dc) (send dc draw-bitmap canv-bitmap 0 0)))

(define obj-list (list '(0 0 0 0)))
(define (del-obj obj olist) (filter (λ(x)(not(equal? x obj))) olist))
(define draw-object (λ(x y x2 y2)(send canv-bitmap-dc draw-line
                                        x
                                        y
                                        x2
                                        y2)))
(define (draw-object-all o-list)
  (map (λ(x)(apply draw-object x)) o-list))

;Canvas extension for event handling
(define s-canvas%
  (class canvas% 
    (define/override (on-event event)
      (begin
        (send canv-bitmap-dc clear)
        (draw-object-all obj-list)
        (cond
          ((send event button-down?)
           (set! mouse-d-pos (list (send event get-x)
                                         (send event get-y))))
          ((send event button-up?)
           (set! obj-list (append obj-list
                                 (list (append mouse-d-pos
                                               (list (send event get-x)
                                                     (send event get-y)))))))
          ((send event dragging?)
           ;(begin
             (send canv-bitmap-dc draw-line
                   (car mouse-d-pos)
                   (cadr mouse-d-pos)
                   (send event get-x)
                   (send event get-y))
             ;)
           ))
        (send m-wnd-canv refresh-now)))
    (define/override (on-char event)
      'a)
    (super-new)))

;;;;;;;;;; GUI
;; Main window
(define m-wnd (new frame%
                   [label "Example"]
                   [x 0]
                   [y 0]
                   [width 800]
                   [height 600]))
;;(define tools-wnd (new frame%
;;                       [label "ToolBox"]
;;                       [parent m-wnd]
;;                       [x 0]
;;                       [y 0]
;;                       [width 40]
;;                       [height 600]
;;                       [style (list 'no-system-menu)]))

;(define frame-canv (new canvas% [parent frame]
;                        [paint-callback p-callback]))
(define m-wnd-pane (new horizontal-pane% [parent m-wnd]))
(define m-wnd-tools-pane (new vertical-pane%
                              [parent m-wnd-pane]
                              [min-width 100]	 
                              [min-height 600]	 
                              [stretchable-width #f]	 
                              [stretchable-height #f]))

(define m-wnd-canv (new s-canvas%
                        [parent m-wnd-pane]
                        [paint-callback p-callback]))

                        ;[paint-callback p-callback]))

(define m-wnd-canv-dc (send m-wnd-canv get-dc))

;; Button
(define tstBtn (new button% [parent m-wnd]
                    [label "Click Me"]
                    ; Callback procedure for a button click:
                    [callback tstE]))



(define canv-bitmap (make-object bitmap% 1 1))
(define canv-bitmap-dc (new bitmap-dc% [bitmap canv-bitmap]))


;; Show window
(send m-wnd show #t)

;Set bitmap width-height to canvas size
(set! canv-bitmap (make-object bitmap%
                    (send m-wnd-canv get-width)
                    (send m-wnd-canv get-height)))
(send canv-bitmap-dc set-bitmap canv-bitmap)

;;define demo color and set pen for canvas-dc
(define black (make-object color% 10 10 10))
(send canv-bitmap-dc set-pen black 5 'solid)

;;mouse event
;(send m-wnd-canv on-event (new mouse-event% 