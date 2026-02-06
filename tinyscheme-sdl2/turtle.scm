(load-extension "./ts_sdl2")
(load-extension "./ts_random")



(define *PI* 3.141592653589793)
(define *x* 400)
(define *y* 300)
(define *h* -90)
(define *is-pen-down* #t)




(define (d2r d) (/ (* d *PI*) 180))

(define (pen-down) (set! *is-pen-down* #t))

(define (pen-up)   (set! *is-pen-down* #f))

(define (set-pen-color r g b) (sdl2-set-render-draw-color renderer r g b 255))

(define (move d) 
	(define nx (+ *x* (* d (cos (d2r *h*)))))
	(define ny (+ *y* (* d (sin (d2r *h*)))))
	(if *is-pen-down* (sdl2-render-draw-line renderer *x* *y* nx ny))
	(set! *x* nx)
	(set! *y* ny))

(define (turn a) (set! *h* (+ *h* a)))

(define (jump i j) (set! *x* i) (set! *y* j))



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



