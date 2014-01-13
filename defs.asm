	;; **** Constants ****
	;; VIDEO related defs
	;; 
	;; *ADJ* in comment for user-adjustable parameter
	;; 
	.equ	FCLK	=8000000; cpu clock = 8MHz
	.equ	DCLK	=FCLK/2	; dot clock = 4MHz
	.equ	FHSYNC	=15625	; horizontal sync frequency (error +0.6%)
	.equ	DIVHSYNC=DCLK/FHSYNC; DIVISOR to make FHSYNC

	.equ	CY_HSYNC=10	; *ADJ* cycles for H-sync in H-blank <<< smaller to shift left

	.equ	RESOL_X	=256	; horizontal resolution in dot
	.equ	RESOL_Y	=256	; vertical resolution in dot
	.equ	HOR_START=6	; *ADJ* horizontal line starts in dot <<< smaller to shift left
	.equ	LN_FRONT=1	; *ADJ* lines before V-sync <<< smaller to shift up
	.equ	LN_VSYNC=3	; lines for V-sync
	.equ	LN_BACK	=16	; *ADJ* lines after V-sync
	.equ	LN_VBLNK=LN_FRONT+LN_VSYNC+LN_BACK; lines in V-blank
	.equ	LN_FRAME=256	; lines a frame
	.equ	LN_VIDEO=LN_FRAME-LN_VBLNK
	.equ	LN_VISBL=LN_VIDEO; actual visible lines
	.equ	LAST_RASTER=LN_VISBL-1 ; last raster number
	.equ	START_VSYNC=LAST_RASTER+LN_FRONT
	.equ	END_VSYNC=START_VSYNC+LN_VSYNC
	.equ	DOT_VISBL=192	; non-blanking period in dots
	.equ	HOR_CENT=DOT_VISBL/2; horizontal center
	.equ	VER_CENT=LN_VISBL/2; vertical center
	;-------------------------------#0
	;LN_	LN_	
	;FRAME	VIDEO	LN_VISBL=236
	;=256	=236	
	;
	;
	;
	;	------------------------#235
	;	LN_	LN_FRONT=1
	;	VBLNK	----------------#236 =START_VSYNC
	;	=20	LN_VSYNC=3
	;		----------------#239 =END_VSYNC
	;		LN_BACK=16
	;-------------------------------

	.equ	SIDE_WID=10	; side line width -- adjust with 4-16
	.equ	COURT_MIN=SIDE_WID
	.equ	COURT_MAX=LAST_RASTER-SIDE_WID
	.equ	DGT_PIXSZ=4	; pixel size of score in dots or lines
	.equ	DGT_WID=3	; width of score digit in pixels
	.equ	DGT_HEI=5	; height of score digit in pixels
	.equ	DGT_TOP=28	; top location of score
	.equ	DGT_BOT=DGT_TOP+DGT_HEI*DGT_PIXSZ-1; bottom location of score
	.equ	PAD_HEI=20	; paddle height
	.equ	PAD_WID=8	; paddle width
	.equ	PADA_L=8	; paddle A left
	.equ	PADB_L=DOT_VISBL-PAD_WID-8	; paddle B left
	.equ	PADT_MIN=COURT_MIN; paddle top min
	.equ	PADT_MAX=COURT_MAX-PAD_HEI; paddle top max
	.equ	BAL_HEI=8	; ball height
	.equ	BAL_WID=8	; ball width
	.equ	BEP_TONE1=0b00111111; beep tone pattern lowest ( 122Hz)
	.equ	BEP_TONE2=0b00011111; beep tone pattern lower  ( 244Hz)
	.equ	BEP_TONE3=0b00001111; beep tone pattern higher ( 488Hz)
	.equ	BEP_TONE4=0b00000111; beep tone pattern highest( 977Hz)
	.equ	BEP_TONE5=0b00000011; beep tone pattern super  (1953Hz)
	.equ	BEP_TONE6=0b00000001; beep tone pattern hyper  (3906Hz)
	.equ	SET_SCORE=15	; game-set score
	.equ	BUT_PUSH_SHORT = 5; button short-push threshold in 1/60sec
	.equ	BUT_PUSH_LONG = 250; button long-push threshold in 1/60sec

	;; PADDLE related defs
	.equ	PAD_PRECHG=5	; paddle analog precharge period [H-lines]
	.equ	PAD_AI_MAX=250	; paddle analog input limit value
	;; accelerating location inside of paddle
	.equ	PAD_LOC_0=0
	.equ	PAD_LOC_1=PAD_HEI*10/100
	.equ	PAD_LOC_2=PAD_LOC_1+PAD_HEI*30/100
	.equ	PAD_LOC_3=PAD_LOC_2+PAD_HEI*20/100
	.equ	PAD_LOC_4=PAD_LOC_3+PAD_HEI*30/100
	.equ	PAD_LOC_5=PAD_LOC_4+PAD_HEI*10/100
	;; +-+ ---------------- 0 = PAD_LOC_0
	;; | | 10% for slower
	;; |P| ---------------- 2 = PAD_LOC_1
	;; |A| 30% for no change
	;; |D| ---------------  8 = PAD_LOC_2
	;; |D| 20% for faster
	;; |L| --------------- 12 = PAD_LOC_3
	;; |E| 30% for no change
	;; | | --------------- 18 = PAD_LOC_4
	;; | | 10% for slower
	;; +-+ --------------- 20 = PAD_LOC_5
	
	;; **** Port B ****
	.equ	PO_VIDEO=7	; VIDEO signal output
	.equ	PI_BUT	=0	; BUTTON input (negative)

	;; **** Port D ****
	.equ	PI_PADA	=0	; PADDLE-A analog input
	.equ	PI_PADB	=1	; PADDLE-B analog input
	.equ	PO_LED	=2	; LED sink(-) output
	.equ	PO_PACHG=4	; PADDLE-A precharge output
	.equ	PO_PBCHG=5	; PADDLE-B precharge output
	.equ	PO_BEEP	=6	; BEEP signal output

	;; **** GPIO as fast memory ****
	.equ	PadAct=GPIOR0	; paddle A counter
	.equ	PadBct=GPIOR1	; paddle B counter
	.equ	PadAai=GPIOR2	; paddle A analog in
	.equ	PadBai=OCR0B	; paddle B analog in

	;; **** Global vars ******************************
	;; while raster sending period
	.def	rast0	=r0	; raster buffer 0 (dot 0-7)
	.def	rast1	=r1	; raster buffer 1 (dot 8-15)
	.def	rast2	=r2	; raster buffer 2 (dot 16-23)
	.def	rast3	=r3	; raster buffer 3 (dot 24-31)
	.def	rast4	=r4	; raster buffer 4 (dot 32-39)
	.def	rast5	=r5	; raster buffer 5 (dot 40-47)
	.def	rast6	=r6	; raster buffer 6 (dot 48-55)
	.def	rast7	=r7	; raster buffer 7 (dot 56-63)
	.def	rast8	=r8	; raster buffer 8 (dot 64-71)
	.def	rast9	=r9	; raster buffer 9 (dot 72-79)
	.def	rast10	=r10	; raster buffer 10 (dot 80-87)
	.def	rast11	=r11	; raster buffer 11 (dot 88-95)
	.def	rast12	=r12	; raster buffer 12 (dot 96-103)
	.def	rast13	=r13	; raster buffer 13 (dot 104-111)
	.def	rast14	=r14	; raster buffer 14 (dot 112-119)
	.def	rast15	=r15	; raster buffer 15 (dot 120-127)
	.def	rast16	=r16	; raster buffer 16 (dot 128-135)
	.def	rast17	=r17	; raster buffer 17 (dot 136-143)
	.def	rast18	=r18	; raster buffer 18 (dot 144-151)
	.def	rast19	=r19	; raster buffer 19 (dot 152-159)
	.def	rast20	=r20	; raster buffer 20 (dot 160-167)
	.def	rast21	=r21	; raster buffer 21 (dot 168-175)
	.def	rast22	=r22	; raster buffer 22 (dot 176-183)
	.def	rast23	=r23	; raster buffer 23 (dot 184-191)

