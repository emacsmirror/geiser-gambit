;;;gambit.scm gambit geiser interaction

(define-macro (geiser:capture-output x . xs)
  (let ((out (gensym))
        (result (gensym)))
    `(let* ((,out (open-output-string))
            (,result (parameterize ((current-output-port ,out))
                       ,(cons 'begin (cons x xs)))))
       (write `((result ,(object->string ,result))
                (out  ,(get-output-string ,out))))
       (newline))))

(define (geiser:load-file filename)
  (geiser:capture-output (load filename)))

(define (geiser:eval2 module form) ;; module is not yet supported in gambit
  (geiser:capture-output (eval form)))

(define-macro (geiser:eval module form . rest)
  `(geiser:eval2 ,module ,(quote form)))

(define (geiser:newline)
  (newline))

(define (geiser:no-values)
  (values))

;; Spawn a server for remote repl access TODO make it works with remote repl

;;(define (geiser-start-server . rest)
;;  (let* ((listener (tcp-listen 0))
;;         (port (tcp-listener-port listener)))
;;    (define (remote-repl)
;;        (receive (in out) (tcp-accept listener)
;;          (current-input-port in)
;;          (current-output-port out)
;;          (current-error-port out)
;;          
;;          (repl)))
;;    
;;    (thread-start! (make-thread remote-repl))
;;    
;;    (write-to-log `(geiser-start-server . ,rest))
;;    (write-to-log `(port ,port))
;; 
;;    (write `(port ,port))
;;    (newline)))
