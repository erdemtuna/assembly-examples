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
			;MOV     	R2, #99 MOD 10  ; R2 = 9
			LDR			R2, = 0x31		; ASCII "1"
			LDR			R3, = 28
			LDR			R1, = 0
			SUBS		R3, #0
			
for_8bit	BLO			done
			
			LDR			R0, [R4]		;bit-content
			LDR			R2, = 10
			UDIV		R0, R0, R2
			LSR			R0, R0, R3		;MSB 4 bit
			AND			R0, R0, #0xF
			CMP			R0, #0
			BEQ			fast_forw
			LDR			R1, = 1
			CMP			R0, #10
			BGE			downgrade
			ADD			R0, R0, #0x30
			STRB		R0, [R5], #1
			SUBS		R3, #4
			B for_8bit
fast_forw	SUBS		R3, #4
			CMP			R1, #0
			BEQ			for_8bit
			LDR			R0, = 0x30
			STRB		R0, [R5], #1
			B			for_8bit

downgrade	SUB			R0,#10
			ADD			R0, R0, #0x30
			STRB		R2, [R5], #1
			STRB		R0, [R5], #1
			SUBS		R3, #4
			B			for_8bit
			
done 		B 			done


			
			
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
