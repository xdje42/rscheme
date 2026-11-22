#|------------------------------------------------------------*-Scheme-*--|
 | File:    %p%
 |
 |          Copyright (C)2026 Doug Evans <xdje42@gmail.com>
 |          as part of the RScheme project, licensed for free use.
 |          See <http://www.rscheme.org/> for the latest information.
 |
 | File version:     %I%
 | File mod date:    %E% %U%
 | System build:     %b%
 | Owned by module:  corelib
 |
 | Purpose:          Low level debugging utilities
 `------------------------------------------------------------------------|#

;;;  
;;;  These functions are useful when debugging Rscheme itself,
;;;  eg, early in the load process.
;;;

(define-safe-glue (debug-print-str (comment <raw-string>))
{
  fputs( comment, stdout );
  RETURN0();
})

(define-safe-glue (debug-print-obj object)
{
  fprinto( stdout, object );
  RETURN0();
})
