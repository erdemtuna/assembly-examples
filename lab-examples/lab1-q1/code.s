;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
BASE 		EQU 		0x000A03EF
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
			LDR			R4, = BASE	; load the number to R4
			LDR			R5, = TARGET	; load the saving
										; location to R5
			BL			CONVRT
			BL			OutStr
done 		B 			__main
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
