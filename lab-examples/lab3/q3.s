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
		EXTERN		ScanKeys
		EXTERN		PRC_PINS
		EXTERN		ConfGPIOkeypad
		EXTERN		OutStr	; Reference external subroutine	
		EXTERN		InChar	; Reference external subroutine	
		EXPORT 		__main
		ENTRY
			
__main 	
	BL ConfGPIOkeypad
	
hi	
	BL	ScanKeys
;	BL	PRC_PINS
	BL	DELAY100ms

done	
	B	hi	
	END 