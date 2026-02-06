#!/usr/bin/env scheme



(load "turtle.scm")



(define (star s) 
	(turn 18)
	(do ((i 0 (+ i 1)))
	    ((>= i 5))
	  (move s)
	  (turn 144)))

(define (poly sides size) 
	(do ((i 0 (+ i 1)))
	    ((>= i sides))
	  (move size)
	  (turn (/ 360 sides))))

(define (circle r)
	(let* 	((circ (* 2 *PI* r))
			(steps 360)
			(step-distance (/ circ steps)))

		(do	((i 0 (+ i 1)))
			((>= i steps))
				(move step-distance)
				(turn 1))))



(define window (sdl2-create-window "Stars" 800 600))
(define renderer (sdl2-create-renderer window -1 0))
(sdl2-set-render-draw-color renderer 0 0 0 255)
(sdl2-render-clear renderer)



(srand (time))
(let loop ((l 0))
	(if (< l 10)
		(begin
			(let 
				((i (modulo (rand) 800))
				(j (modulo (rand) 600))
				(k (modulo (rand) 360))
				(r (modulo (rand) 256))
				(g (modulo (rand) 256))
				(b (modulo (rand) 256))
				(s (+ (modulo (rand) 100) 10)))
					(jump i j)
					(face k)
					(set-pen-color r g b)
					(star s))
	(loop (+ l 1)))))



(sdl2-render-present renderer)
(sdl2-delay 5000)
(sdl2-destroy-renderer renderer)
(sdl2-destroy-window window)


