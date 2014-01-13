	;; ***********************************************
	;; *                                             *
	;; *               TINY2313 PONG                 *
	;; *                                             *
	;; *              Created by Hazie               *
	;; *          make-it-hazy.blogspot.com          *
	;; *                                             *
	;; ***********************************************
	;; 
	;;   Before program the code,
	;;   set fuse-bit options bellow.
	;; 
	;;   - SELFPRGEN      = None (default)
	;;   - DWEN           = None (default)
	;;   - EESAVE         = None (default)
	;;   - SPI Enable     = Check (default)
	;;   - WDTON          = None (default)
	;;   - BODLEVEL       = Disable (default)
	;;   - RSTDISBL       = None (default)
	;;   - CKDIV8         = None
	;;   - CKOUT          = None (default)
	;;   - Ext XTAL, frequency 3.0-8.0MHz, startup 14CK + 4.1ms

	.include "tn2313def.inc"
	
	.listmac

	;; ****** macro definitions ******
	.include "macros.asm"	

	;; **** Constants ****
	.include "defs.asm"
	
	.cseg
	.org	0

	;; **** Vectors **********************************
	.include "vectors.asm"

	;; **** Flash Constants **************************
	.include "fconst.asm"

	;; **** Main (Reset Entry) ***********************
reset:
	;; initialize I/O pins and variables
	.include "init.asm"

	in	temp, MCUCR
	sbr	temp, 1<<SE	; sleep enable
	out	MCUCR, temp
	sei			; enable interrupt

	;; **** main loop ********************************
	.include "main.asm"

	;; **** timer1 compare match 1B interrupt handler ****
	.include "tim1oc1b.asm"

	;; **** pin-change interrupt handler ****
	.include "pcint0.asm"
