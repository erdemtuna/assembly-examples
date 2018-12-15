;***************************************************************
; ConfGPIOkeypad
;***************************************************************
GPIO_PORTB_DATA EQU 0x400053FC ;Port B data address
GPIO_PORTB_DIR EQU 0x40005400
GPIO_PORTB_AFSEL EQU 0x40005420
GPIO_PORTB_DEN EQU 0x4000551C
SYSCTL_RCGCGPIO EQU 0x400FE608
GPIO_PORTB_PUR EQU 0x40005510 
IOB EQU 0x0F	; LSB = output
PUB	EQU	0x0F	; pull up LSB enabled.

GPIO_PORTE_DATA EQU 0x400243FC ;Port E data address
GPIO_PORTE_DIR EQU 0x40024400
;PUR a c t u al a d d r e s s
GPIO_PORTE_AFSEL EQU 0x40024420
GPIO_PORTE_DEN EQU 0x4002451C
IOE EQU 0x00	; input(not used)

	
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXPORT  	ConfGPIOkeypad	; Make available

ConfGPIOkeypad PROC
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
	LDR R0 , =GPIO_PORTB_PUR
	MOV R1 , #PUB
	STR R1 , [ R0 ]
	
	
	LDR R1, =GPIO_PORTE_DIR
	LDR R0, [R1]
	ORR R0, #IOE
	STR R0, [R1]
	LDR R1, =GPIO_PORTE_AFSEL
	LDR R0, [R1]
	BIC R0, #0xFF
	STR R0, [R1]
	LDR R1, =GPIO_PORTE_DEN
	LDR R0, [R1]
	ORR R0, #0xFF
	STR R0, [R1]

	
EXI	POP{R0, R1}
	BX LR
	ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
