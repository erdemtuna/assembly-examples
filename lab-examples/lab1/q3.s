;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
TARGET 		EQU 		0x20000700
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
	AREA 		main, READONLY, CODE
	THUMB
		
range_message DCB "First Enter n to specify range [0,2^n]: ", 0x0D, 0x04
correct_message DCB "I found it!1!!1!!, reset board to play again ", 0x0D, 0x04
	EXTERN		CONVRT
	EXTERN		UPBND
	EXTERN		OutStr	; Reference external subroutine	
	EXTERN		InChar	; Reference external subroutine	
	EXPORT 		__main
	ENTRY
			
__main 		
	MOV	R0, #10	; 10 multiplier
	MOV	R1, #0 ;lowbound
	MOV R2, #1 ;upbound
	LDR R5, = range_message
	BL OutStr
Input_N
	BL InChar ; store chars of n
	CMP R5, #0xA ; 'enter' char
	BEQ N_to_Decimal ; if enter pressed, process the data
	SUB R5, #0x30 ; if it is not 'enter', then
				  ; char --> integer conversion
    ADD	R3, #1 ;counter
	PUSH{R5}
	B Input_N

N_to_Decimal
	MOV R4, #0
	
One_Digit
	POP{R5}
	ADD R4, R4, R5 ; R4 = digit0
	CMP R3, #1
	BNE Two_Digits
	B Set_Initial_Bounds
	
Two_Digits
	POP{R5}
	MUL R5, R5, R0
	ADD R4, R4, R5 ; R4 = digit1*10 + digit0
	B Set_Initial_Bounds

Set_Initial_Bounds
	MOV R3, #32
	SUB	R3, R3, R4 
	ROR R2, R3 ; ASL 32-input
	B Guess
	
Guess
	ADD R3, R2, R1 ; add bounds
	ASR R3, R3, #1 ; divide by 2
	MOV R4, R3 ; output
	LDR R5, = TARGET
	BL CONVRT
	BL OutStr
	
Input_Char
	BL InChar ; store chars of n
	CMP R5, #0xA ; 'enter' char
	BEQ Check_Correct ; if enter pressed, process the data
	SUB R5, #0x43 ;
	PUSH{R5}
	B Input_Char
	
Check_Correct
	POP {R5}
	CMP R5, #0 ; if is 0, then found
	BEQ Correct_Guess
	BL UPBND
	B Guess

Correct_Guess
	LDR R5, = correct_message
	BL OutStr
done 
	B done
	END
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
