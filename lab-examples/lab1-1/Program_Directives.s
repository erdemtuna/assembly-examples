;*************************************************************** 
; Program_Directives.s  
; Copies the table from one location
; to another memory location.           
; Directives and Addressing modes are   
; explained with this program.   
;***************************************************************	
;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
OFFSET  	EQU     	0x10
FIRST	   	EQU	    	0x20000400	
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
CTR1    	DCB     	0x10
MSG     	DCB     	"123456789..."
			DCB			0x0D
			DCB			0x04
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		OutStr	; Reference external subroutine	
			EXPORT  	__main	; Make available

__main
	LDR R0, = 0x20000400 ; Pointer laden
    LDR R1,[R0]
    BL KONVERT ; Unterprogramm KONVERT aufrufen
endlos         B        endlos


KONVERT
    LDRB    R3,[R0],#1 ; Byte laden
    AND     R1,R3,#0xF ; ASCII-HEX-Wandlung
    MOV     R2,R1 ; HEX-Zahl
    MOV     R4,#10

    LDRB    R3,[R0],#1 ; nächstes laden
    AND     R3,R3,#0xF ; ASCII-Hex-Wandlung
    ORR     R1,R3,R1,LSL #4 ; BCD-Wert bilden
    MLA     R2,R4,R2,R3 ; HEX-Zahl

    LDRB    R3,[R0],#1 ; nächstes laden
    AND     R3,R3,#0xF ; ASCII-Hex-Wandlung
    ORR     R1,R3,R1,LSL #4 ; BCD-Wert bilden
    MLA     R2,R4,R2,R3 ; HEX-Zahl

    LDRB    R3,[R0],#1 ; nächstes laden
    AND     R3,R3,#0xF ; ASCII-Hex-Wandlung
    ORR     R1,R3,R1,LSL #4 ; BCD-Wert bilden
    MLA     R2,R4,R2,R3 ; HEX-Zahl

    BX      LR ; Rücksprung
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
