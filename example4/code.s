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
; (Addition of an array of n four-byte unsigned numbers)
; Memory location 0x20000040 contains the length (NOT 0) of a set of
; numbers. The set starts at memory location 0x20000044. Write a
; program that stores the sum of numbers (< 2^64) starting from
; memory location 0x20001000.
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
            EXPORT 		__main
__main 		LDR 		R0,=BASE 		; R0 = arr
            LDR			R1, [R0]		; R1 = n
			BFC			R2, #0, #32		; R2 = 0
			BFC			R3, #0, #32		; R3 = 0
			
while_cond	CMP			R1, #0
			BEQ			end
			BCS			in_while
			
			
in_while	LDR			R4, [R0,#4]!
			ADDS		R2, R2, R4
			BCS			extend_sum
			BCC			decr_count
						
			
extend_sum	ADD			R3,#1
			B			decr_count
			
decr_count	SUB			R1, #1
			B			while_cond

end			LDR			R0, =0x20001000
			STRD		R2, R3, [R0]

done 		B 			done 		    ; end program
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
