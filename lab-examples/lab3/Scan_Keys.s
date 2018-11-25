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
			EXTERN		Scan_Keys
			EXTERN		PRC_PINS
			EXTERN		ConfGPIOkeypad
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN		InChar	; Reference external subroutine	
			EXPORT  	ScanKeys	; Make available

ScanKeys PROC
	PUSH{R0}
	LDR	R0, = GPIO_PORTE_DATA	; check bit values
	LDR	R1, = GPIO_PORTB_DATA	; output ground
	MOV	R6, #0x4	; temp = 16
Count_Reset
	LDR	R2, = 16		; counter
	LDR R3, = 0x88888888	;  10001000, line grounder
	
	
Loop
	STRB R3, [R1]	; Output grounded Line
	ROR	R3, R3, #1	;
	
	
Check_Again
	BL DELAY100ms
	LDRB R5, [R0]	; load bit values
	
H_F	
;	CMP	R5, #0x0	; cmp with 1111
;	BNE H_E
;	SUB R2, #4
;	B	Loop		; if 1111, next line
	
H_E	
	CMP	R5, #0x1	; if 1110
	BNE H_D
	CMP	R5, R6		; check if changed
	BNE	Print
	SUB R2, #3
	MOV	R6, R2
	B Check_Again
	
H_D	
	CMP	R5, #0x2	; if 1101
	BNE H_B
	CMP	R5, R6		; check if changed
	BNE	Print
	SUB R2, #2
	MOV	R6, R2
	B Check_Again
	
H_B	
	CMP	R5, #0x4	; if 1011
	BNE H_7
	CMP	R5, R6		; check if changed
	BNE	Print
	SUB R2, #1
	MOV	R6, R2
	B Check_Again
	
H_7	
	CMP	R5, #0x8	; if 0111
	BNE Loop
	CMP	R5, R6		; check if changed
	BNE	Print
	SUB R2, #0
	MOV	R6, R2
	B Check_Again	
;;;;PUTBRACNH;;;;

Print
	PUSH{R4,R5,R3}
	LDR R5, = TARGET
	MOV R4, R6
	BL CONVRT
	BL OutStr
	POP{R4,R5,R3}
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
