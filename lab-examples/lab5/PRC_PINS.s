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
IOB EQU 0xF0	; LSB = input, MSB = output
	
Bit_Check EQU 0x1

;GPIO_PORTE_DATA EQU 0x400243FC ;Port E data address
;GPIO_PORTE_DIR EQU 0x40024400
;GPIO_PORTE_AFSEL EQU 0x40024420
;GPIO_PORTE_DEN EQU 0x4002451C
;IOE EQU 0x00
	
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXPORT  	PRC_PINS	; Make available

PRC_PINS PROC
	PUSH{R0}
	LDR	R0, = 0xFF
DO	
	AND	R0, R0, R1
	LSL	R0, R0 ,#4
	LSR	R1, R1, #4
	ORR	R1,R1,R0
	
EXI	
	POP{R0}
	BX LR
	ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
