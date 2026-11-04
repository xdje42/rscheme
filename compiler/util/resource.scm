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
 | Owned by module:  (rsc)
 |
 `------------------------------------------------------------------------|#

;; a source resource is a resource found in the SOURCE's resource search path
;; (that is, either in $SOURCE/resource or in $SOURCE/install/resource)
;;
;; (note that that means we can access resources that will eventually
;;  be installed)

(define (locate-src-resource rsrc-path)
  (locate-resource *source-resource-path* rsrc-path))

(define (locate-dist-resource rsrc-path)
  (locate-resource *dist-resource-path* rsrc-path))

(define (locate-resource search-path rsrc-path)
  (let ((f (string->file rsrc-path)))
    (format #t "looking for ~s along ~s\n" rsrc-path search-path)
    (let loop ((i search-path))
      (if (null? i)
	  #f
	  (let ((p (append-path (car i) f)))
	    ;(format #t "checking: ~s\n" p)
	    (if (file-exists? (pathname->string p))
		p
		(loop (cdr i))))))))

;; return the pathname to a resource that is to be placed
;; in the distribution, and is intended to be installed

(define (install-resource-path rsrc-path)
  (append-path *install-resource-dir* (string->file rsrc-path)))

;; return the pathname to a resource that is to be put
;; in the distribution, but is NOT intended to be installed
;; This is currently unused. It is kept for future concerns.

(define (distribution-resource-path rsrc-path)
  (append-path *dist-resource-dir* (string->file rsrc-path)))

;; Translate $install and $dist in str.
;; `in-dir' is prepended if str is a relative path.

(define (string->dist-dir in-dir str)
  (let* ((d (string->dir str))
	 (steps (gvec-ref d 1))
	 (h (if (null? steps)
		#f
		(car steps))))
    (if (string? h)
	(cond
	 ((string=? h "$install")
	  (begin
	    (gvec-set! d 1 (cdr (gvec-ref d 1)))
	    (append-dirs *install-dir* d)))
	 ((string=? h "$dist")
	  (begin
	    (gvec-set! d 1 (cdr (gvec-ref d 1)))
	    (append-dirs *dist-build-dir* d)))
	 (else
	  (append-dirs in-dir d)))
	(append-dirs in-dir d))))

;;
;;  mkdirs or mkdir -p functionality
;;

(define (ensure-directory (dir <directory-name>))
  (if (file-exists? (pathname->string dir))
      dir
      (begin
	(ensure-directory (append-dirs dir (string->dir "..")))
	(mkdir (pathname->string dir)))))

;; these are like the "...-file" variants, but take a <file-name>
;; and create the directory if necessary

(define (with-output-to-path path thunk)
  (ensure-directory (file-directory path))
  (with-output-to-file (pathname->string path) thunk))

(define (call-with-output-path path proc)
  (ensure-directory (file-directory path))
  (call-with-output-file (pathname->string path) proc))
