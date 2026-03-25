#!/usr/bin/env scheme

(load "./turtle.scm")

(define *game-title* "Turtle: Stars")
(define *screen-width* 640)
(define *screen-height* 480)



(sdl2-init)

(define *window* (sdl2-create-window *game-title* *screen-width* *screen-height*))
(define *renderer* (sdl2-create-renderer *window*))

(add-event-handler sdl2-key-down
    (lambda (event-id scancode)
        (if (= scancode sdl2-scancode-escape) (set! *turtle-running* #f))
        #f))

(add-event-handler sdl2-quit
    (lambda (event-id) (set! *turtle-running* #f) #f))




(define (draw-star size)
    (do ((i 0 (+ i 1))) ((= i 5))
        (turtle-move size)
        (turtle-turn 144)
    )
)



(util-srand (util-time))

(turtle-set-pen-color 0 0 0 255)
(turtle-clean)

(turtle-jump (quotient *screen-width* 2) (quotient *screen-height* 2))

(do ((i 0 (+ i 1))) ((= i 100))
    (let* ( (r (modulo (util-rand) 256))
            (g (modulo (util-rand) 256))
            (b (modulo (util-rand) 256))
            (a sdl2-alpha-opaque)
            (x (modulo (util-rand) *screen-width*))
            (y (modulo (util-rand) *screen-height*))
            (a (modulo (util-rand) 360))
            (size (+ (modulo (util-rand) 50) 50)))
        (turtle-set-pen-color r g b a)
        (turtle-jump x y)
        (turtle-turn a)
        (draw-star size)
    )
)



(sdl2-render-present *renderer*)

(do () ((not *turtle-running*))
    (let ((event (sdl2-poll-event)))
        (if (not (eq? event #f))
            (handle-event event)))
)

(sdl2-destroy-renderer *renderer*)
(sdl2-destroy-window *window*)


