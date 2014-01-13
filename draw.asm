	;; **** output raster and draw next raster ****
	;; kicked by timer1 compare match A interrupt

	;; --- local macros ---
	;; push out segment onto raster then clear segment
	.macro	vout8px
	out	PORTB, @0	; +1=1	output bit7
	lsl	@0		; +1=2
	out	PORTB, @0	; +1=3	output bit6
	lsl	@0		; +1=4
	out	PORTB, @0	; +1=5	output bit5
	lsl	@0		; +1=6
	out	PORTB, @0	; +1=7	output bit4
	lsl	@0		; +1=8
	out	PORTB, @0	; +1=9	output bit3
	lsl	@0		; +1=10
	out	PORTB, @0	; +1=11	output bit2
	lsl	@0		; +1=12
	out	PORTB, @0	; +1=13	output bit1
	lsl	@0		; +1=14
	out	PORTB, @0	; +1=15	output bit0
	clr	@0		; +1=16 clear this segment for next timing
	.endmacro

	.macro	filrast
	ser	r23		; +1=1 fill raster23
	mov	rast22, r23	; +1=2 fill raster22
	mov	rast21, r23
	mov	rast20, r23
	mov	rast19, r23
	mov	rast18, r23
	mov	rast17, r23
	mov	rast16, r23
	mov	rast15, r23
	mov	rast14, r23
	mov	rast13, r23
	mov	rast12, r23
	mov	rast11, r23
	mov	rast10, r23
	mov	rast9, r23
	mov	rast8, r23
	mov	rast7, r23
	mov	rast6, r23
	mov	rast5, r23
	mov	rast4, r23
	mov	rast3, r23
	mov	rast2, r23
	mov	rast1, r23
	mov	rast0, r23	; +1=24 fill raster0
	.endmacro

	;; --- draw raster ---
draw_entry:
	vout8px	r0		; 16*24=384cycles(visible period)
	vout8px	r1
	vout8px	r2
	vout8px	r3
	vout8px	r4
	vout8px	r5
	vout8px	r6
	vout8px	r7
	vout8px	r8
	vout8px	r9
	vout8px	r10
	vout8px	r11
	vout8px	r12
	vout8px	r13
	vout8px	r14
	vout8px	r15
	vout8px	r16
	vout8px	r17
	vout8px	r18
	vout8px	r19
	vout8px	r20
	vout8px	r21
	vout8px	r22
	vout8px	r23
	out	PORTB, r23	; 0+1=1 set to blank level

	;; --- prepare next raster ---
	cpi	nxline, COURT_MIN; +1=2
	brlo	sideline	; +1=3
	cpi	nxline, COURT_MAX; +1=4
	brlo	field		; +2=6

	;; --- draw sidelines ---
sideline:			; draw sideline
	filrast			; (+24)
	rjmp	eol

field:				; draw inside of field
	;; --- draw center line ---
	bst	nxline, 4	; +1=7 T=nxline:4
	bld	rast12, 7	; +1=8 rast12:7=T

	;; --- draw ball ---
	.def	pos	=r24
drawball:
	lds	pos, Ballt	; +2=10
	cp	nxline, pos	; +1=11 skip if (line < Ball_top)
	brlo	drawpad		; +1=12
	addi	pos, BAL_HEI	; +1=13
	cp	pos, nxline	; +1=14 skip if (line > Ball_bot)
	brlo	drawpad		; +1=15 / +2=16

	.def	pattern	=r26
	clr	zh		; +1=16
	lds	zl, Ballad	; +2=18
	lds	pattern, Ballpt	; +2=20
	st	z, pattern	; +2=22
	com	pattern		; +1=23
	std	z+1, pattern	; +2=25 (r24 can be written)

	;; --- draw paddles ---
drawpad:
	lds	pos, PadAt	; +2=27
	cp	nxline, pos	; +1=28 skip if (line < PadA_top)
	brlo	drawpadb	; +1=29
	addi	pos, PAD_HEI	; +1=30
	cp	pos, nxline	; +1=31 skip if (line > PadA_bot)
	brlo	drawpadb	; +1=32
	com	rast1		; +1=33 draw paddle A
drawpadb:
	lds	pos, PadBt	; +2=35
	cp	nxline, pos	; +1=36 skip if (line < PadB_top)
	brlo	drawscore	; +1=37
	addi	pos, PAD_HEI	; +1=38
	cp	pos, nxline	; +1=39 skip if (line > PadB_bot)
	brlo	drawscore	; +1=40
	com	rast22		; +1=41 draw paddle B

	;; --- draw scores ---
drawscore:
	mov	zl, nxline	; +1=42 prepare for font load
	subi	nxline, DGT_TOP	; +1=43
	cpi	nxline, DGT_BOT+1-DGT_TOP; +1=44
	brsh	eol		; +1=45

	lsr	zl		; +1=46
	lsr	zl		; +1=47
	addi	zl, low(Ftbuf)-DGT_TOP/4; +1=48
	clr	zh		; +1=49

	.def	fontd	=r24
	.def	pat10	=r27
	.def	pat01	=r26
	ldi	pat10, 0b11110000; +1=50
	ldi	pat01, 0b00001111; +1=51
	;; for Score A
	ld	fontd, z	; +2=53 load a font row of A
	sbrc	fontd, 7	; +1=54
	or	rast7, pat10	; +1=55
	sbrc	fontd, 6	; +1=56
	or	rast7, pat01	; +1=57
	sbrc	fontd, 5	; +1=58
	or	rast8, pat10	; +1=59
	sbrc	fontd, 3	; +1=60
	or	rast9, pat10	; +1=61
	sbrc	fontd, 2	; +1=62
	or	rast9, pat01	; +1=63
	sbrc	fontd, 1	; +1=64
	or	rast10, pat10	; +1=65
	;; for Score B
	ldd	fontd, z+5	; +2=67 load a font row of B
	sbrc	fontd, 7	; +1=68
	or	rast13, pat01	; +1=69
	sbrc	fontd, 6	; +1=70
	or	rast14, pat10	; +1=71
	sbrc	fontd, 5	; +1=72
	or	rast14, pat01	; +1=73
	sbrc	fontd, 3	; +1=74
	or	rast15, pat01	; +1=75
	sbrc	fontd, 2	; +1=76
	or	rast16, pat10	; +1=77
	sbrc	fontd, 1	; +1=78
	or	rast16, pat01	; +1=79

	;; --- end of line ---
eol:
