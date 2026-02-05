(load-extension "./ts_sdl2")
(load-extension "./ts_random")



(define PI 3.1415926)
(define x 400)
(define y 300)
(define h -90)
(define pen-is-down #t)




(define (d2r d) (/ (* d PI) 180))

(define (pen-down) (set! pen-is-down #t))

(define (pen-up)   (set! pen-is-down #f))

(define (set-pen-color r g b) (sdl2-set-render-draw-color renderer r g b 255))

(define (move d) 
	(define nx (+ x (* d (cos (d2r h)))))
	(define ny (+ y (* d (sin (d2r h)))))
	(if pen-is-down (sdl2-render-draw-line renderer x y nx ny))
	(set! x nx)
	(set! y ny)
)

(define (turn a)
	(set! h (+ h a))
)

(define (jump i j) 
	(set! x i)
	(set! y j)	
)



(define (star s) 
	(turn 18)
	(do ((i 0 (+ i 1)))
	    ((>= i 5))
	  (move s)
	  (turn 144))
)

(define (poly sides size) 
	(do ((i 0 (+ i 1)))
	    ((>= i sides))
	  (move size)
	  (turn (/ 360 sides)))
)



(define window (sdl2-create-window "Turtle" 800 600))
(define renderer (sdl2-create-renderer window -1 0))
(sdl2-set-render-draw-color renderer 0 0 0 255)
(sdl2-render-clear renderer)



(srand (time))
(set-pen-color 0 255 0)
(let loop ((l 0))
	(if (< l 10)
		(begin
			(define i (modulo (rand) 800))
			(define j (modulo (rand) 600))
			(define k (modulo (rand) 360))
			(jump i j)
			(turn k)
			(star (+ (modulo (rand) 100) 10))		
			(loop (+ l 1)))))


 
(sdl2-render-present renderer)
(sdl2-delay 5000)
(sdl2-destroy-renderer renderer)
(sdl2-destroy-window window)


