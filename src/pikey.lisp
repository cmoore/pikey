
(in-package #:pikey)

(defun main ()
  (let* ((args (apply-argv:parse-argv (cdr sb-ext:*posix-argv*)))
         (repl (getf args :r))
         (load-from (getf args :l))
         (in-file (getf args :i))
         (out-file (getf args :o))
         (verbose (getf args :v)))

    (if repl
        (repl-mode)
        (progn
          (when (ignore-errors (probe-file load-from))
            (when verbose
              (setf *load-verbose* t)
              (setf *load-print* t))
            (load load-from))
          
          (unless (and in-file out-file)
            (princ
             (format nil "Usage: pikey -l <optional macros file> -i <parenscript> -o <javascript>~%"))
            (sb-ext:exit))
          
          (with-open-file (f out-file :if-exists :supersede :direction :output)
            (write-string (ps:ps-compile-file in-file) f))))))
