
;; Copyright (c) 2017 Clint Moore

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.


(defpackage #:pikey
  (:use #:cl
        #:parenscript)
  (:export :main))

(in-package #:pikey)

(defun main ()
  (let* ((args (apply-argv:parse-argv #+sbcl
                                      (cdr sb-ext:*posix-argv*)
                                      #+clozure
                                      (cdr (ccl::command-line-arguments))))
         (load-from (getf args :l))
         (in-file (getf args :i))
         (out-file (getf args :o))
         (verbose (getf args :v)))
    
    (when (ignore-errors (probe-file load-from))
      (when verbose
        (setf *load-verbose* t)
        (setf *load-print* t))
      (load load-from))
    
    (unless (and in-file out-file)
      (princ
       (format nil "Usage: pikey -l <optional macros file> -i <parenscript> -o <javascript>~%"))
      #+sbcl
      (sb-ext:exit)
      #+ccl
      (ccl:quit))

    (with-open-file (f out-file :if-exists :supersede :direction :output)
      (write-string (ps:ps-compile-file in-file) f))))
