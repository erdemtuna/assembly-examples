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
;*******************************x********************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT

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
				
				
__main 
	;MRS R0, BASEPRI
	;MOV R1, #2_10100000
	;ORR R0, R1, R0
;	MSR	BASEPRI, R0
;	CPSIE I
	LDR R0, = 0x00000001
	ROR R0, R0, #31
done	B done

;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
