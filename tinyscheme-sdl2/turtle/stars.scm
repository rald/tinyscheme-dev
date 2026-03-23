#!/usr/bin/env scheme

(load "./turtle.scm")



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
