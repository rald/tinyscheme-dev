(load-extension "../ts_sdl2")
(load-extension "../ts_util")
(load "../event-handling.scm")



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

(define (turtle-turn a) (set! *heading* (+ *heading* a)))

(define (turtle-pen-down) (set! isPenDown #t))

(define (turtle-pen-up) (set! isPenDown #f))

(define (turtle-jump x y)
    (set! *x* x)
    (set! *y* y))

(define (turtle-face angle) (set! *heading* angle))

(define (turtle-clean)
    (sdl2-render-clear *renderer*)
    (sdl2-render-present *renderer*))

(define (turtle-set-color r g b a)
    (sdl2-set-render-draw-color *renderer* r g b a))

(define (turtle-star size)
    (do ((i 0 (+ i 1))) ((>= i 5))
        (turtle-move size)
        (turtle-turn 144)))



(sdl2-init)

(define *window* (sdl2-create-window))
(define *renderer* (sdl2-create-renderer *window*))

(add-event-handler sdl2-key-down
    (lambda (event-id scancode)
        (if (= scancode sdl2-scancode-escape) (set! *running* #f))
        #f))

(add-event-handler sdl2-quit
    (lambda (event-id) (set! *running* #f) #f))



(ts-util-srand (ts-util-time))
(turtle-set-color 0 0 0 255)
(turtle-clean)

(do ((i 0 (+ i 1))) ((>= i 10))

    (turtle-jump
        (modulo (ts-util-rand) 640)
        (modulo (ts-util-rand) 480)
    )

    (turtle-face (modulo (ts-util-rand) 360))

    (turtle-set-color
        (modulo (ts-util-rand) 255)
        (modulo (ts-util-rand) 255)
        (modulo (ts-util-rand) 255)
        255)

    (turtle-star (+ 50 (modulo (ts-util-rand) 50)))
)

(sdl2-render-present *renderer*)



(do () ((not *running*))
    (let ((event (sdl2-poll-event)))
        (if (not (eq? event #f))
            (handle-event event))))



(sdl2-destroy-renderer *renderer*)
(sdl2-destroy-window *window*)



