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

;; $MAX-SIZE is the limit on how much stuff the compiler
;; will put into a single (output) C file.
;; the units are that of the ESTIMATE-SIZE function, which
;; currently is basically the number of virtual assembly
;; nodes

(define $max-size 5000)

;; FIXME: What does this refer to? No longer used?
;; $USE-MAKEFILE specifies the makefile that is to be
;; included to get the bulk of the definitions for
;; a module's Makefile

;; This setting is suitable for a SYSTEM BUILD
;; but it should be $INSTALL/resource/compiler/postamble.mak
;; (or something like that) for normal code
;; N.B. This can't refer to any configure-time dependent values, this goes
;; into the subproject Makefile that gets checked in with stage0.
;; We can use top_builddir however because it is fixed as "../..".

(define $module-makefile "$(top_builddir)/postambl.mak")
