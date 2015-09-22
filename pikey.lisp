
(in-package #:pikey)

(defun main ()
  (let* ((args (apply-argv:parse-argv (cdr sb-ext:*posix-argv*)))
         (in-file (getf args :i))
         (out-file (getf args :o))
         (standard (truename
                    (asdf:system-relative-pathname :pikey "std.lisp"))))
    
    (unless (and in-file out-file)
      (format t "Need two files.~%")
      (sb-ext:quit))

    (when (probe-file "macros.lisp")
      (setf *load-verbose* t)
      (setf *load-print* t)
      (load "macros.lisp"))
    
    (when (probe-file standard)
      (setf *load-verbose* t)
      (setf *load-print* t)
      (load standard))
    (ignore-errors
     (with-open-file (f out-file :if-exists :supersede :direction :output)
       (write-string (ps:ps-compile-file in-file) f)))))
