main:	
	;; main loop entry
	rjmp	main_entry
hstart:
	.def	nxline	=r27
	mov	nxline, line	; 41+1=42
	inc	nxline		; +1=43 check next line
	cpi	nxline, LN_VISBL+1; +1=44 if next is 0-235,
	brlo	draw		; +2=46 start draw raster
	rjmp	vsyncf		; otherwise in vblank period

	;; **** screen drawing routine ****
draw:
	.include "draw.asm"	; +79=125

main_entry:
	sleep			; +1=126 idle waiting for OCF1B
				; --------------------------------
				; 12+27=39 intr latency + handler
	rjmp	hstart		; +2=41

	;; **** v-sync and game progress routine ***
	.def	temp	=r26
vsyncf:				; do {
	cpi	line, START_VSYNC
	brne	vsyncf		; } while(line != 236);
	ldi	temp, 0b11000010; flip PWM pol for VSYNC
	out	TCCR1A, temp
vsync:				; do {
	sleep			;	(power save)
	cpi	line, END_VSYNC
	brne	vsync		; } while(line != 239);
	ldi	temp, 0b10000010; flip PWM pol for end of VSYNC
	out	TCCR1A, temp

	ldiw	z, Glob		; set global var base addr
	.include "game.asm"

weovb:				; do {
	sleep			;	(power save)
	cpi	line, LN_FRAME-1
	brne	weovb		; } while(line != 255);

	sleep			; idle waiting for OCF1B
	rjmp	hstart

	
;;; 
