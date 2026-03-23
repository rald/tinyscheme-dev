(load-extension "../ts_sdl2")
(load-extension "../ts_random")
(load "../event-handling.scm")

(sdl2-init)

(define running #t)

(define x 320.0)
(define y 240.0)
(define h 0.0)
(define isPenDown #t)
(define PI 3.1416)

(define window (sdl2-create-window))
(define renderer (sdl2-create-renderer window))

(define (d2r d) (* d (/ PI 180.0)))

(define (turtle-move d)
    (let*
        (
            (nx (+ x (* d (cos (d2r h)))))
            (ny (+ y (* d (sin (d2r h)))))
        )

        (if isPenDown (sdl2-render-draw-line renderer x y nx ny))

        (set! x nx)
        (set! y ny)
    )
)

(define (turtle-turn a) (set! h (+ h a)))

(define (pen-down) (set! isPenDown #t))
(define (pen-up) (set! isPenDown #f))

(define (clear-screen)
    (sdl2-set-render-draw-color renderer 0 0 0 sdl2-alpha-opaque)
    (sdl2-render-clear renderer)
    (sdl2-render-present renderer))

(add-event-handler sdl2-quit
    (lambda (event)
        (set! running #f)
        #f))


(srand (time))
(clear-screen)
(sdl2-set-render-draw-color renderer (modulo (rand) 255)  (modulo (rand) 255)  (modulo (rand) 255) sdl2-alpha-opaque)

(do ((i 0 (+ i 1))) ((>= i 5))
    (turtle-move 100)
    (turtle-turn 144)
)


(sdl2-render-present renderer)



(do ()
    ((not running))
    (let ((event (sdl2-poll-event)))
        (if (not (eq? event #f))
            (handle-event event))))

(sdl2-destroy-renderer renderer)
(sdl2-destroy-window window)

