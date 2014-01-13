	;; temp = paddle top
	;; bt = ball top
	;; bb = ball bottom
	;; dx = direction x
speed:	mov	work, bt
	addi	work, BAL_HEI/2
	sub	work, temp
	cpi	work, PAD_LOC_1
	brlt	slower
	cpi	work, PAD_LOC_2
	brlt	samespeed
	cpi	work, PAD_LOC_3
	brlt	faster
	cpi	work, PAD_LOC_4
	brlt	samespeed

slower:	bst	dx, 7		; save sign into T
	sbrc	dx, 7		; make absolute value
	neg	dx
	cpi	dx, 2
	brlo	_slow1		; minimum limit is 1
	lsr	dx		; slow down
_slow1:	brtc	_slow2		; if T(sign)==1,
	neg	dx		;	negate dx
_slow2:	ret

faster:	bst	dx, 7		; save sign into T
	sbrc	dx, 7		; make absolute value
	neg	dx
	cpi	dx, 8
	brsh	_fast1		; maximum limit is 8
	lsl	dx		; speed up
_fast1:	brtc	_fast2		; if T(sign)==1,
	neg	dx		;	negate dx
_fast2:	ret

samespeed:
	ret
