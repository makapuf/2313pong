	;; paddle reading

	.def	work	=r23

	in	work, PadAai	; read-out ch0
	cpi	work, PADT_MIN	; min/max binding on pad-top 
	brsh	_bdpa1
	ldi	work, PADT_MIN
	rjmp	_bdpa2
_bdpa1:	cpi	work, PADT_MAX
	brlo	_bdpa2
	ldi	work, PADT_MAX
	
_bdpa2:	stdz	PadAt, work	; store result as paddle A top

	in	work, PadBai	; read-out ch1
	cpi	work, PADT_MIN	; min/max binding on pad-top 
	brsh	_bdpb1
	ldi	work, PADT_MIN
	rjmp	_bdpb2
_bdpb1:	cpi	work, PADT_MAX
	brlo	_bdpb2
	ldi	work, PADT_MAX
	
_bdpb2:	stdz	PadBt, work	; store result as paddle B top
