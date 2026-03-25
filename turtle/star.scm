#!/usr/bin/env scheme

(load "./turtle.scm")

(define *screen-width* 640)
(define *screen-height* 480)



(sdl2-init)

(define *window* (sdl2-create-window *screen-width* *screen-height*))
(define *renderer* (sdl2-create-renderer *window*))
(define *texture0* (sdl2-create-texture *renderer* *screen-width* *screen-height*))
(define *texture1* (sdl2-create-texture *renderer* *screen-width* *screen-height*))
(sdl2-set-texture-blend-mode *texture0* sdl2-blend-mode-blend)
(sdl2-set-texture-blend-mode *texture1* sdl2-blend-mode-blend)

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

(draw-star 100)
(turtle-hide)

(do () ((not *turtle-running*))
    (let ((event (sdl2-poll-event)))
        (if (not (eq? event #f))
            (handle-event event)))
    (sdl2-delay (/ 1000 *turtle-speed*))
)

(sdl2-destroy-renderer *renderer*)
(sdl2-destroy-window *window*)

