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
BASE_N 		EQU 		0x20000000
BASE_S 		EQU 		0x20004000
BASE_D 		EQU 		0x20004000
;***************************************************************
; Program section
; (Data transfer) The length of the data array is in memory
; location 0x20000000, the data originally starts in memory
; location 0x20004000 (Source Address), and the destination area
; for the data starts in memory location 0x20008000 (Destination
; Address). Write a program to transfer the data.
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
            EXPORT 		__main
__main 		LDR 		R0,= BASE_N 		; R0 = arr
			LDR			R1, [R0]
			LDR			R2, = BASE_S
			LDR			R3, = BASE_D
			
loop		LDR			R4, [R2], #4
			STR			R4, [R3], #4
			SUBS 		R1, #1
			BNE			loop
            
done 		B 			done 		    ; end program
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
