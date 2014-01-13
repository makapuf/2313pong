	;; beep envelope
	.def	ctr	=r24
	lddz	ctr, Bepdu	; if (Bepdu == 0)
	tst	ctr
	brne	_bpcont
	clr	tone		;	stop beep
_bpcont:dec	ctr		; else
	stdz	Bepdu, ctr	;	--Bepdu;
