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

(define (find-lex-addr ct-envt var)
    (let loop ((e ct-envt) (i 0))
	(let ((x (memq var (car e))))
	    (if x
		(cons i (- (length (car e)) (length x)))
		(loop (cdr e) (add1 i))))))

(define (join seperator list)
  (if (null? list)
      ""
      (let ((l (make-seq)))
	(seq-add! l (car list))
	(for-each (lambda (item)
		    (seq-add! l seperator)
		    (seq-add! l item))
		  (cdr list))
	(apply string-append (seq->list l)))))

(define (item->str h)
  (if (symbol? h)
      (symbol->string h)
      (if (string? h)
	  h
	  (object->string h))))

(define (comma-sep lst)
    (if (null? lst)
	""
	(if (null? (cdr lst))
	    (item->str (car lst))
	    (string-append (item->str (car lst))
	    	           ","
			   (comma-sep (cdr lst))))))

;;
;;  mkdirs or mkdir -p functionality
;;

(define (ensure-directory (dir <directory-name>))
  (if (file-exists? (pathname->string dir))
      dir
      (begin
	(ensure-directory (append-dirs dir (string->dir "..")))
	(mkdir (pathname->string dir)))))
