(load-extension "../tinyscheme-sdl2/ts_sdl2")
(load-extension "../tinyscheme-sdl2/ts_util")

(load "../tinyscheme-sdl2/event-handling.scm")



(define *x* 320.0)
(define *y* 240.0)
(define *heading* 0.0)
(define *isPenDown* #t)
(define *PI* 3.14159265358979323846)
(define *running* #t)



(define (deg2rad degrees) (* degrees (/ *PI* 180.0)))

(define (turtle-move distance)
    (let* ((nx (+ *x* (* distance (cos (deg2rad *heading*)))))
           (ny (+ *y* (* distance (sin (deg2rad *heading*))))))
        (if *isPenDown* (sdl2-render-draw-line *renderer* *x* *y* nx ny))
        (set! *x* nx)
        (set! *y* ny)))

(define (turtle-turn angle) (set! *heading* (+ *heading* angle)))

(define (turtle-pen-down) (set! *isPenDown* #t))

(define (turtle-pen-up) (set! *isPenDown* #f))

(define (turtle-pen-color r g b a)
    (sdl2-set-render-draw-color *renderer* r g b a))

(define (turtle-jump x y)
    (set! *x* x)
    (set! *y* y))

(define (turtle-home)
    (set! *x* 320)
    (set! *y* 240))

(define (turtle-face angle) (set! *heading* angle))

(define (turtle-clean)
    (sdl2-render-clear *renderer*)
    (sdl2-render-present *renderer*))

(define (turtle-star size)
    (do ((i 0 (+ i 1))) ((>= i 5))
        (turtle-move size)
        (turtle-turn 144)))



