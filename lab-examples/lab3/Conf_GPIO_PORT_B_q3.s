;***************************************************************
;***************************************************************
CLOCK	EQU 0x400FE608
PORT_B_DATA	EQU	0x40005000
PORT_B_DIR EQU	0x40005400
PORT_B_AFSEL EQU	0x40005420
PORT_B_DEnable EQU	0x4000551C
PORT_B_ISense EQU	0x40005404
PORT_B_IBothE EQU	0x40005408
PORT_B_IEvent EQU	0x4000540C
PORT_B_IMask EQU	0x40005410
PORT_B_IRawS EQU	0x40005414
PORT_B_IMaskS EQU	0x40005418
PORT_B_IClear EQU	0x4000541C
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXPORT  	ConfGPIOstepper	; Make available

ConfGPIOstepper PROC
	
	LDR R0, = CLOCK
	MOV32 R1, #0x0F
	STRB R1,[R0]
	NOP
	NOP
	NOP
	
	LDR R0, = PORT_B_DIR
	MOV32 R1, #0xF0
	STRB R1,[R0]
	
	LDR R0, = PORT_B_AFSEL
	MOV32 R1, #0x00
	STRB R1,[R0]
	
	LDR R0, = PORT_B_DEnable
	MOV32 R1, #0xFF
	STRB R1,[R0]
	
	LDR R0, = PORT_B_ISense
	MOV32 R1, #0x00
	STRB R1,[R0]
	
	LDR R0, = PORT_B_IBothE
	MOV32 R1, #0x00
	STRB R1,[R0]
	
	LDR R0, = PORT_B_IEvent
	MOV32 R1, #0x0F
	STRB R1,[R0]
	
	LDR R0, = PORT_B_IMask
	MOV32 R1, #0x0F
	STRB R1,[R0]
	
	CPSIE I
	
	BX LR
	ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
