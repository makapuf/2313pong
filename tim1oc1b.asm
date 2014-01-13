	;; **** timer1 overflow interrupt handler ****
	;; This routine takes just 39 cycle anyway.
tim1oc1b:			; 12= latency + push*2 + rjmp here
	;; --- line count ---
	inc	line		; +1=13

	;; --- beep and LED ---
	mov	itemp, line	; +1=14
	and	itemp, tone	; +1=15
	in	itemp, PORTD	; +1=16
	brne	notogl		; +1=17	/ +2=18
	sbrc	tone, 0		; +1=18 if (tone:0 != 0)
	addi	itemp, 1<<PO_BEEP; +1=19	toggle beep
	addi	itemp, 1<<PO_LED; +1=20 toggle LED
	andi	itemp, ~(1<<(PO_BEEP+1)|1<<(PO_LED+1))	; +1=21 clear bits above BEEP/LED
intend:	
	;; --- easy adc ---
	cpi	line, PAD_PRECHG; +1=22
	brlo	prechg		; +1/+2=+23/+24

	andi	itemp, ~((1<<PO_PACHG) | (1<<PO_PBCHG)); +1=24 discharge caps
	out	PORTD, itemp	; +1=25

	sbis	PIND, PI_PADA	; +1/+2=26/27
	rjmp	capta		; +2=28
	in	itemp, PadAct	; +1=28 count up counter if PI_PADA=H
	inc	itemp		; +1=29
	out	PadAct, itemp	; +1=30

	sbis	PIND, PI_PADB	; +1/+2=31/32
	rjmp	captb		; +2=33
	in	itemp, PadBct	; +1=33 count up counter if PI_PADB=H
	inc	itemp		; +1=34
	out	PadBct, itemp	; +1=35
	reti			; +4=39

capta:	in	itemp, PadAct	; +1=29 update PadAai only if PI_PADA=L
	out	PadAai, itemp	; +1=30

	sbis	PIND, PI_PADB	; +1/+2=31/32
	rjmp	captb		; +2=33
	in	itemp, PadBct	; +1=33 count up counter if PI_PADB=H
	inc	itemp		; +1=34
	out	PadBct, itemp	; +1=35
	reti			; +4=39

captb:	in	itemp, PadBct	; +1=34 update PadBai only if PI_PADB=L
	out	PadBai, itemp	; +1=35
	reti			; +4=39 
	
	;; --- beep and LED (continued) ---
notogl:
	addi	itemp, 1<<PO_LED;	/ +1=19 toggle LED (ignore PD3)
	rjmp	intend		;	/ +2=21

	;; --- easy adc (continued) ---
prechg:	ori	itemp, (1<<PO_PACHG) | (1<<PO_PBCHG)	; +1=25 precharge caps
	out	PORTD, itemp	; +1=26
	clr	itemp		; +1=27
	out	PadAct, itemp	; +1=28  clear counterA
	out	PadBct, itemp	; +1=29 clear counterB
	reti			; +4=33
