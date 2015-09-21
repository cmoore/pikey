
(in-package #:pikey)

(eval-when (:compile-toplevel :load-toplevel)
  (defpsmacro gebi (element-id)
    `((@ document get-Element-By-Id) ,element-id)))

(defun main ()
  (let* ((args (apply-argv:parse-argv (cdr sb-ext:*posix-argv*)))
         (in-file (getf args :i))
         (out-file (getf args :o))
         (load-file (getf args :l)))
    (when (probe-file load-file)
      (setf *load-verbose* t)
      (setf *load-print* t)
      (load load-file))
    (with-open-file (f out-file :if-exists :supersede :direction :output)
      (write-string (ps:ps-compile-file in-file) f))))
