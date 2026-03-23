;; file: turtle.scm - WORKING VERSION
(load-extension "../ts_sdl2")
(load-extension "../ts_random")
(load "../event-handling.scm")

(sdl2-init)
(define *running* #t)
(define *x* 320.0)
(define *y* 240.0)
(define *h* 0.0)
(define *isPenDown* #t)
(define *PI* 3.1416)

(define window (sdl2-create-window))
(define renderer (sdl2-create-renderer window))

(add-event-handler sdl2-key-down
    (lambda (event-id scancode)
        (if (= scancode sdl2-scancode-escape) (set! running #f))
        #f))

(add-event-handler sdl2-quit
    (lambda (event-id) (set! running #f) #f))

(define (d2r d) (* d (/ *PI* 180.0)))

(define (turtle-move d)
    (let* ((nx (+ *x* (* d (cos (d2r *h*)))))
           (ny (+ *y* (* d (sin (d2r *h*))))))
        (if *isPenDown* (sdl2-render-draw-line renderer *x* *y* nx ny))
        (set! *x* nx)
        (set! *y* ny)))

(define (turtle-turn a) (set! *h* (+ *h* a)))

(define (turtle-clean)
    (sdl2-set-render-draw-color renderer 0 0 0 255)
    (sdl2-render-clear renderer)
    (sdl2-render-present renderer))

(define (turtle-set-color r g b a)
    (sdl2-set-render-draw-color renderer r g b a))


(turtle-clean)
(turtle-set-color 255 255 255 255)

(do ((i 0 (+ i 1))) ((>= i 5))
    (turtle-move 100) (turtle-turn 144))

(sdl2-render-present renderer)

(do () ((not *running*))
    (let ((event (sdl2-poll-event)))
        (if (not (eq? event #f))
            (handle-event event))))

(sdl2-destroy-renderer renderer)
(sdl2-destroy-window window)
