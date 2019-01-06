;****************************************
; NokiaTest-Class-main.s
; Used to test Nokia5110-Class.s
; inlcude startup.s

  
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA    |.text|, READONLY, CODE
			THUMB

gameplayBorder		
			; 2_xxxx.xxxx (data content)
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 ; 0:[0,13]
 			DCB		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 ; 0:[14,27]
 			DCB		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 ; 0:[28,41]
			DCB		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 ; 0:[42,55]
			DCB		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 ; 0:[56,69]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 0:[70,83]

			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 1:[0,13]
 			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 1:[14,27]
 			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 1:[28,41]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 1:[42,55]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff ; 1:[56,69]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 1:[70,83]

			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 2:[0,13]
 			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 2:[14,27]
 			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 2:[28,41]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 2:[42,55]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff ; 2:[56,69]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 2:[70,83]

			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[0,13]
 			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[14,27]
 			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[28,41]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[42,55]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff ; 3:[56,69]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[70,83]

			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[0,13]
 			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[14,27]
 			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[28,41]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[42,55]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff ; 3:[56,69]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 3:[70,83]

			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ; 0:[0,13]
 			DCB		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ; 0:[14,27]
 			DCB		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ; 0:[28,41]
			DCB		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ; 0:[42,55]
			DCB		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ; 0:[56,69]
			DCB		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 0:[70,83]


tstmsg		DCB		"+",0x04
			;SPACE	0		; added for padding
		
			EXTERN	Nokia_Init			
			EXTERN	OutImgNokia
			EXTERN	SetCoordinate
			EXTERN	TxByte
			EXTERN	OutStrNokia
			EXTERN	ClearNokia
			
			EXPORT  Start
				

Start		BL		Nokia_Init			; initialize LCD
loadRam		
			;MOV		R0, #6
			;MOV		R1, #1			; DC is left high ready to send data
			;LDR		R5,=tstmsg
			;BL		OutStrNokia
			;BL		delay
			LDR		R5,=gameplayBorder			; load img address of Ram
			BL		OutImgNokia			; use img routine

			MOV		R2, #6
			MOV		R1, #1
cursor		MOV		R0, R2
			BL		SetCoordinate			; DC is left high ready to send data
			LDR		R5,=tstmsg
			BL		OutStrNokia
			ADD		R2, R2, #8
			CMP		R2, #75
			BLE		cursor
donethis	B		donethis
			
;			BL		delay				; leave image for a few s
			
;			MOV							; reset XY position to 0,0
;			MOV							; using setXY routine
		;	BL		SetCoordinate			; DC is left high ready to send data
; transition to CSU											
		;	MOV		R0,#504				; 504 bytes in full image
		;	LDR		R1,=imgCSU			; put img address in R1
sendNxtCSUByte		
;			LDRB					; load R5 with byte, post inc addr
			BL		TxByte			; use byte routine
			BL		delayTrans			; slow down loading of next byte
			SUBS	R0,#1
			BNE		sendNxtCSUByte

			BL		delay				; leave image for a few s

;clear screen using ClearNokia routine
			BL		ClearNokia
			

;			MOV							; X pos (0-83)
;			MOV							; Y pos (0-5)
			BL		SetCoordinate			; set XY position
			LDR		R5,=tstmsg
			BL		OutStrNokia
			
			BL		delay				; leave text up
		
done		B		loadRam				; loop 		
	
	
delay		PUSH	{R0}
			MOV		R0,#0x8555
			MOVT	R0,#0x0140
del			SUBS	R0,#1
			BNE		del
			POP		{R0}
			BX		LR

delayTrans	PUSH	{R0}
			MOV		R0,#0x5855			;~250ms
			MOVT	R0,#0x0014
dt			SUBS	R0,#1
			BNE		dt
			POP		{R0}
			BX		LR
			
			
			ALIGN
			END
