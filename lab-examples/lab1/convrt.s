;***************************************************************
; CONVRT
;	Converts the HEX number stored in R4 to 
;	the decimal equivalent, stores the characters
;	at the location specified by R5.
;***************************************************************
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
;OFFSET  	EQU     	0x10
;FIRST	   	EQU	    	0x20000400
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
	AREA    	routines, READONLY, CODE
	THUMB
	EXPORT  	CONVRT	; Make available

CONVRT 	PROC
	PUSH{R0-R12}
	MOV R0, #10 ; multiplier
	MOV R6, #0 ; counter
	CMP	R4, #0
	BEQ Memory_for_Zero
	
Iterate_Digits
	CMP	R4, #0
	BEQ Revert_the_Order
	ADD R6, R6, #1 ; incr. counter, update flags
	UDIV R3, R4, R0 ; R3 = R4/10
	MUL	R3, R3, R0 ; R3 = R3*10
	SUB	R2, R4, R3 ; R2 = R4-R3
				   ; digit itself is R2
	ADD	R2, R2, #0x30 ; integer to ascii char
	PUSH{R2} ; store digit in memory
	UDIV R4, R4, R0 ; R4 = R4/10
	B Iterate_Digits
	
Memory_for_Zero
	ADD	R4, R2, #0x30 ; integer to ascii char
	STRB R4, [R5],#1
	B EOC_EOL
	
Revert_the_Order ; digits are found from LSB to MSB
   			     ; the order must be reversed
	CMP R6, #0
	BEQ EOC_EOL
	POP{R2}
	STRB R2, [R5], #1
	SUBS R6, R6, #1 ; decr. counter, update flags
	B Revert_the_Order
	
EOC_EOL ;indicate end of chars and end of line
	MOV	R1, #0x0D
	STRB R1, [R5],#1
	MOV	R1, #0x04
	STRB R1, [R5],#1

EXIT		
	POP{R0-R12}
	BX LR
	ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
	ALIGN
	END
