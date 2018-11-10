;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
BASE 		EQU 		0x20000700
TARGET 		EQU 		0x20000700

;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			EXTERN		CONVRT
			EXTERN		DELAY100
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN		InChar	; Reference external subroutine	
            EXPORT 		__main
			ENTRY
			
__main 		
			B done
			
done 		
			B 			__main
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
