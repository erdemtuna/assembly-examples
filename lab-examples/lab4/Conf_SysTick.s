;***************************************************************
;***************************************************************
STRELOAD EQU 0xE000E014
STCURRENT EQU 0xE000E018
STCTRL EQU 0xE000E010
SHP_SYSPRI3 EQU 0xE000ED20
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXPORT  	Conf_SysTick	; Make available

Conf_SysTick PROC
	
	LDR R0, = STCTRL ; stop clock
	MOV32 R1, #0x00000000
	STR R1,[R0]
	
	LDR R0, = STRELOAD
	STR R7,[R0] ; set in main or interrupts
	
	LDR R0, = STCURRENT ; reset
	MOV32 R1, #0x00000000
	STR R1,[R0]
	
	LDR 	R0,=SHP_SYSPRI3			
	MOV 	R1,#0x40000000
	STR 	R1,[R0] 
	
	LDR R0, = STCTRL
	MOV32 R1, #0x01 ; POSC clock
					; no interrupt
					; clock enabled
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

