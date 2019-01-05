;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
TARGET 		EQU 		0x20001000
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
	AREA 		main, READONLY, CODE
	THUMB
	EXTERN		CONVRT
	EXTERN		OutStr	; Reference external subroutine	
	EXPORT 		__main
	ENTRY
			
__main 		
	MOV32 R4, #18
	LDR	R5, = TARGET ; load the target location
	BL CONVRT
	BL OutStr
	B __main
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
	END
