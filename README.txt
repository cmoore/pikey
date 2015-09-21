
Pikey is a Javascript compiler using Parenscript.

It's work in progress.  To build it, you need SBCL and quicklisp.  Then evaluate

(asdf:operate :program-op :pikey)

and look in your fasl cache for the executable.  I haven't looked up how to put
it in the current working directory yet.

Your fasl cache is usually ~/.cache/common-lisp/<sbcl|ccl|whatver>/path/to/source/etc.

