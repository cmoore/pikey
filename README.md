
![](dags.jpg)

Pikey is a Javascript compiler using Parenscript.

It's work in progress.  To build it, you need SBCL and quicklisp.  Then check the source out in `~/quicklisp/local-projects`, and finally do `sbcl --load build.lisp` in the pikey directory.  Then you can copy the pikey executable wherever you like.

## Usage

`pikey -l macros.lisp -i <infile> -o <outfile>`

`-l <file>` - Load *Common Lisp* forms from this file before parsing the source.

Note that there is a distinction between Common Lisp forms and Parenscript forms in this context.  It's probably a good idea to follow the link in the next section and get familiar with Parenscript, or go take a look at the wiki to get a sense of the difference.

`-i <file>` - Load *Parenscript* forms from this file.

`-o <file>` - Output the processed javascript into this file.

### Syntax

https://common-lisp.net/project/parenscript/reference.html#reserved-symbols

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

For better or worse, Pikey is a complete Common Lisp image.  You could, potentially, use everything, including load Quicklisp with it and use reader macros in your `macros.lisp` file.

### Included Systems

[uiop](http://quickdocs.org/uiop), [cl-fad](http://quickdocs.org/cl-fad/), [cl-ppcre](http://quickdocs.org/cl-ppcre), and [cl-who](http://quickdocs.org/cl-who)
