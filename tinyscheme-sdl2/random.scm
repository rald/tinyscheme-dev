(load-extension "./ts_random")

(random-srand (random-get-time))
(display (modulo (random-rand) 10))
