#!/usr/bin/env scheme

(load-extension "./ts_sdl2")
(load-extension "./ts_random")



(define PI 3.1415926)
(define x 400)
(define y 300)
(define h -90)
(define is-pen-down #t)




(define (d2r d) (/ (* d PI) 180))

(define (pen-down) (set! is-pen-down #t))

(define (pen-up)   (set! is-pen-down #f))

(define (set-pen-color r g b) (sdl2-set-render-draw-color renderer r g b 255))

(define (move d) 
	(define nx (+ x (* d (cos (d2r h)))))
	(define ny (+ y (* d (sin (d2r h)))))
	(if is-pen-down (sdl2-render-draw-line renderer x y nx ny))
	(set! x nx)
	(set! y ny))

(define (turn a)
	(set! h (+ h a)))

(define (jump i j) 
	(set! x i)
	(set! y j))



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



(define window (sdl2-create-window "Turtle" 800 600))
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
					(turn k)
					(set-pen-color r g b)
					(star s))
	(loop (+ l 1)))))


 
(sdl2-render-present renderer)
(sdl2-delay 5000)
(sdl2-destroy-renderer renderer)
(sdl2-destroy-window window)


