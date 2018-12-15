;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
GPIO_PORTB_DIR EQU 0x40005400
IOB EQU 0xF0	; 11110000
GPIO_PORTB_OUT EQU 0x400053C0
GPIO_PORTB_IN EQU 0x4000503C
PORT_B_IClear EQU	0x4000541C
PORT_B_IRawS EQU	0x40005414
STCTRL EQU 0xE000E018
shift_r EQU 0x88888888
shift_l EQU 0x11111111
;LABEL DIRECTIVE VALUE COMMENT
		AREA sdata , DATA, READONLY
		THUMB
;MSG		DCB    	"delaying..."

;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
		AREA 		main, READONLY, CODE
		THUMB
		EXTERN		ConfGPIOstepper
		EXTERN		Conf_SysTick
		EXPORT 		__main
		ENTRY
			
__main 	
	BL ConfGPIOstepper
	MOV32 R7, #4000000; initial delay 1s
	BL Conf_SysTick
	LDR R5, = 0XE000E100
	MOV32 R4, #0x00FF00F
	MOV R11, #0x0
	STR R4, [R5]
	MOV R0, #0
	
Inf_Loop
	CMP R11, #0x0
	BEQ Inf_Loop
	CMP R11, #0x2
	ITE EQ
	BLEQ S_L
	BLNE S_R
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	EXPORT  	GPIOPortB_Handler
GPIOPortB_Handler PROC
	;PUSH{R0,R1}
	LDR R1, = PORT_B_IRawS
	LDR R0, = GPIO_PORTB_OUT
	LDR R4, = STCTRL
Detect_IN
	LDR R2, [R1]
	CMP R2, #0x1
	BEQ Slower
	CMP R2, #0x8
	BEQ Faster
	CMP R2, #0x2
	BEQ S_L
	CMP R2, #0x4
	BEQ S_R
	LDR R0, = PORT_B_IClear
	MOV32 R1, #0xff
	STR R1, [R0]
	BX LR
	
S_R
	LDR R1, = shift_r
	MOV R11, #0x4
S_R_Loop	
	STRB R1, [R0]
	ROR R1, R1, #1
Wait_Clock_R
	PUSH {LR}
	BL Check_Count
	POP{LR}
	CMP R5, #1
	BNE Wait_Clock_R
	CMP R1, #shift_r
	;B S_R_Loop
	BNE S_R_Loop
	BEQ	QUIT

S_L
	LDR R1, = shift_l
	MOV R11, #0x2
S_L_Loop	
	STRB R1, [R0]
	ROR R1, R1, #3
Wait_Clock_L	
	PUSH {LR}
	BL Check_Count
	POP{LR}
	CMP R5, #1
	BNE Wait_Clock_L
	CMP R1, #shift_l
	;B S_L_Loop
	BNE S_L_Loop
	BEQ	QUIT
QUIT
	;PUSH{LR}
	;POP{R0,R1}
	LDR R0, = PORT_B_IClear
	MOV32 R1, #0xff
	STR R1, [R0]
	BX LR
	
Check_Count
	LDR R5, [R4]
	BX LR
	
Slower
	CMP R7, #400; min delay 100us
	BLE QUIT
	LSR R7, R7, #1
	PUSH {LR}
	BL Conf_SysTick ;reconf systick
	POP {LR}
	B QUIT
	
Faster
	LSL R9, R7, #1
	MOV32 R8, #16777215
	CMP R9, R8 ; max delay 24bits
	BGE QUIT
	LSL R7, R7, #1
	PUSH {LR}
	BL Conf_SysTick ;reconf systick
	POP {LR}
	B QUIT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END