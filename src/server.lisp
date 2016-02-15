
(in-package :pikey)

(defparameter *listener* nil)

(defun start-server (&key (port 8080) (address "127.0.0.1") (path "."))
  (unless *listener*
    (setq *listener*
          (make-instance 'hunchentoot:easy-acceptor
                         :document-root (truename path)
                         :address address
                         :port port))
    (hunchentoot:start *listener*)))

(defun stop-server ()
  (when *listener*
    (hunchentoot:stop *listener*)))

(defmacro with-page (&rest body)
  `(cl-who:with-html-output-to-string
       (*standard-output* nil :prologue t :indent t)
     ,@body))

(define-easy-handler (loader :uri "/load") ()
  (with-page
      (htm (:body
             (:head
               (:script :src "https://code.jquery.com/jquery-2.1.4.min.js")
               (:script :src "/load.js"))
             (:body
               (:span "Honk!"))))))

(defmacro with-script (&rest body)
  `(progn
     (setf (hunchentoot:content-type*) "text/javascript")
     (setf *ps-html-mode* :sgml)
     (ps* ,@body)))

(define-easy-handler (load-script :uri "/load.js") ()
  (with-script
      `(progn
         (with-document-ready
             (lambda ()
               ((@ console log) "W-hat up"))))))

(define-easy-handler (ws-interop :uri "/wsinterop.js") ()
  (with-script
      `(progn
         (defun ws-connect ))))

;;
;; An almost line by line copy of https://www.websocket.org/echo.html
;;

(define-easy-handler (ws-test :uri "/testing") ()
  (with-page
      (:html
        (:head
          (:meta :charset "utf-8")
          (:title "testing testy")
          (:script :src "/goog/base.js")
          (:script :type "text/javascript"
            (str (ps
                   (defvar ws-uri "ws://localhost:61616/pikey")
                   (defvar output nil)

                   (defun write-to-screen (b)
                     (defvar p ((@ document create-element) "p"))
                     (setf (@ p style wordwrap) "break-word")
                     (setf (@ p inner-h-t-m-l) b)
                     ((@ output append-child) p))
                        
                   (defun init ()
                     (setf output ((@ document get-element-by-id) "output"))
                     (test-web-socket))

                   (defun test-web-socket ()
                     (defvar websocket (new (-web-socket ws-uri)))
                     (setf (@ websocket onopen) (lambda (e)
                                                  (on-open e)))
                     (setf (@ websocket onclose) (lambda (e)
                                                   (on-close e)))
                     (setf (@ websocket onmessage) (lambda (e)
                                                     (on-message e)))
                     (setf (@ websocket onerror) (lambda (e)
                                                   (on-error e))))

                   (defun on-open (e)
                     ((@ console log) "CONNECT"))

                   (defun on-close (e)
                     ((@ console log) "DISCONNECT"))

                   (defun on-message (e)
                     ((@ console log) e)
                     (write-to-screen (+ "I GOT A MESSAGE: " (@ e data))))

                   (defun on-error (e)
                     (write-to-screen "I GOT AN ERROR"))

                   (defun do-send (e)
                     ((write-to-screen) (+ "SENT: " e))
                     ((@ websocket send) e))

                   (defun top-init ()
                     (init)
                     ((@ console log) "Start.")
                     (write-to-screen "Staring up..."))))))
        (:body :onload "topInit();"
          (:span "Well, it's a start.")
          (:div :id "output")))))

;;(ql:quickload 'websocket-driver-client)

(defun send-message (message)
  (let ((client (wsd:make-client "ws://localhost:61616/pikey")))
    (as:with-event-loop ()
      (wsd:start-connection client)
      (wsd:send client message))))
