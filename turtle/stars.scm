#!/usr/bin/env scheme

(load "./turtle.scm")

(define *screen-width* 640)
(define *screen-height* 480)



(sdl2-init)

(define *window* (sdl2-create-window *screen-width* *screen-height*))
(define *renderer* (sdl2-create-renderer *window*))

(add-event-handler sdl2-key-down
    (lambda (event-id scancode)
        (if (= scancode sdl2-scancode-escape) (set! *running* #f))
        #f))

(add-event-handler sdl2-quit
    (lambda (event-id) (set! *running* #f) #f))



(util-srand (util-time))
(turtle-set-pen-color 0 0 0 sdl2-alpha-opaque)
(turtle-clean)

(do ((i 0 (+ i 1))) ((= i 100))
    (turtle-jump
        (modulo (util-rand) *screen-width*)
        (modulo (util-rand) *screen-height*)
    )

    (turtle-set-head (modulo (util-rand) 360))

    (turtle-set-pen-color
        (modulo (util-rand) 256)
        (modulo (util-rand) 256)
        (modulo (util-rand) 256)
        sdl2-alpha-opaque
    )

    (turtle-star (+ 50 (modulo (util-rand) 50)))
)



(sdl2-render-present *renderer*)

(do () ((not *running*))
    (let ((event (sdl2-poll-event)))
        (if (not (eq? event #f))
            (handle-event event))))

(sdl2-destroy-renderer *renderer*)
(sdl2-destroy-window *window*)
