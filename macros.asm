	;; ****** macro definitions ******
	;; --- mnemonic expansion ---
	.macro	addi
	subi	@0, -(@1)
	.endmacro
	
	.macro	addil
	subi	@0, low(-(@1))
	.endmacro
	
	.macro	adcih
	sbci	@0, high(-(@1))
	.endmacro	

	.macro	addiw
	subi	@1, low(-(@2))
	sbci	@0, high(-(@2))
	.endmacro

	.macro	adci
	sbci	@0, -(@1)
	.endmacro

	.macro	ldiw
	ldi	@0l, low(@1)
	ldi	@0h, high(@1)
	.endmacro

	.macro	lddz
	ldd	@0, z+(@1-Glob)
	.endmacro

	.macro	stdz
	std	z+(@0-Glob), @1
	.endmacro
	
	;; --- delays ---
	.macro	nop2
	rjmp	nxnop2		; only take 2 cycles
nxnop2:	
	.endmacro

	.macro	nop4
	rjmp	nxnop4a		; only take 4 cycles
nxnop4a:rjmp	nxnop4b
nxnop4b:	
	.endmacro

	.macro	nop8
	rjmp	nxnop8a		; only take 8 cycles
nxnop8a:rjmp	nxnop8b
nxnop8b:rjmp	nxnop8c
nxnop8c:rjmp	nxnop8d
nxnop8d:
	.endmacro

	.macro	waitcyc
	;; 12 <= param <= 777 and param has to be 3x number
	;; 3*n+9 cycle (1<=n<=256)
	ldi	wctr, (@0-9)/3	; 1c
	rcall	wait3n9		; 3c*n+8
	.endmacro


