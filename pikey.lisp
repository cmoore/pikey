
(in-package #:pikey)

(defmacro uwotm8 (file)
  `(when (probe-file ,file)
     (when verbose
       (setf *load-verbose* t)
       (setf *load-print* t))
     (load ,file)))

(defun main ()
  (let* ((args (apply-argv:parse-argv (cdr sb-ext:*posix-argv*)))
         (load-from (getf args :l))
         (in-file (getf args :i))
         (out-file (getf args :o))
         (verbose (getf args :v))
         (standard (truename
                    (asdf:system-relative-pathname :pikey "std.lisp"))))

    (when (probe-file load-from)
      (uwotm8 load-from))
    
    (unless (and in-file out-file)
      (format t "Need two files.~%")
      (sb-ext:quit))

    (ignore-errors
     (with-open-file (f out-file :if-exists :supersede :direction :output)
       (write-string (ps:ps-compile-file in-file) f)))))
