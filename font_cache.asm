	;; font caching
fcache:	.def	score	=r24
	.def	work	=r23
	.def	temp	=r22

	lddz	score, ScoA
	mov	temp, score
	lsl	temp		; temp = score * 5
	lsl	temp
	add	temp, score
	ldiw	z, fontab<<1
	add	zl, temp	; z += score * 5
	brcc	_fcac1
	inc	zh
_fcac1:	ldiw	x, Ftbuf
	ldi	work, 5		; 5 rows
_fcac2:	lpm	temp, z		; do {
	adiw	z, 1
	st	x+, temp	;	*x++ = *z++;
	dec	work
	brne	_fcac2		; } while (--work);

	lds	score, ScoB	; (z=Glob is broken)
	mov	temp, score
	lsl	temp		; temp = score * 5
	lsl	temp
	add	temp, score
	ldiw	z, fontab<<1
	add	zl, temp	; z += score * 5
	brcc	_fcac3
	inc	zh
_fcac3:	ldiw	x, Ftbuf+5
	ldi	work, 5		; 5 rows
_fcac4:	lpm	temp, z		; do {
	adiw	z, 1
	st	x+, temp	;	*x++ = *z++;
	dec	work
	brne	_fcac4		; } while (--work);
