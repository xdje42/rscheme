#|------------------------------------------------------------*-Scheme-*--|
 | File:    %p%
 |
 |          Copyright (C)1997 Donovan Kolbly <d.kolbly@rscheme.org>
 |          as part of the RScheme project, licensed for free use.
 |          See <http://www.rscheme.org/> for the latest information.
 |
 | File version:     %I%
 | File mod date:    %E% %U%
 | System build:     %b%
 | Owned by module:  paths
 |
 | Purpose:          parsing to make <file-name>'s and utilities
 `------------------------------------------------------------------------|#

;;

;============================= pathname.scm =============================

(define (file-within-dir p)
    (if (extension p)
	(string-append (filename p) "." (extension p))
	(filename p)))

(define-method pathname->string ((p <file-name>))
    (string-append 
	(if (file-directory p)
	    (pathname->string (file-directory p))
	    "")
	(filename p)
	(if (extension p)
	    (string-append "." (extension p))
	    "")))

(define-method pathname->string ((self <string>))
  self)

(define-method pathname->os-path ((self <string>))
  self)

;; Convert a file path to a string, expanding special directories.
(define-method pathname->os-path ((self <file-name>))
  (let ((x (extension self))
	(d (file-directory self)))
    (string-append 
	(if d (dir->string d "/" expanded-name) "")
	(filename self)
	(if x "." "")
	(if x x ""))))

(define (append-path dir path)
    (make <file-name> 
	 filename: (filename path)
	 extension: (extension path)
	 file-directory: (if (file-directory path)
			     (append-dirs dir (file-directory path))
			     dir)))

(define (extension-related-path path extn)
  (make <file-name> 
	filename: (filename path)
	extension: extn
	file-directory: (file-directory path)))

(define (string->file str)
  (bind ((steps file extn (parse-fname str)))
    (make <file-name> 
	  filename: file
	  extension: extn
	  file-directory: (if (null? steps)
			      #f
			      (steps->dir steps)))))
