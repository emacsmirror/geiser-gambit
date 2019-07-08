;;;gambit.scm gambit geiser interaction

(define (geiser-load-file file)
  (let* ((file (if (symbol? file) (symbol->string file) file))
         (found-file (geiser-find-file file)))
    (call-with-result
     (lambda ()
       (when found-file
         (load found-file))))))

(define (geiser:newline)
  (newline))

(define (geiser:no-values)
  (values))

;; Spawn a server for remote repl access TODO make it works with remote repl

(define (geiser-start-server . rest)
  (let* ((listener (tcp-listen 0))
         (port (tcp-listener-port listener)))
    (define (remote-repl)
        (receive (in out) (tcp-accept listener)
          (current-input-port in)
          (current-output-port out)
          (current-error-port out)
          
          (repl)))
    
    (thread-start! (make-thread remote-repl))
    
    (write-to-log `(geiser-start-server . ,rest))
    (write-to-log `(port ,port))

    (write `(port ,port))
    (newline)))
