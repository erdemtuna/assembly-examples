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
CONST 		EQU 		0x20
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
			
__main 		MOV 		R0,#0x42 ; Initialize R0 and R1
			MOV 		R1,#0x55
			PUSH 		{R0, R1} ; Save them on stack
			
			BL 			subnop ; Call subroutine
			POP 		{R0, R1} ; Pull off stack
			;POP 		{R0}
done 		B 			done


			
			
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
