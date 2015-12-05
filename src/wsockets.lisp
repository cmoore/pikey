
(in-package :pikey)


(defparameter *ws-listener* nil)

(defclass chat-room (hunchensocket:websocket-resource)
  ((name :initarg :name
         :initform (error "room with no name")
         :reader name))
  (:default-initargs :client-class 'user))

(defclass user (hunchensocket:websocket-client)
  ((name :initarg :user-agent
         :reader name
         :initform (error "user without name"))))


(defvar *end-points* (list (make-instance 'chat-room :name "/pikey")))

(defun find-room (request)
  (find (hunchentoot:script-name request) *end-points* :test #'string= :key #'name))

(pushnew 'find-room hunchensocket:*websocket-dispatch-table*)

(defmethod hunchensocket:client-connected ((room chat-room) user)
  (hunchensocket:send-text-message user "BON-JOHR-NOE"))

(defun start-ws-server ()
  (unless *ws-listener*
    (setq *ws-listener* (make-instance 'hunchensocket:websocket-acceptor :port 61616))
    (hunchentoot:start *ws-listener*)))
