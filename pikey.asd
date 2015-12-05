
(asdf:defsystem #:pikey
  :description "Describe pikey here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t

  
  :depends-on (#:cl-fad
               #:parenscript

               #:drakma
               #:jsown

               #:hunchensocket
               #:hunchentoot

               #:apply-argv
               #:cl-who)
  
  :components ((:module "src" :components ((:file "package")
                                           (:file "pikey")
                                           (:file "jsmacros")
                                           (:file "server" :depends-on ("jsmacros"))
                                           (:file "wsockets" :depends-on ("jsmacros"))
                                           (:file "repl" :depends-on ("server" "wsockets")))))
  
  :build-pathname "pikey"
  :entry-point "pikey:main")
