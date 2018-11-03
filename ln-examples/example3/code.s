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
; Write a program which places the lower half word of the 4
; byte data saved starting from location 0x20000040 in location
; 0x20000050 and the higher half word in location 0x00000060.
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
            EXPORT 		__main
__main 		LDR 		R0,=BASE 		; Initialize registers
            LDR			R1, [R0]		; load R1 with the content of R0
			STRH		R1, [R0, 0x100]  ; save the HW to R0+0x10
			LSR			R1, R1, 16
			STRH		R1, [R0, 0x200]			
done 		WFI 					    ; Infinite loop to
            B 			done 		    ; end program
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
