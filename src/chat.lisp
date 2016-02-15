
(in-package :pikey)

(defpackage :my-chat (:use :cl))

(in-package :my-chat)

(defclass chat-room (hunchensocket:websocket-resource)
  ((name :initarg :name
         :initform (error "Name this room!")
         :reader name))
  (:default-initargs :client-class 'user))

(defclass user (hunchensocket:websocket-client)
  ((name :initarg :user-agent
         :reader name
         :initform (error "Name this user!"))))

(in-package :pikey)

(defvar *chat-rooms* (list (make-instance 'chat-room :name "/bongo")
                           (make-instance 'chat-room :name "/fonk")))

(defun find-room (request)
  (find (hunchentoot:script-name request)
        *chat-rooms*
        :test #'string= :key #'name))

(pushnew 'find-room hunchensocket:*websocket-dispatch-table*)


(defun broadcast (room message &rest args)
  (mapc (lambda (peer)
          (hunchensocket:send-text-message peer (apply #'format nil message args)))
        (hunchensocket:clients room)))

(defmethod hunchensocket:client-connected ((room chat-room) user)
  (broadcast room "~a has joined ~a" (name user) (name room)))

(defmethod hunchensocket:client-disconnected ((room chat-room) user)
  (broadcast room "~a has left ~a" (name user) (name room)))

(defmethod hunchensocket:text-message-received ((room chat-room) user message)
  (broadcast room "~a says ~a" (name user) message))

(defparameter *server* nil)

(defun start ()
  (setf *server* (make-instance 'hunchensocket:websocket-acceptor :port 61616))
  (hunchentoot:start *server*))
