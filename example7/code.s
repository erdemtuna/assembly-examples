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

;***************************************************************
; Program section
; (Maximum value) Length (NOT 0) of a memory array, which
; contains unsigned numbers, is in 0x2000.0044 and the array
; starts at 2x0000.0048. Write a program that places the maximum
; value in the array in 0x2000.0040.
;***************************************************************
; int* max = 0x2000.0040;
; max = ARR;
; for (int i=0; i < N; i++){
; 	if(max < (ARR+i))
;		max = (ARR+i)
; }
; 
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
            EXPORT 		__main
__main 		LDR			R0, = 0x20000400	; max
			LDR			R1, = 0x20000404
			LDR			R2, [R1], #4		; R2 = counter
											; R1 = 0x20000408
			LDR			R4, [R1], #4		; *max = *R1
			MOV			R0, [R4]		; *max = *R1
			
LOOP		CMP			R2, #0
			BEQ			done
			LDR			R3, [R1], #4
			CMP			R1, R0
			BCC			LOOP
			LDR			R0, [R1]
            
done 		B 			done 		    ; end program
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
