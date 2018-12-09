;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
BASE 	EQU		0x20000700
TARGET	EQU 	0x20000700
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
	STR R4, [R5]
	MOV R0, #0

	;BL StepShifter
done

	B done

	END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END