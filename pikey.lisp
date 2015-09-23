
(in-package #:pikey)

(defun main ()
  (let* ((args (apply-argv:parse-argv (cdr sb-ext:*posix-argv*)))
         (load-from (getf args :l))
         (in-file (getf args :i))
         (out-file (getf args :o))
         (verbose (getf args :v)))

    (when (probe-file load-from)
      (when verbose
        (setf *load-verbose* t)
        (setf *load-print* t))
      (load load-from))
    
    (unless (and in-file out-file)
      (format t "Need two files.~%")
      (sb-ext:quit))
    
    (with-open-file (f out-file :if-exists :supersede :direction :output)
      (write-string (ps:ps-compile-file in-file) f))))
