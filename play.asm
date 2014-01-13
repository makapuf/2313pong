	.def	bt	=r21	; ball top
	.def	bb	=r16	; ball bottom
	.def	bl	=r17	; ball left
	.def	dx	=r18	; dir x
	.def	dy	=r13	; dir y
	.def	pat	=r14	; paddle A top
	.def	pab	=r19	; paddle A bottom
	.def	pbt	=r15	; paddle B top
	.def	pbb	=r20	; paddle B bottom

	lddz	bt, Ballt
	mov	bb, bt
	addi	bb, BAL_WID-1
	lddz	bl, Balll
	lddz	dx, Dirx
	lddz	dy, Diry
	lddz	pat, PadAt
	mov	pab, pat
	addi	pab, PAD_HEI-1
	lddz	pbt, PadBt
	mov	pbb, pbt
	addi	pbb, PAD_HEI-1
	
	;; advance ball
	add	bt, dy
	add	bb, dy
	add	bl, dx

	;; reflect on sideline
	cpi	bt, COURT_MIN
	breq	_refver
	cpi	bb, COURT_MAX
	brne	_refpad
_refver:neg	dy		; flip direction Y
	ldi	tone, BEP_TONE4
	ldi	temp, 3		; envelope = 3*(1/60sec) = 0.05sec
	stdz	Bepdu, temp
	rjmp	_playend

	;; reflect on paddle
	.include "speed.asm"
_refpad:
	;; paddle A
	cpi	bl, PADA_L+PAD_WID
	brne	_rfpa1
	cp	bb, pat		; if (bb < pat)
	brlo	_rfpa1		;	break;
	cp	pab, bt		; if (bt > pab)
	brlo	_rfpa1		;	break;
	neg	dx		; flip direction X
	mov	temp, pat
	rcall	speed
	rjmp	_beppad

_rfpa1:
	;; paddle B
	cpi	bl, PADB_L-PAD_WID
	brne	_rfpa2
	cp	bb, pbt		; if (bb < pbt)
	brlo	_rfpa2		;	break;
	cp	pbb, bt		; if (bt > pbb)
	brlo	_rfpa2		;	break;
	neg	dx		; flip direction X
	mov	temp, pbt
	rcall	speed
_beppad:
	ldi	tone, BEP_TONE3
	ldi	temp, 6		; envelope = 6*(1/60sec) = 0.1sec
	stdz	Bepdu, temp
_rfpa2:	
_playend:
	stdz	Ballt, bt
	stdz	Balll, bl
	stdz	Dirx, dx
	stdz	Diry, dy
	