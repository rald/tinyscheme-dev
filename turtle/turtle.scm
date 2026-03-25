(load-extension "../tinyscheme-sdl2/ts_sdl2")
(load-extension "../tinyscheme-sdl2/ts_util")

(load "../tinyscheme-sdl2/event-handling.scm")



(define *turtle-x* 0)
(define *turtle-y* 0)
(define *turtle-heading* 0.0)
(define *turtle-is-pen-down* #t)
(define *turtle-running* #t)
(define *PI* 3.14159265358979323846)



(define (deg2rad degrees) (* degrees (/ *PI* 180.0)))

(define (sgn x) (if (< x 0) -1 (if (> x 0) 1 0)))

(define (fmod a m) (- a (* m (floor (/ a m)))))

(define (normalize-angle angle)
    (let ((a (fmod angle 360.0)))
        (if (< a 0.0)
            (+ a 360.0)
            a)))

(define (turtle-move distance)
    (let* ((nx (+ *turtle-x* (* distance (cos (deg2rad *turtle-heading*)))))
           (ny (+ *turtle-y* (* distance (sin (deg2rad *turtle-heading*))))))

        (if *turtle-is-pen-down*
            (sdl2-render-draw-line *renderer* *turtle-x* *turtle-y* nx ny)
        )

        (set! *turtle-x* nx)
        (set! *turtle-y* ny)
    )
)

(define (turtle-turn angle) (set! *turtle-heading* (normalize-angle (+ *turtle-heading* angle))))

(define (turtle-clean) (sdl2-render-clear *renderer*))

(define (turtle-pen-down) (set! *turtle-is-pen-down* #t))

(define (turtle-pen-up) (set! *turtle-is-pen-down* #f))

(define (turtle-set-pen-color r g b a)
    (sdl2-set-render-draw-color *renderer* r g b a)
)

(define (turtle-set-x x) (set! *turtle-x* x))

(define (turtle-set-y y) (set! *turtle-y* y))

(define (turtle-set-heading angle) (set! *turtle-heading* angle))

(define (turtle-jump x y) (set! *turtle-x* x) (set! *turtle-y* y))

