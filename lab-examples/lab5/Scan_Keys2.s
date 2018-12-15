;***************************************************************
; PRC_PINS
;	R1 is the input register.
;	R1 is the output register.
	
;***************************************************************
GPIO_PORTB_DATA EQU 0x400053FC ;Port B data address
GPIO_PORTB_DIR EQU 0x40005400
GPIO_PORTB_AFSEL EQU 0x40005420
GPIO_PORTB_DEN EQU 0x4000551C
SYSCTL_RCGCGPIO EQU 0x400FE608
IOB EQU 0x0f	; LSB = output, MSB = input(not used)

GPIO_PORTE_DATA EQU 0x400243FC ;Port E data address
GPIO_PORTE_DIR EQU 0x40024400
GPIO_PORTE_PUR EQU 0x40024510 ;PUR a c t u al a d d r e s s
GPIO_PORTE_AFSEL EQU 0x40024420
GPIO_PORTE_DEN EQU 0x4002451C
IOE EQU 0x00	; input(not used)
PUE	EQU	0x0F	; pull up LSB enabled.
	
TARGET EQU 0x20001000	
	
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXTERN		CONVRT
			EXTERN		DELAY5s
			EXTERN		DELAY100ms
			EXTERN		PRC_PINS
			EXTERN		ConfGPIOkeypad
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN		InChar	; Reference external subroutine	
			EXPORT  	ScanKeys	; Make available

ScanKeys PROC
	PUSH{R0,R1,R2,R3}
	LDR	R0, = GPIO_PORTE_DATA	; check bit values
	LDR	R1, = GPIO_PORTB_DATA	; output ground
	MOV R9, #4
	
Count_Reset
	LDR	R2, = 16	; counter
	LDR R3, = 0x88888888	;  10001000, line grounder
	
Refresh	
	LDR	R4, = 5		; line counter
	
Loop
	SUBS R4, #1
	MOVEQ	R4, #4
	ROR	R3, R3, #1	;
	STRB R3, [R1]	; Output grounded Line
	
Check	
	LDRB R5, [R0]	; load bit values
	
	CMP R5, #1
	BLO Loop
	
	BEQ	Place_1
	CMP	R5,	 #2
	BEQ	Place_2
	CMP	R5,	 #4
	BEQ	Place_3
	BNE	Place_4
	
Place_1
	MUL R6, R4, R9
	SUB	R6, #3
	MOV	R7, R5
	B Check_Again
	
Place_2
	MUL R6, R4, R9
	SUB	R6, #2
	MOV	R7, R5
	B Check_Again
	
Place_3
	MUL R6, R4, R9
	SUB	R6, #1
	MOV	R7, R5
	B Check_Again
	
Place_4
	MUL R6, R4, R9
	MOV	R7, R5
	B Check_Again
	
Check_Again
	BL	DELAY100ms
	LDRB R5, [R0]	; load bit values
	
	CMP R5, R7
	BEQ	Loop
	B	Print
	
Print
	PUSH{R4,R5,R3,R7,R2,R6}
	LDR R5, = TARGET
	MOV R4, R6
	BL CONVRT
	BL OutStr
	POP{R4,R5,R3,R7,R2,R6}
	B Loop
	
EXIT	
	POP{R0}
	BX LR
	ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
