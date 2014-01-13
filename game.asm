	;; game state machine
	.def	temp	=r22
	.def	work	=r23
	.def	stat	=r24
	
	lddz	stat, Gmstat
	cpi	stat, GM_NEW
	breq	gamenew
	cpi	stat, GM_SERV
	breq	gameserv
	cpi	stat, GM_PLAY
	breq	gameplay
	rjmp	gameset
	
	;; --- state NEW ---
	;; clear for new game
gamenew:
	clr	work
	stdz	ScoA, work
	stdz	ScoB, work

	lddz	work, PadAt
	andi	work, 0x01	; PadAt:0 as random number
	stdz	Server, work	; for server

	ldi	temp, 2		; initial speed is -2 or +2
	sbrc	work, 0		; if server is A, +2
	neg	temp		; otherwise -2
	stdz	Dirx, temp
	
	lddz	work, PadBt
	andi	work, 0x01	; PadBt:0 as random number for up/down

	ldi	temp, 1		; initial speed is -1 or +1
	sbrc	work, 0		; if server is A, +1
	neg	temp		; otherwise -1
	stdz	Diry, temp
	
	ldi	stat, GM_SERV
_gmnwby:rjmp	gamesavebye

	;; --- state SERV ---
	;; wait for button pushed to service
gameserv:
	lddz	temp, Server
	lddz	work, PadAt
	sbrc	temp, 0		; if (Server != 0)
	lddz	work, PadBt	;	B's Ball
	addi	work, PAD_HEI/2-BAL_HEI/2
	stdz	Ballt, work
	ldi	work, PADA_L+PAD_WID+8
	sbrc	temp, 0		; if (Server != 0)
	ldi	work, PADB_L-PAD_WID-8;	B's Ball
	stdz	Balll, work
	
	lddz	work, Dirx
	ldi	temp, 2		; set to initial speed
	sbrc	work, 7		; make absolute value
	neg	temp
	stdz	Dirx, temp
	
	lddz	work, Kystat	; if (Kystat != 0) {
	tst	work
	brne	gamestart
	rjmp	gamesavebye
gamestart:
	clr	work		;	Keystat = 0;
	stdz	Kystat, work	;	Gmstat = GM_PLAY;
	ldi	stat, GM_PLAY	; }
	rjmp	gamesavebye
	
	;; --- state PLAY ---
	;; play game
gameplay:
	.include "play.asm"

_gmst2b:lddz	work, Balll	; check goal or not
	cpi	work, 0
	brne	_gmgob
	lddz	work, ScoB	; if (Balll == A's goal) {
	inc	work		;	++ScoB;
	stdz	ScoB, work	;
	cpi	work, SET_SCORE	;	if (ScoB == 15)
	breq	_gmset		;		goto gameset;
	ldi	work, 1		;	Server = "B's Ball";
	stdz	Server, work	; 
	rjmp	_gmgoe		;	Gmstat = GM_SERV;
				; }
_gmgob:	cpi	work, DOT_VISBL-BAL_WID
	brne	gamesavebye	
	lddz	work, ScoA	; else if (Balll == B's goal) {
	inc	work		;	++ScoA;
	stdz	ScoA, work
	cpi	work, SET_SCORE	;	if (ScoA == 15)
	breq	_gmset		;		goto gameset;
	ldi	work, 0		;	Server = "A's Ball";
	stdz	Server, work	; 

_gmgoe:	ldi	stat, GM_SERV	;	Gmstat = GM_SERV;
_gmgos:	ldi	tone, BEP_TONE6
	ldi	work, 2		; envelope = 2*(1/60sec) = 0.03sec
	stdz	Bepdu, work
	rjmp	gamesavebye		; }
	
_gmset:	ldi	stat, GM_SET	;	Gmstat = GM_SET;
	rjmp	_gmgos
	
	
	;; --- state GAME SET ---
	;; wait for button pushed for new game
gameset:
	lddz	work, Kystat	; if (Kystat != 0) {
	tst	work
	breq	gamesavebye
	clr	work		;	Keystat = 0;
	stdz	Kystat, work	;	Gmstat = GM_PLAY;
	ldi	stat, GM_NEW	; }
	
gamesavebye:
	stdz	Gmstat, stat

	.include "ball_cache.asm"
	.include "beep.asm"
	.include "key.asm"
	.include "paddle.asm"
	.include "font_cache.asm"
