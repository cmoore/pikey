;;;; pikey.asd

(asdf:defsystem #:pikey
  :description "Describe pikey here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t

  
  :depends-on (#:cl-fad
               #:apply-argv
               #:parenscript
               #:cl-who)
  
  :components ((:file "package")
               (:file "pikey"))
  
  :build-pathname "pikey"
  :entry-point "pikey:main")

