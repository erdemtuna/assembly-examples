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
BASE 		EQU 		0x0000FFFF
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
			EXTERN		CONVRT
			EXTERN		OutStr	; Reference external subroutine	
            EXPORT 		__main
			ENTRY
			
__main 		
			LDR			R4, = BASE
			LDR			R5, = TARGET
			
			BL			CONVRT
			
			BL			OutStr
			
done 		B 			__main
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
