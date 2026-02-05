(define (read-line . port-arg)
  (let ((port (if (pair? port-arg) (car port-arg) (current-input-port))))
    (let loop ((chars '()))
      (let ((ch (read-char port)))
        (cond
          ((eof-object? ch) (list->string (reverse chars)))
          ((char=? ch #\newline) (list->string (reverse chars)))
          (else (loop (cons ch chars))))))))



(define (filter predicate lst)
  (cond ((null? lst) '())
        ((predicate (car lst)) (cons (car lst) (filter predicate (cdr lst))))
        (else (filter predicate (cdr lst)))))



(define (quicksort lst)
  (if (null? lst)
      '()
      (let* ((pivot (car lst))
             (rest (cdr lst))
             (low (filter (lambda (x) (< x pivot)) rest))
             (high (filter (lambda (x) (>= x pivot)) rest)))
        (append (quicksort low) (list pivot) (quicksort high)))))



(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))



(define lat?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l)) (lat? (cdr l)))
      (else #f))))



(define rember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a) (cdr lat))
      (else (cons (car lat)
                  (rember a (cdr lat)))))))



(define firsts
  (lambda (l)
    (cond
      ((null? l) '())
      (else (cons (car (car l)) (firsts (cdr l)))))))



(define seconds
  (lambda (l)
    (cond
      ((null? l) '())
      (else (cons (car (cdr (car l))) (seconds (cdr l)))))))



(define insertR
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old) (cons old (cons new (cdr lat))))
      (else (cons (car lat) (insertR new old (cdr lat)))))))



(define insertL
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old) (cons new lat))
      (else (cons (car lat)
                  (insertL new old (cdr lat)))))))



(define subst
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old) (cons new (cdr lat)))
      ((atom? (car lat)) (cons (car lat) (subst new old (cdr lat))))
      (else (cons (car lat) (subst new old (cdr lat)))))))



