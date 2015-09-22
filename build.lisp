
(ql:quickload 'pikey)

(require :asdf)

(defmethod asdf:output-files ((o asdf:program-op) (s (eql (asdf:find-system :pikey))))
  (let ((exe-path (uiop/os:getcwd)))
    (if exe-path
        (values (list (concatenate 'string (directory-namestring exe-path) "pikey")) t)
        (call-next-method))))

(asdf:operate :program-op :pikey)
