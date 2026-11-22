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
 | Purpose:          Parse a unix-style pathname into a <{dir,file}-name>
 |------------------------------------------------------------------------|
 | Notes:
 |      completely rewritten 1995.07.18
 `------------------------------------------------------------------------|#

;; Temporary implementation of SRFI-1's filter function.
;; This uses the %foo naming convention for local functions.
(define (%filter pred lst)
  (cond ((null? lst) '())
        ((pred (car lst))
         (cons (car lst) (%filter pred (cdr lst))))
        (else
         (%filter pred (cdr lst)))))

;; TODO: Should this return () instead of ("") for ""?
;; Note: This returns the same result for "foo" and "foo/".
(define (parse-dname dname)
  (cond ((string=? dname "/") '("")) ;; "" == $system-root
	((string=? dname "") '())
	(else
	 (let ((split (%filter (lambda (x) (not (string=? x "")))
			       (string-split dname #\/))))
	   (if (eq? (string-ref dname 0) #\/)
	       (cons "" split)
	       split)))))

(define (parse-fname fname)
  (let* ((elems (string-split fname #\/))
	 (file (last elems)))
    (if (null? (cdr elems))
	(set! elems '())
	(set-cdr! (list-tail elems (fixnum- (length elems) 2)) '()))
    (split-extn elems file)))

(define (split-extn pre file)
  (let loop ((prev #f))
    (let ((n (string-search file #\. (if prev (add1 prev) 0))))
      (if n
	  (loop n)
	  (if prev
	      (values pre
		      (substring file 0 prev)
		      (substring file (add1 prev)))
	      (values pre file #f))))))
;;
; simplify takes the dirpath output from parse-fname and:
    ; removes "."
    ; removes ""
    ; removes "something/.."
    ; and replaces ".." with up
    ; and other leading forms with appropriate <root-dir>'s
    ; and makes sure it starts with either #f or a <root-dir>
; the output from parse-fname is a list

(define (simplify steps)
  (if (null? steps)
      (values #f '())
      (let ((base (special-root (car steps))))
	(let loop ((i (if base (cdr steps) steps))
		   (r '()))
	  (if (null? i)
	      (values base (reverse r))
	      (let (((s <string>) (car i)))
		(cond
		 ((string=? s "..")
		  (if (and (pair? r) (string? (car r)))
		      (loop (cdr i) (cdr r))
		      (loop (cdr i) (cons 'up r))))
		 ((string=? s ".")
		  (loop (cdr i) r))
		 ((string=? s "")
		  (loop (cdr i) r))
		 (else
		  (loop (cdr i) (cons s r))))))))))
