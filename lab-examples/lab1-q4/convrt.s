;***************************************************************
; CONVRT
;	Converts the HEX number stored in R4 to 
;	the decimal equivalent, stores the characters
;	at the location specified by R5.
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
			EXPORT  	CONVRT	; Make available

CONVRT 		PROC
			B			SAVE
				
SAVE		PUSH{R0,R3,R2,R6,R7,R1,R4,R5}
			B START
			
START		LDR			R1, = 10
			LDR			R6, = 10
			MOV			R0, R4		; Number itself
			CMP			R1, #0		;clear carry

LOOP		BEQ			NEXT
			UDIV		R2, R0, R1		; R2 = R0/10
			MOV			R4, R2
			MUL			R2, R1			; R2 *= 10
			SUB			R3, R0, R2		; R3 = R0-R2
			MOV			R0, R4
			ADD			R3, #0x30

			PUSH		{R3}
			SUBS		R6, #1
			B			LOOP

NEXT		LDR			R0, = 10	 	; new counter
			LDR			R1, = 0x30
			SUBS		R0, #1			; clear xPSR
			B			RETRIEVE

ctr			SUBS		R0, #1
RETRIEVE
			POP			{R4}
			CMP			R1, R4
			BEQ			ctr
			STRB		R4, [R5], #1
			LDR			R1, =0x29
			CMP			R0, #0
			BNE			ctr
			LDR			R6, =0x0D
			STRB		R6 , [R5], #1
			LDR			R6, =0x04
			STRB		R6, [R5], #1
			B			EXIT
			
EXIT		POP{R0,R3,R2,R6,R7,R1,R4,R5}
			BX			LR
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
