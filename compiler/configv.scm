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

;;
;; define the properties of this RScheme
;; system represented by this SOURCE tree
;;

#|
   if this is true, then a sandbox-type technique is used,
   whereby the dest. hierarchy is built with leaves as
   soft links into the SOURCE directory
   (doesn't apply to template-copy; only module files)
|#

(define *link-files?* #f)

;;
;; "module" refers to the RScheme compilation units, 
;; which may or may not have any C link-units associated
;; with them (module_descr's) (it may have several, in fact)
;;
;; "subproject" refers a portion of the main compile that results
;; in librs.a.  The subprojects are the C subprojects of the
;; standard modules plus the base runtime subprojects
;;

;; List of base runtime components that have module descriptors.
;; These are recorded as symbols but they actually are part of C symbol names:
;; module_$name.
(define *base-runtime-components*
  '(rscheme bci))

;; must be listed most-requiring to least-requiring
;; (so the last module can depend on at most *scheme* and primops)

(define *modules* '(primops
		    precore
		    corelib
		    low-scheme
		    objsys
		    paths
		    tables
		    mathlib
		    iolib
		    high-scheme
		    regex
		    sort
		    imageio
		    editinp
		    start
		    compiler
		    codegen
		    mlink
		    repl
		    hacks))

;; a list is given when the file name and the C linkage name is different

;; make our path as absolute as we can...

(define *source-dir* (append-dirs (process-directory) (current-directory)))

;; derived values...

;; for writing directly into the distribution
;; (create using `install-resource-path'
;;           and `distribution-resource-path',
;;  respectively for a resource that is to make
;;  it to the installation and one that is part
;;  of the distribution, but not part of the installation)

(define *install-resource-dir*
  (append-dirs *install-dir* (string->dir "resource")))

;; This is currently unused. It is kept for future concerns.
(define *dist-resource-dir*
  (append-dirs *dist-src-dir* (string->dir "resource")))

;; note that each stage of the end-to-end build gets
;; it's own resource directory
;; (search using `locate-src-resource')

(define *source-resource-path*
  (list (append-dirs *source-dir* (string->dir "resource"))
	(append-dirs *source-dir* (string->dir "dist/resource"))
	(append-dirs *source-dir* (string->dir "install/resource"))))

(define *dist-resource-path*
  (list (append-dirs *dist-src-dir* (string->dir "resource"))
	(append-dirs *dist-src-dir* (string->dir "install/resource"))))

(define *install-resource-path*
  (list (append-dirs *install-dir* (string->dir "resource"))))
