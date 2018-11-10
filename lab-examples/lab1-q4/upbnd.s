;***************************************************************
; UPBND
;	Updates boundaries R0 (low) and R1 (high), according to
;	value in R5. If R5 = 1, guess was lower ; if R5 = 0, guess
;	was higher. The boundaries are updated with the value in R4.
;***************************************************************
;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
STORE  	EQU     	0x20000500
STOREq  	EQU     	0x20000550
;FIRST	   	EQU	    	0x20000400
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
;            AREA        sdata, DATA, READONLY
;            THUMB
;CTR1    	DCB     	0x10
;MSG     	DCB     	"Copying table..."
;			DCB			0x0D
;			DCB			0x04
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines, READONLY, CODE
			THUMB
			EXTERN		CONVRT
			EXPORT  	TRAVERS	; Make available

TRAVERS		PROC
			PUSH{R1,R7,LR}
			LDR	R8, = STORE
			MOV R2, #0xFF
			STRB R2, [R8, #-1]
			MOV R2, #1	;clear R2
			B START

START		PUSH{R1,R7,LR}
COND		B COND_1
			
COND_1		CMP R1, #100	; R1 HOLDS SOULSTONE!!!
						; R7 HOLDS DIGITS!!!!
			BMI	COND_2
			B	P_1
			
P_1			SUB	R1, #47
			BL START

COND_2		CMP R1, #50
			BLS COND_3
			AND R0, R1, #1
			CMP R0, #1
			BNE	COND_3
			B	P_2

;P_2			LDRB R0, [R7], #1
;			CMP R0, #0xFF
;			BEQ	P2_RES
;			CMP R0, #0x00
;			BEQ	P_2
;			MUL R2,R2,R0
;			B P_2

P_2			LDR R5, = STOREq
			MOV R4, R1
			BL CONVRT
LOOP2		LDRB R0, [R5], #1
			CMP R0, #0x0D
			BEQ	P2_RES
			CMP R0, #0x00
			BEQ	LOOP2
			SUB R0, R0, #0x30
			MUL R2,R2,R0
			B LOOP2
			
P2_RES		SUB R1, R2
			BL START
			
			
COND_3		AND R0, R1, #1
			CMP R0, #1
			BEQ	COND_4
			B	P_3
			
P_3			LSR	R1, #1
			BL START

COND_4		MOV	R0,	R1
			MOV	R2, #7
			UDIV R0, R0, R2
			MUL	R0, R2
			SUB R0, R1, R0
			CMP	R0, #0
			BNE	QUIT
			B P_4
			
P_4			MOV	R0,	R1
			MOV	R2, #3
			UDIV R0, R0, R2
			MUL	R0, R2
			SUB R1, R1, R0
			BL START
				
QUIT		STRB R1, [R8], #1
;			MOV	R2, #0xFF
;			STRB R2, [R8], #1
			POP{R1,R7,LR}
			BX LR
			
BACK		MOV	R2, #0xFF
			STRB R2, [R8], #1
			POP{R1,R7,LR}
			
			BX			LR
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
