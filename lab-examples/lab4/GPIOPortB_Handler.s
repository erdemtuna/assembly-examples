;***************************************************************
;***************************************************************
;***************************************************************
; Program section
GPIO_PORTB_DIR EQU 0x40005400
IOB EQU 0xF0	; 11110000
GPIO_PORTB_OUT EQU 0x400053C0
GPIO_PORTB_IN EQU 0x4000503C
shift_r EQU 0x88888888
shift_l EQU 0x11111111
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXTERN		DELAY100us
			EXPORT  	GPIOPortB_Handler

GPIOPortB_Handler PROC
	;PUSH{R0,R1}
	LDR R1, = GPIO_PORTB_IN
	LDR R0, = GPIO_PORTB_OUT
Detect_IN
	LDR R2, [R1]
	CMP R2, #0xB
	BEQ S_L
	CMP R2, #0xD
	BEQ S_R
	BX LR
	
S_R
	LDR R1, = shift_r
S_R_Loop	
	STRB R1, [R0]
	ROR R1, R1, #1
	PUSH {LR}
	BL DELAY100us
	POP{LR}
	CMP R1, #shift_r
	;B S_R_Loop
	BNE S_R_Loop
	BEQ	QUIT

S_L
	LDR R1, = shift_l
S_L_Loop	
	STRB R1, [R0]
	ROR R1, R1, #3
	PUSH {LR}
	BL DELAY100us
	POP {LR}
	CMP R1, #shift_l
	;B S_L_Loop
	BNE S_L_Loop
	BEQ	QUIT
QUIT
	;PUSH{LR}
	;POP{R0,R1}
	BX LR
	ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END