;;	.def	work1	=r24	; scratch
	.def	itemp	=r25	; scratch for int-handler
;;	.def	work2	=r26	; scratch
;;	.def	work3	=r27	; scratch
	.def	line	=r28	; line counter
	.def	tone	=r29	; tone pattern
	;; z = r31:r30		; working pointer

	;; **** Game state ****
	.equ	GM_NEW	=0
	.equ	GM_SERV	=1
	.equ	GM_PLAY	=2
	.equ	GM_SET	=3

	;; **** SRAM allocation **************************
	.dseg
Glob:				; global var start address
Bepdu:	.byte	1		; beep duration time (multiple of VSYNC)
Kyctr:	.byte	1		; key counter
Kystat:	.byte	1		; key state
Gmstat:	.byte	1		; game state

Glob_no_init:
PadAt:	.byte	1		; paddle A top
PadBt:	.byte	1		; paddle B top
Ballt:	.byte	1		; ball top
Balll:	.byte	1		; ball left
Ballad:	.byte	1		; ball byte address r0-r23
Ballpt:	.byte	1		; ball location pattern
Dirx:	.byte	1		; ball direction X
Diry:	.byte	1		; ball direction Y
ScoA:	.byte	1		; score A 0-15
ScoB:	.byte	1		; score B 0-15
Server:	.byte	1		; serving player 0/1=A/B
Ftbuf:	.byte	5*2		; font buffer 8bit*5row*2score
Globend:			; global var end address
