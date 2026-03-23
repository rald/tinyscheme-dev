;; file: event-handling.scm - ULTRA SIMPLE VERSION
(define *event-handlers* '())

(define (add-event-handler event-id handler)
  (set! *event-handlers* (cons (cons event-id handler) *event-handlers*)))

(define (handle-event event)
  (cond ((not event) #t)
        ((not (pair? event)) #t)
        ((null? *event-handlers*) #t)
        (else
         (let ((event-id (car event))
               (handlers *event-handlers*))
           (let loop ((handlers handlers))
             (cond ((null? handlers) #t)
                   ((eqv? event-id (caar handlers))
                    (apply (cdar handlers) event))
                   (else (loop (cdr handlers)))))))))
