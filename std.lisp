(in-package :pikey)

(defmacro+ps -> (&rest body)
  `(chain ,@body))

(defmacro+ps _ (function &rest body)
  `(-> _ (,function ,@body)))

(defmacro+ps add-entity ()
  (with-ps-gensyms (ball)
    `(progn
       (defvar ,ball (chain game add (sprite 0 0 "balloon")))

       (chain game physics (enable ,ball (chain -phaser -physics -a-r-c-a-d-e)))
       (setf (@ ,ball check-world-bounds) t)
       (chain ,ball body bounce (set 1))

       (setf (chain ,ball input-enabled) t)
       (chain ,ball events on-input-down (add click-handler ,ball))
         
       (setf (chain ,ball body velocity y) (random-range -20 -50))

       (chain all-balloons (push ,ball))
       (drop-balloon ,ball))))

(defmacro+ps random-range (min max)
  `(+ ,min (-> -math (floor (* (-> -math (random)) (+ 1 (- ,max ,min)))))))
