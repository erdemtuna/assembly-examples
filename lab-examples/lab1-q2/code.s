;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
NUM 		EQU 		0x20000400
TARGET 		EQU 		0x20001000
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			EXTERN		CONVRT
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN		InChar	; Reference external subroutine	
            EXPORT 		__main
			ENTRY
			
__main 		
			BL			InChar	;stores the input at R5
			LDR			R3, = NUM	; get the location pointed
			LDR			R4, [R3]	; load the content
			LDR			R5, = TARGET 
			BL			CONVRT
			BL			OutStr
			
done 		
			B 			__main
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
