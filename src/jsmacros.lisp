
(in-package :pikey)


(setf parenscript:*ps-print-pretty* t)
(setf parenscript:*indent-num-spaces* 2)

(defpsmacro setup-jquery ()
  `(progn
     (setf (@ window $) (require "./core/jquery.js"))
     (setf (@ window j-query) (require "./core/jquery.js"))))

(defpsmacro with-document-ready (&rest body)
  `(progn
     ((@ ($ document) ready) (lambda ()
                               ,@body))))

(defpsmacro .s (name)
  `(@ $ ,name))

(defpsmacro sel (name)
  `($ ,name))

(defpsmacro $. (name)
  `(@ (sel ,name)))

(defpsmacro .> (&rest body)
  `(chain ,@body))

(defpsmacro -> (name function &rest args)
  `((@ ,name ,function) ,@args))

;;
;;  body must be in the form of (lambda (args) ...)
;;

(defpsmacro selector-ready (selector &rest body)
  `((@ (@ ($ ,selector)) ready) ,@body))

(defpsmacro bind-event (name event &rest body)
  `((@ (@ (sel ,name)) bind) ,event ,@body))

;;
;; (on thing "event" (lambda (x)
;;                     (+ x 2)))
;;
;; thing.on('event', function (x) {
;;     return x + 2;
;; })
;;

(defpsmacro on-event (what event &rest body)
  `((@ ,what on) ,event ,@body))

(defpsmacro p-ajax (&key url (data nil) (on-success nil) (on-error nil))
  `(-> $ ajax (create url ,url
                      method "POST"
                      data-type "json"
                      ,@(when data  `(data ,data))
                      ,@(when on-success  `(success ,on-success))
                      ,@(when on-error `(error ,on-error)))))

(defpsmacro if-property (element prop pos neg)
  `(if ((@ ,element has-own-property) ,prop)
       ,pos
       ,neg))

(defpsmacro and-property (element prop action)
  `(when ((@ ,element has-own-property) ,prop)
     ,action))

(defpsmacro or-property (element prop action)
  `(unless ((@ ,element has-own-property) ,prop)
     ,action))







(defpsmacro map (func list)
  `(do ((i 0 (incf i)))
       ((>= i (@ ,list length)))
     (funcall ,func (aref ,list i))))
