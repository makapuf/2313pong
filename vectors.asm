	;; **** Vectors **********************************
	rjmp	reset		; #1:	hardware reset
	reti			; #2:	external int0
	reti			; #3:	external int1
	reti			; #4:	timer1 capture
	reti			; #5:	timer1 compA
	reti			; #6:	timer1 overflow
	reti			; #7:	timer0 overflow
	reti			; #8:	usart rx
	reti			; #9:	usart udre
	reti			; #10:	usart tx
	reti			; #11:	analog comparator
	rjmp	powint0		; #12:	pcint
	rjmp	tim1oc1b	; #13:	timer1 compB
	reti			; #14:	timer0 compA
	reti			; #15:	timer0 compB
	reti			; #16:	usi start
	reti			; #17:	usi overflow
	reti			; #18:	ee_rdy
	reti			; #19:	watchdog complete

