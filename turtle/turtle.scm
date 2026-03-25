(load-extension "../tinyscheme-sdl2/ts_sdl2")
(load-extension "../tinyscheme-sdl2/ts_util")

(load "../tinyscheme-sdl2/event-handling.scm")



(define *turtle-x* 320.0)
(define *turtle-y* 240.0)
(define *turtle-heading* 0.0)
(define *turtle-is-pen-down* #t)
(define *turtle-is-visible* #t)
(define *turtle-speed* 1000)
(define *turtle-pen-color-r* 255)
(define *turtle-pen-color-g* 255)
(define *turtle-pen-color-b* 255)
(define *turtle-pen-color-a* 255)
(define *PI* 3.14159265358979323846)

(define *turtle-dd* 0)
(define *turtle-dh* 0)
(define *turtle-epsilon* 0.0001)

(define *turtle-state-idle*    0)
(define *turtle-state-moving*  1)
(define *turtle-state-turning* 2)
(define *turtle-state* *turtle-state-idle*)

(define *turtle-running* 1000)



(define turtle-vector (vector
    '( 0  0)
    '(-1  1)
    '( 2  0)
    '(-1 -1)
    '( 0  0)
))



(define (deg2rad degrees) (* degrees (/ *PI* 180.0)))

(define (sgn x) (if (< x 0) -1 (if (> x 0) 1 0)))

(define (fmod a m) (- a (* m (floor (/ a m)))))

(define (normalize-angle angle)
    (let ((a (fmod angle 360.0)))
        (if (< a 0.0)
            (+ a 360.0)
            a)))

(define (rotate-point-pivot point pivot angle)
  (let ((px (car pivot))
        (py (cadr pivot))
        (x (car point))
        (y (cadr point)))
    (list (+ px (- (* (- x px) (cos angle)) (* (- y py) (sin angle))))
          (+ py (+ (* (- x px) (sin angle)) (* (- y py) (cos angle)))))))

(define (turtle-move distance)
    (set! *turtle-dd* distance)
    (set! *turtle-state* *turtle-state-moving*)
    (turtle-update)
)

(define (turtle-turn angle)
    (set! *turtle-dh* angle)
    (set! *turtle-state* *turtle-state-turning*)
    (turtle-update)
)

(define (turtle-show)
    (set! *turtle-is-visible* #t)
    (turtle-update)
)

(define (turtle-hide)
    (set! *turtle-is-visible* #f)
    (turtle-update)
)

(define (turtle-clean) (sdl2-render-clear *renderer*))

(define (turtle-pen-down) (set! *turtle-is-pen-down* #t))

(define (turtle-pen-up) (set! *turtle-is-pen-down* #f))

(define (turtle-set-pen-color r g b a)
    (set! *turtle-pen-color-r* r)
    (set! *turtle-pen-color-g* g)
    (set! *turtle-pen-color-b* b)
    (set! *turtle-pen-color-a* a)
)

(define (turtle-set-x x) (set! *turtle-x* x))

(define (turtle-set-y y) (set! *turtle-y* y))

(define (turtle-jump x y)
    (set! *turtle-x* x)
    (set! *turtle-y* y))

(define (turtle-set-heading angle) (set! *turtle-heading* angle))



(define (turtle-draw v a)
    (do ((i 0 (+ i 1))) ((= i (- (vector-length v) 1)))
        (let* ( (p0 (vector-ref v i))
                (p1 (vector-ref v (+ i 1)))
                (pr0 (rotate-point-pivot p0 '(0 0) (deg2rad a)))
                (pr1 (rotate-point-pivot p1 '(0 0) (deg2rad a)))
                (x0 (+ (* (car  pr0) 8) *turtle-x*))
                (y0 (+ (* (cadr pr0) 8) *turtle-y*))
                (x1 (+ (* (car  pr1) 8) *turtle-x*))
                (y1 (+ (* (cadr pr1) 8) *turtle-y*)))
            (sdl2-render-draw-line *renderer* x0 y0 x1 y1)))
    (let* ( (p0 (vector-ref v (- (vector-length v) 1)))
            (p1 (vector-ref v 0))
            (pr0 (rotate-point-pivot p0 '(0 0) (deg2rad a)))
            (pr1 (rotate-point-pivot p1 '(0 0) (deg2rad a)))
            (x0 (+ (* (car  pr0) 8) *turtle-x*))
            (y0 (+ (* (cadr pr0) 8) *turtle-y*))
            (x1 (+ (* (car  pr1) 8) *turtle-x*))
            (y1 (+ (* (cadr pr1) 8) *turtle-y*)))
        (sdl2-render-draw-line *renderer* x0 y0 x1 y1)))



(define (turtle-update)

    (sdl2-set-render-target *renderer* *texture0*)
    (sdl2-set-render-draw-color *renderer* 0 0 0 255)
    (sdl2-render-clear *renderer*)

    (if *turtle-is-visible*
        (begin
            (sdl2-set-render-target *renderer* *texture0*)
            (sdl2-set-render-draw-color *renderer* 0 0 0 255)
            (sdl2-render-clear *renderer*)
            (sdl2-set-render-draw-color *renderer* 255 255 255 255)
            (turtle-draw turtle-vector *turtle-heading*)
            (sdl2-set-render-target *renderer* ())
        )
    )

    (do () ((or (= *turtle-state* *turtle-state-idle*) (not *turtle-running*)))

        (if (= *turtle-state* *turtle-state-moving*)

            (let*   (
                        (d (sgn *turtle-dd*))
                        (nx (+ *turtle-x* (* d (cos (deg2rad *turtle-heading*)))))
                        (ny (+ *turtle-y* (* d (sin (deg2rad *turtle-heading*)))))
                    )

                (sdl2-set-render-target *renderer* *texture1*)
                (if *turtle-is-pen-down*
                    (begin
                        (sdl2-set-render-draw-color *renderer*
                            *turtle-pen-color-r*
                            *turtle-pen-color-g*
                            *turtle-pen-color-b*
                            *turtle-pen-color-a*
                        )
                        (sdl2-render-draw-line *renderer* *turtle-x* *turtle-y* nx ny)
                    )
                )
                (sdl2-set-render-target *renderer* ())

                (set! *turtle-x* nx)
                (set! *turtle-y* ny)
                (set! *turtle-dd* (- *turtle-dd* d))
                (set! *turtle-dd* (if (< *turtle-dd* *turtle-epsilon*) 0 *turtle-dd*))
                (if (= *turtle-dd* 0) (set! *turtle-state* *turtle-state-idle*))
            )
        )

        (if (= *turtle-state* *turtle-state-turning*)
            (let* ((a (sgn *turtle-dh*)))
                (set! *turtle-heading* (normalize-angle (+ *turtle-heading* a)))
                (set! *turtle-dh* (- *turtle-dh* a))
                (set! *turtle-dh* (if (< *turtle-dh* *turtle-epsilon*) 0 *turtle-dh*))
                (if (= *turtle-dh* 0) (set! *turtle-state* *turtle-state-idle*))            )
        )

        (sdl2-set-render-target *renderer* *texture0*)
        (sdl2-set-render-draw-color *renderer* 0 0 0 255)
        (sdl2-render-clear *renderer*)

        (if *turtle-is-visible*
            (begin
                (sdl2-set-render-target *renderer* *texture0*)
                (sdl2-set-render-draw-color *renderer* 0 0 0 255)
                (sdl2-render-clear *renderer*)
                (sdl2-set-render-draw-color *renderer* 255 255 255 255)
                (turtle-draw turtle-vector *turtle-heading*)
                (sdl2-set-render-target *renderer* ())
            )
        )


        (sdl2-set-render-target *renderer* ())
        (sdl2-render-copy *renderer* *texture0* () ())
        (sdl2-render-copy *renderer* *texture1* () ())
        (sdl2-render-present *renderer*)

        (let ((event (sdl2-poll-event)))
            (if (not (eq? event #f))
                (handle-event event)))

        (sdl2-delay (/ 1000 *turtle-speed*))
    )

    (sdl2-set-render-target *renderer* ())
    (sdl2-render-copy *renderer* *texture0* () ())
    (sdl2-render-copy *renderer* *texture1* () ())

    (sdl2-render-present *renderer*)

)
