;***************************************************************
; Program PracticeLab.s
; Clear memory locations 0x2000.0400 - 0x2000.041F,
; then load these locations with consecutive numbers starting
; with 00.
; 'CONST' is the number of locations operated on.
; 'FIRST' is the address of first memory address.
;***************************************************************

;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
BASE 		EQU 		0x20000400
TARGET 		EQU 		0x20001000
;***************************************************************
; Program section
;(Nibble separation) Write a program which takes the 32 bits
;stored starting at the location 0x20000040 and stores the four least
;significant bits (LSBs) of the least significant byte in location
;0x20000044, i.e., separate these bits, and stores the four most
;significant bits (MSB) of the least significant byte in location
;0x20000045 as the least significant bits.
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			EXTERN		subnop
            EXPORT 		__main
			ENTRY
			
__main 		LDR			R4, = BASE
			LDR			R5, = TARGET
			LDR			R1, = 10
			LDR			R6, = 10
			LDR			R0, [R4] 		; Number itself

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
			
NEXT		LDR			R0, = 11	 	; new counter
			LDR		R1, = 0x30
			SUBS		R0, #1			; clear xPSR
			B			RETRIEVE
			
RETRIEVE	
			POP			{R4}
			CMP			R1, R4
			BEQ			RETRIEVE
			STRB		R4, [R5], #1
			LDR		R1, =0x29
			SUBS		R0, #1
			BNE			RETRIEVE
			
			
			
done 		B 			done


			
			
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
