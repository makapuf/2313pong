	;; key sensing
	;;	Kyctr = -1					: pushed in advance
	;;	Kyctr = 0					: not pushed (Kystat = 0)
	;;	Kyctr = 1..(BUT_PUSH_SHORT - 1)			: pushed but not released
	;;	Kyctr = BUT_PUSH_SHORT..(BUT_PUSH_LONG -1)	: short pushed (Kystat = 1)
	;;	Kyctr = BUT_PUSH_LONG..				: long pushed (to POWER OFF)
	
	.def	stat	=r23
	.def	ctr	=r24

	lddz	stat, Kystat
	lddz	ctr, Kyctr

	cpi	ctr, -1		; switch (Kyctr) {
	brne	_kynone		; case -1:	/* pushed in advance */
	sbis	PINB, PI_BUT	;	if (PINB != "pushed") {
	rjmp	_kyend		; 
	inc	ctr		;		++Kyctr;
	clr	stat		;		Kystat = 0;
				;	}
	rjmp	_kyend		;	break;
_kynone:tst	ctr		; 
	brne	_kypush		; case 0:	/* not pushed */
	sbis	PINB, PI_BUT	; 	if (PINB == "pushed") 	/* falling edge detected */	
	inc	ctr		; 		++Kyctr;
	rjmp	_kyend		;	break;
_kypush:cpi	ctr, BUT_PUSH_SHORT
	brsh	_kyshrt		; case 1..(BUT_PUSH_SHORT - 1):	/* pushed */
	inc	ctr		;	++Kyctr;
	sbic	PINB, PI_BUT	; 	if (PINB != "pushed") 	/* released */
	clr	ctr		;		Kyctr = 0;
	rjmp	_kyend		;	break;
_kyshrt:cpi	ctr, BUT_PUSH_LONG
	brsh	_kylong		; case BUT_PUSH_SHORT..(BUT_PUSH_LONG -1):	/* short pushed */
	inc	ctr		;	++Kyctr;
	sbis	PINB, PI_BUT	; 	if (PINB != "pushed") { /* released */
	rjmp	_kyend		; 
	clr	ctr		;		Kyctr = 0;
	ldi	stat, 1		;		Kystat = 1;
				;	}
	rjmp	_kyend		;	break;
_kylong:			; default:	/* long pushed */
	cli			;	cli();
	clr	ctr
	out	TCCR1A, ctr	;	TCCR1A = 0x00;	/* disable timer */
	out	TCCR1B, ctr	;	TCCR1B = 0x00;
	out	DDRB, ctr	;	DDRB = 0x00;	/* disable all ports */
	out	PORTB, ctr	;	PORTB = 0x00;
	out	DDRD, ctr	;	DDRD = 0x00;
	out	PORTD, ctr	;	PORTD = 0x00;
	rjmp	reset		; 	goto reset;	/* to power off */
				;}
_kyend:	stdz	Kystat, stat
	stdz	Kyctr, ctr
