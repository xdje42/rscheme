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

,(use repl)

(define *top-level* #f)

(define (eval-string str)
  (eval (with-input-from-string str read) *top-level*))

(define (main args)
  (set! *top-level* (make-user-initial))
  ;; just return the eval-string procedure
  eval-string)

(restart-with "sys.img" main)