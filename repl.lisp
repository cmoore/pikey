
(ql:quickload 'swank)
(swank:create-server :port 4006 :dont-close t)

(ql:quickload 'pikey)
(in-package :pikey)

(start-ws-server)
(start-server)

