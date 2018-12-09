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
		EXTERN		PULSE_INIT
		EXTERN		OutStr	; Reference external subroutine	
		EXTERN		InChar	; Reference external subroutine	
		EXPORT 		__main
		ENTRY
			
__main 	
	BL PULSE_INIT
	CPSIE	I			; Enable Interrupts
	
wait_int
	WFI					; Wait for next interrupt
	B wait_int

	END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
