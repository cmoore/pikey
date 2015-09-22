
(in-package #:pikey)

(defmacro uwotm8 (file)
  `(when (probe-file ,file)
     (setf *load-verbose* t)
     (setf *load-print* t)
     (load ,file)))

(defun main ()
  (let* ((args (apply-argv:parse-argv (cdr sb-ext:*posix-argv*)))
         (in-file (getf args :i))
         (out-file (getf args :o))
         (standard (truename
                    (asdf:system-relative-pathname :pikey "std.lisp"))))
    
    (unless (and in-file out-file)
      (format t "Need two files.~%")
      (sb-ext:quit))

    (uwotm8 "macros.lisp")
    (uwotm8 standard)
    
    (ignore-errors
     (with-open-file (f out-file :if-exists :supersede :direction :output)
       (write-string (ps:ps-compile-file in-file) f)))))
