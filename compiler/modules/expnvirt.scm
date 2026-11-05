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


;; install a hook in the rs-0.6 paths module
;; FIXME: Where is other-special-root defined?

(set! other-special-root
      (lambda (str)
	(if (string=? str "[dist]")
	    $dist-root
	    #f)))

;; FIXME: There is both *dist-src-dir* and *dist-build-dir*.
(define $dist-root (make <root-dir> 
			 root-name: "[dist]/"
			 expanded-name: (pathname->string *dist-src-dir*)))
