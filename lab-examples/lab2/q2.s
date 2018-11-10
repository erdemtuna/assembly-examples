;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
GPIO_PORTB_DATA EQU 0x400053FC ;Port B data address

;LABEL DIRECTIVE VALUE COMMENT
		AREA sdata , DATA, READONLY
		THUMB
R_I		DCB    	"Reading Input"
		DCB		0x0D
		DCB		0x04
		
W_O		DCB    	"Writing Output"
		DCB		0x0D
		DCB		0x04

;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
		AREA 		main, READONLY, CODE
		THUMB
		EXTERN		CONVRT
		EXTERN		DELAY5s
		EXTERN		DELAY100ms
		EXTERN		PRC_PINS
		EXTERN		ConfGPIO
		EXTERN		OutStr	; Reference external subroutine	
		EXTERN		InChar	; Reference external subroutine	
		EXPORT 		__main
		ENTRY
			
__main 	
	BL ConfGPIO
	
hi	LDR R5, = R_I
	BL OutStr ; Copy message
	LDR	R0, = GPIO_PORTB_DATA ; load addr
	LDRB R1, [R0] ; read the pin values
	BL	PRC_PINS
	LDR R5, = W_O
	BL OutStr ; Copy message
	STRB R1, [R0]
	BL	DELAY5s
done	
	B	hi	
	END 

