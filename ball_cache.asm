	;; ball pattern caching
	.def	work	=r23
	.def	loc	=r22
	.def	pat	=r24

	lddz	work, Balll
	mov	loc, work
	lsr	loc		; loc >>= 3;
	lsr	loc
	lsr	loc
	ser	pat		; pat = 0b11111111;
	andi	work, 0x07
_blch1:	breq	_blch2		; while(work) {
	lsr	pat		;	pat >>= 1;
	dec	work		;	--work;
	rjmp	_blch1		; }
_blch2:	stdz	Ballad, loc
	stdz	Ballpt, pat
