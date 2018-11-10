;***************************************************************
; UPBND
;	Updates boundaries R0 (low) and R1 (high), according to
;	value in R5. If R5 = 1, guess was lower ; if R5 = 0, guess
;	was higher. The boundaries are updated with the value in R4.
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
			EXPORT  	UPBND	; Make available

UPBND 		PROC
			
			CMP			R5, #1
			BNE			INC_G
			MOV			R0, R4
			B			BACK
			
INC_G		MOV			R1, R4
			B			BACK

BACK		BX			LR
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
