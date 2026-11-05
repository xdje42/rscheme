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
 |
 `------------------------------------------------------------------------|#

;;
;; load and process bytecodes
;;
;; Note: This file is unused during normal builds.
;;

(load "process.scm")
(process-defs-file)
(create-primop-module 'primops)

;;
;; install them
;;

(load "loadbyt.scm")
(%save-self "-- bytecodes installed")
