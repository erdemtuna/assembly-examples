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
Stack 		EQU 		0x00000400
input 		EQU 		6
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA 		main, READONLY, CODE
StackMem 	SPACE 		Stack

__main 		MOV 		R0,#0x42 ; Initialize R0 and R1
			MOV 		R1,#0x55
			PUSH 		{R0} ; Save them on stack
			PUSH 		{R1}
			BL 			subnop ; Call subroutine
			POP 		{R1} ; Pull off stack
			POP 		{R0}
done 		B 			done
subnop 		NOP 			; Does nothing
			NOP
			BX 			LR ; Return to main program
			END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
