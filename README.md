[![Join the chat at https://gitter.im/cmoore/pikey](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cmoore/pikey?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

![](dags.jpg)

Pikey is a Javascript compiler using Parenscript.

It's work in progress.  To build it, you need SBCL and quicklisp.  Then check the source out in `~/quicklisp/local-projects`, and finally do `sbcl --load build.lisp` in the pikey directory.  Then you can copy the pikey executable wherever you like.

## Usage

`pikey -v -l <cl source> -i <parenscript> -o <javascript>`

`-v` - Turn on verbose mode.  Sets `*load-verbose*` and `*load-print*` to `t` before loading the Common Lisp source.

`-l <file>` - (optional) Load *Common Lisp* forms from this file before parsing the source.

> Note that there is a distinction between Common Lisp forms and Parenscript forms in this context.  It's probably a good idea to follow the link in the next section and get familiar with Parenscript, or go take a look at the wiki to get a sense of the difference.

`-i <file>` - Load *Parenscript* forms from this file.

`-o <file>` - Output the processed javascript into this file.

### Syntax

https://common-lisp.net/project/parenscript/reference.html#reserved-symbols

### Macros

This is really the whole reason for using Pikey.

You can add forms to Pikey's namespace (`:pikey`) with the `-l` file.

So, for instance, if `macros.lisp` contains

``` lisp
(in-package :pikey) ;; This is required in your macros and source.

(defmacro+ps sel (name)
  `($ ,name))

(defmacro+ps $. (name)
  `(@ (sel ,name)))

(defmacro+ps -> (name function &rest args)
  `((@ ,name ,function) ,@args))
  
(defmacro+ps on (what event &rest body)
  `((@ ,what on) ,event ,@body))

```

and your source file contains

``` lisp
(in-package :pikey)

(on ($. "#login") "clicked" (lambda (event)
                              (-> console log (+ "Event: " event))))

```

`pikey -l macros.lisp -i source.lisp -o test.js` will produce

``` javascript

$('#login').on('clicked', function (event) {
  return console.log('Event: ' + event);
});

```
### Debugging

You might want to debug the syntax of your macros, especially if you're starting out.  Here's a quick way to make sure you have at least the syntax of your macros correct.

``` common-lisp
;; You'll need sbcl and quicklisp installed for this.
;; Make sure that your file loads pikey and sets it as the current package.

(ql:quickload 'pikey)
(in-package :pikey)

```

Then you can test the syntax from the command line with:

`sbcl --non-interactive --load yourfile.lisp`

### Powah

For better or worse, Pikey is a complete Common Lisp image.  You could, potentially, use everything, including load Quicklisp with it and use reader macros in your `macros.lisp` file.

### Included Systems

[uiop](http://quickdocs.org/uiop), [cl-fad](http://quickdocs.org/cl-fad/), [cl-ppcre](http://quickdocs.org/cl-ppcre), and [cl-who](http://quickdocs.org/cl-who)

