;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
DIGITS 		EQU 		0x200005FF
TARGET 		EQU 		0x20000700
STORE  	EQU     	0x20000500
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			EXTERN		CONVRT
			EXTERN		TRAVERS
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN		InChar	; Reference external subroutine	
            EXPORT 		__main
			ENTRY
			
__main 		LDR			R7, = DIGITS
			LDR			R5, = 0xFF	;	start with FF
			STRB		R5, [R7], #1
			B			GET_IC
			
GET_IC		BL			InChar	; store chars of n
			CMP			R5, #0xA
			BEQ			GET_STONES
			SUB			R5, #0x30
			PUSH{R5}
			STRB		R5, [R7], #1
			B			GET_IC

GET_STONES	MOV			R0, #1	; digit pointer
			MOV			R1, #0	; soulstone counter
			MOV			R2, #10
			LDR			R5, = 0xFF
			STRB		R5, [R7]	; terminate with FF
LOOP		LDRB		R5, [R7, #-1]!
			CMP			R5, #0xFF
			BEQ			FORWARD
			MUL			R5, R5, R0
			ADD			R1, R5
			CMP			R0, #0
			BEQ			z_digit
			MUL			R0, R0, R2
			B			LOOP
z_digit		ADD			R0, R0, #1
			B			LOOP
			
FORWARD		LDR			R7, = DIGITS +1 	; restore digit locations
			BL			TRAVERS
			MOV			R3, #0xFF
			
CMPR		LDRB 		R4, [R8,#-1] !
			CMP			R4, #0xFF
			BEQ			COUT
			CMP			R4, R3
			BGE			CMPR
			MOV			R4, R3
			B			CMPR
			

COUT		LDR			R5, = TARGET
			BL			OutStr
			
			
done 		
			B 			__main
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
