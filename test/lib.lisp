
(in-package :pikey)

(defmacro+ps -> (&rest body)
  `(chain ,@body))

