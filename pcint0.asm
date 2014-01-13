	;; **** pin-change interrupt handler ****
powint0:	
	clr	temp
	out	MCUCR, temp
	out	GIMSK, temp
	out	PCMSK, temp
	reti
