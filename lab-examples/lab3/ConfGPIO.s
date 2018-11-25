;***************************************************************
; DELAY100
;***************************************************************
GPIO_PORTB_DATA EQU 0x400053FC ;Port B data address
GPIO_PORTB_DIR EQU 0x40005400
GPIO_PORTB_AFSEL EQU 0x40005420
GPIO_PORTB_DEN EQU 0x4000551C
SYSCTL_RCGCGPIO EQU 0x400FE608
IOB EQU 0xF0	; LSB = input, MSB = output

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
			EXPORT  	ConfGPIO	; Make available

ConfGPIO PROC
	PUSH{R0, R1}
	
DO	LDR R1, =SYSCTL_RCGCGPIO
	LDR R0, [R1]
	ORR R0, R0, #0x12
	STR R0, [R1]
	NOP
	NOP
	NOP
	;configure port B
	LDR R1, =GPIO_PORTB_DIR
	LDR R0, [R1]
	BIC R0, #0xFF
	ORR R0, #IOB	;11110000
	STR R0, [R1]
	;configure port B
	;clear Alt. Function Select
	LDR R1, =GPIO_PORTB_AFSEL
	LDR R0, [R1]
	BIC R0, #0xFF
	STR R0, [R1]
	;clear Alt. Function Select
	; enable digital inputs
	LDR R1, =GPIO_PORTB_DEN
	LDR R0, [R1]
	ORR R0, #0xFF
	STR R0, [R1]
	; enable digital inputs
	
	
;	LDR R1, =GPIO_PORTE_DIR
;	LDR R0, [R1]
;	ORR R0, #IOE
;	STR R0, [R1]
;	LDR R1, =GPIO_PORTE_AFSEL
;	LDR R0, [R1]
;	BIC R0, #0xFF
;	STR R0, [R1]
;	LDR R1, =GPIO_PORTE_DEN
;	LDR R0, [R1]
;	ORR R0, #0xFF
;	STR R0, [R1]
	
EXI	POP{R0, R1}
	BX LR
	ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
