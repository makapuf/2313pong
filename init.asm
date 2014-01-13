	.def	temp	=r16	; temporary register

	;; initialize CPU
	ldi	temp, low(RAMEND)
	out	SPL, temp	; initialize stack pointer

	;; sleep/power-on
	ldi	temp, 1<<ACD	; disable analog comparator
	out	ACSR, temp
	ldi	temp, 1<<PCIE	; enable pin-change intr.
	out	GIMSK, temp
	ldi	temp, 1<<PI_BUT	; sense button
	out	PCMSK, temp
	ldi	temp, (1<<SE)|(1<<SM0)	; enable power-down sleep
	out	MCUCR, temp
	sei
	sleep
	;; ----------------
	;;  IN POWER DOWN
	;;  (less than 0.2uA @ Vcc=3.0V)
	;; ----------------
	sbic	PINB, PI_BUT	; wait for falling edge H->L
	rjmp	reset
	cli

	;; 
	;; initialize I/O pins
	;;

	ldi	temp, 0b11110100
	out	DDRD, temp	; PortD is set to xoooioii
	ldi	temp, 0b00000100
	out	PORTD, temp	; PortD is set to x0000100

	ldi	temp, 0b11111110
	out	DDRB, temp	; PortB is set to oooooooi
	ldi	temp, 0b00000000
	out	PORTB, temp	; PortB is set to 00000000

	ldi	temp, 1<<PUD	; pull-up disable
	out	MCUCR, temp

	;; Timer/Counter 1 initialization
	;; Clock source: System Clock
	ldi	temp, 0b10000010; clear on com1a, set on tc=0, ocr1a pwm, top=ICR1
	out	TCCR1A, temp
	ldi	temp, high((RESOL_X-1-CY_HSYNC)*2); initialize compare register
	out	OCR1AH, temp
	ldi	temp, low((RESOL_X-1-CY_HSYNC)*2); initialize compare register
	out	OCR1AL, temp
	ldi	temp, high(HOR_START*2)	; start raster
	out	OCR1BH, temp
	ldi	temp, low(HOR_START*2)	; start raster
	out	OCR1BL, temp
	ldi	temp, high((RESOL_X-1)*2)	; h-cycle
	out	ICR1H, temp
	ldi	temp, low((RESOL_X-1)*2)	; h-cycle
	out	ICR1L, temp
	ldi	temp, 1<<OCIE1B	; raster starts at HOR_START(=7)
	out	TIMSK, temp
	ldi	temp, 0b00011001; top=ICR1, run at fclk = 8MHz
	out	TCCR1B, temp

	;; 
	;; init variables
	;; 

	ldiw	z, Glob
	clr	temp
	stdz	Bepdu, temp	; Bepdu = 0;
	stdz	Gmstat, temp	; Gmstat = 0;
	stdz	Kystat, temp	; Kystat = 0;
	ldi	temp, -1
	stdz	Kyctr, temp	; Kyctr = -1;
	
	;; init register as global variable
	clr	line
	clr	tone
	out	TCNT1H, line
	out	TCNT1L, line

