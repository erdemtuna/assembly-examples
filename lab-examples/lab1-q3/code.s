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
			EXTERN		UPBND
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN		InChar	; Reference external subroutine	
            EXPORT 		__main
			ENTRY
			
__main 		B			GET_IC
			
GET_IC		BL			InChar	; store chars of n
			CMP			R5, #0xA
			BEQ			GET_N
			SUB			R5, #0x30
			PUSH{R5}
			B			GET_IC

GET_N		MOV			R1, #10	; get n as hex
			POP{R5}
			ADD			R2, R5
			POP{R5}
			MUL			R5,R5,R1
			ADD			R2,R5
			MOV			R5, #32
			SUB			R2, R5, R2
			B			INIT
			
INIT		LDR			R0, = 0x0	; lower bound
			LDR			R1, = 0xFFFFFFFF	; upper bound
			LSR			R1, R1, R2 ; set upper bound (with n)
			
GUESS		ADD			R4, R1, R0	; R4 = R1 + R0
			LSR			R4, #1	; R4 = R4/2
			LDR			R5, = TARGET
			BL			CONVRT
			B			GUESS_O
			
GUESS_O		BL			OutStr
			MOV			R3, #2
			
FEED_B		BL			InChar	; store chars of n
			PUSH{R5}
			SUBS		R3, #1
			BNE			FEED_B
			
COMP		POP{R5}
			POP{R5}
			CMP			R5, #0x43	; C
			BEQ			CORRECT
			CMP			R5, #0x44	; D
			BEQ			DOWN
			CMP			R5, #0x55	; U
			BEQ			UP

RETURN		BL			UPBND
			B			GUESS
			
CORRECT		B			done

DOWN		LDR			R5, = 0
			B			RETURN
			
UP			LDR			R5, = 1
			B			RETURN
			
done 		
			B 			__main
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
