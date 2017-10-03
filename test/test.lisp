
(in-package :pikey)

(defvar pikey (create thingy (-> document (ready (lambda ()
                                                   (+ 1 1))))))
