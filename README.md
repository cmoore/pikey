
![](dags.jpg)

Pikey is a Javascript compiler using Parenscript.

It's work in progress.  To build it, you need SBCL and quicklisp.
Then, just `sbcl --load build.lisp`


## Usage

`pikey -i <infile> -o <outfile>`

### Macros

This is really the whole reason for using Pikey.

Pikey will load macros from `macros.lisp` in the current working directory.

So, for instance, if `macros.lisp` contains

``` lisp
(in-package :pikey) ;; This is required in your macros and source.

(defmacro+ps dr (&rest body)
  `((@ ($ document) ready) (lambda ()
                             ,@body)))
```

and your source file contains

``` lisp
(in-package :pikey)

(dr (defvar x 1))
```

`pikey -i source.lisp -o test.js` will produce

``` javascript
$(document).ready(function () {
    var x = 1;
});
```

### Powah

For better or worse, Pikey is a complete Common Lisp image.  You could, potentially, use everything, including load Quicklisp with it.

