;***************************************************************
; DELAY100
;	Introdues delay about 100 ms
; Formulation
;	The internal clock of the MCU is 16 MHz.
;	That means one cycle is 62.5e-9 seconds.
;	(100e-3)/(62.5e-9) = 1.6e+6 cycles.
;	100 ms delay --> 1600000 cycles.
;	LDR = 1 Cycle
;	SUBS = 1 Cycle
;	SUBS = 1 Cycle
;	BNE = 1 + 2 Cycles
;	BX = 1 + 2 Cycles	
;	N = 399998
;***************************************************************
CYCLES	EQU	0x1312CFF	; 19999999
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXPORT  	DELAY5s	; Make available

DELAY5s PROC
	PUSH{R0}
	LDR	R0, = CYCLES
DECR	
	SUBS R0, #1
	BNE	DECR
	
	POP{R0}
	BX LR
	ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
