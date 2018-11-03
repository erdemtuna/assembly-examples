;*************************************************************** 
; Program_Directives.s  
; Copies the table from one location
; to another memory location.           
; Directives and Addressing modes are   
; explained with this program.   
;***************************************************************	
;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
;OFFSET  	EQU     	0x10
;FIRST	   	EQU	    	0x20000400	
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
;            AREA        sdata, DATA, READONLY
;            THUMB
;CTR1    	DCB     	0x10
;MSG     	DCB     	"Copying table..."
;			DCB			0x0D
;			DCB			0x04
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXPORT  	subnop	; Make available

subnop 		PROC
			PUSH 		{LR}
			NOP 			; Does nothing
			BL			subnop2
			NOP
			POP			{LR}
			BX 			LR ; Return to main program
			ENDP
			
subnop2 	PROC
			NOP 			; Does nothing
			NOP
			BX 			LR ; Return to main program
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
