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
            EXPORT 		__main
__main 		LDR 		R0,=BASE 		; Initialize registers
            LDRB		R1, [R0]
			BFC			R1, #4, #4
			STRB		R1, [R0, #4]
			LDRB		R1, [R0]
			LSR			R1, R1, #4
			STRB		R1, [R0, #5]
done 		WFI 					    ; Infinite loop to
            B 			done 		    ; end program
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
