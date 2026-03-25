#!/usr/bin/env scheme

(load "./turtle.scm")

(define *game-title* "Turtle: Tree")
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



(define (draw-tree len)
    (if (> len 5)
        (begin
            (turtle-move len)

            (turtle-turn 20)
            (draw-tree (- len 15))

            (turtle-turn -40)
            (draw-tree (- len 15))

            (turtle-turn 20)
            (turtle-move (- len))
        )
    )
)



(util-srand (util-time))

(turtle-set-pen-color 0 0 0 255)
(turtle-clean)

(turtle-turn -90)
(turtle-pen-up)
(turtle-move -100)
(turtle-pen-down)
(turtle-set-pen-color 255 255 255 255)

(draw-tree 75)



(sdl2-render-present *renderer*)

(do () ((not *turtle-running*))
    (let ((event (sdl2-poll-event)))
        (if (not (eq? event #f))
            (handle-event event)))
)

(sdl2-destroy-renderer *renderer*)
(sdl2-destroy-window *window*)

