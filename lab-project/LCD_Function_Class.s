; Sets up SSI0, PA6, PA to work with the

; Pin connections
; ------------------------------------------
; Signal        (Nokia 5110) TIVA Pin
; ------------------------------------------
; 3.3V          (VCC, pin 1) power
; Ground        (GND, pin 2) ground
; SSI0Fss       (SCE, pin 3) connected to PA3
; Reset         (RST, pin 4) connected to PA7
; Data/Command  (D/C, pin 5) connected to PA6
; SSI0Tx        (DN,  pin 6) connected to PA5
; SSI0Clk       (SCLK, pin 7) connected to PA2
; back light    (LED, pin 8) connected to potentiometer

;GPIO Registers
GPIO_PORTA_DATA			EQU	0x400043FC	; Port A Data
GPIO_PORTA_IM      		EQU 0x40004010	; Interrupt Mask
GPIO_PORTA_DIR   		EQU 0x40004400	; Port Direction
GPIO_PORTA_AFSEL 		EQU 0x40004420	; Alt Function enable
GPIO_PORTA_DEN   		EQU 0x4000451C	; Digital Enable
GPIO_PORTA_AMSEL 		EQU 0x40004528	; Analog enable
GPIO_PORTA_PCTL  		EQU 0x4000452C	; Alternate Functions

GPIO_PORTB_DATA			EQU	0x400053FC	; Port B Data
GPIO_PORTB_IM      		EQU 0x40005010	; Interrupt Mask
GPIO_PORTB_DIR   		EQU 0x40005400	; Port Direction
GPIO_PORTB_AFSEL 		EQU 0x40005420	; Alt Function enable
GPIO_PORTB_DEN   		EQU 0x4000551C	; Digital Enable
GPIO_PORTB_AMSEL 		EQU 0x40005528	; Analog enable
GPIO_PORTB_PCTL  		EQU 0x4000552C	; Alternate Functions
	
;SSI Registers
SSI0_CR0				EQU	0x40008000
SSI0_CR1				EQU	0x40008004
SSI0_DR					EQU	0x40008008
SSI0_SR					EQU	0x4000800C
SSI0_CPSR				EQU	0x40008010
SSI0_CC					EQU	0x40008FC8
	
;System Registers
SYSCTL_RCGCGPIO  		EQU 0x400FE608	; GPIO Gate Control
SYSCTL_RCGCSSI			EQU	0x400FE61C	; SSI Gate Control
	
	    AREA    timer, CODE, READONLY
        THUMB

		EXPORT	Nokia_Init
		EXPORT	TxByte
		EXPORT	OutImgNokia
		EXPORT	SetCoordinate
		EXPORT	OutCharNokia
		EXPORT	OutStrNokia
		EXPORT	ClearNokia

; ASCII table for characters to be displayed
ASCII	DCB		0x00, 0x00, 0x00, 0x00, 0x00 ;// 20
		DCB		0x00, 0x00, 0x5f, 0x00, 0x00 ;// 21 !
		DCB		0x00, 0x07, 0x00, 0x07, 0x00 ;// 22 "
		DCB		0x14, 0x7f, 0x14, 0x7f, 0x14 ;// 23 #
		DCB		0x24, 0x2a, 0x7f, 0x2a, 0x12 ;// 24 $
		DCB		0x23, 0x13, 0x08, 0x64, 0x62 ;// 25 %
		DCB		0x36, 0x49, 0x55, 0x22, 0x50 ;// 26 &
		DCB		0x00, 0x05, 0x03, 0x00, 0x00 ;// 27 '
		DCB		0x00, 0x1c, 0x22, 0x41, 0x00 ;// 28 (
		DCB		0x00, 0x41, 0x22, 0x1c, 0x00 ;// 29 )
		DCB		0x14, 0x08, 0x3e, 0x08, 0x14 ;// 2a *
		DCB		0x08, 0x08, 0x3e, 0x08, 0x08 ;// 2b +
		DCB		0x00, 0x50, 0x30, 0x00, 0x00 ;// 2c ,
		DCB		0x08, 0x08, 0x08, 0x08, 0x08 ;// 2d -
		DCB		0x00, 0x60, 0x60, 0x00, 0x00 ;// 2e .
		DCB		0x20, 0x10, 0x08, 0x04, 0x02 ;// 2f /
		DCB		0x3e, 0x51, 0x49, 0x45, 0x3e ;// 30 0
		DCB		0x00, 0x42, 0x7f, 0x40, 0x00 ;// 31 1
		DCB		0x42, 0x61, 0x51, 0x49, 0x46 ;// 32 2
		DCB		0x21, 0x41, 0x45, 0x4b, 0x31 ;// 33 3
		DCB		0x18, 0x14, 0x12, 0x7f, 0x10 ;// 34 4
		DCB		0x27, 0x45, 0x45, 0x45, 0x39 ;// 35 5
		DCB		0x3c, 0x4a, 0x49, 0x49, 0x30 ;// 36 6
		DCB		0x01, 0x71, 0x09, 0x05, 0x03 ;// 37 7
		DCB		0x36, 0x49, 0x49, 0x49, 0x36 ;// 38 8
		DCB		0x06, 0x49, 0x49, 0x29, 0x1e ;// 39 9
		DCB		0x00, 0x36, 0x36, 0x00, 0x00 ;// 3a :
		DCB		0x00, 0x56, 0x36, 0x00, 0x00 ;// 3b ;
		DCB		0x08, 0x14, 0x22, 0x41, 0x00 ;// 3c <
		DCB		0x14, 0x14, 0x14, 0x14, 0x14 ;// 3d =
		DCB		0x00, 0x41, 0x22, 0x14, 0x08 ;// 3e >
		DCB		0x02, 0x01, 0x51, 0x09, 0x06 ;// 3f ?
		DCB		0x32, 0x49, 0x79, 0x41, 0x3e ;// 40 @
		DCB		0x7e, 0x11, 0x11, 0x11, 0x7e ;// 41 A
		DCB		0x7f, 0x49, 0x49, 0x49, 0x36 ;// 42 B
		DCB		0x3e, 0x41, 0x41, 0x41, 0x22 ;// 43 C
		DCB		0x7f, 0x41, 0x41, 0x22, 0x1c ;// 44 D
		DCB		0x7f, 0x49, 0x49, 0x49, 0x41 ;// 45 E
		DCB		0x7f, 0x09, 0x09, 0x09, 0x01 ;// 46 F
		DCB		0x3e, 0x41, 0x49, 0x49, 0x7a ;// 47 G
		DCB		0x7f, 0x08, 0x08, 0x08, 0x7f ;// 48 H
		DCB		0x00, 0x41, 0x7f, 0x41, 0x00 ;// 49 I
		DCB		0x20, 0x40, 0x41, 0x3f, 0x01 ;// 4a J
		DCB		0x7f, 0x08, 0x14, 0x22, 0x41 ;// 4b K
		DCB		0x7f, 0x40, 0x40, 0x40, 0x40 ;// 4c L
		DCB		0x7f, 0x02, 0x0c, 0x02, 0x7f ;// 4d M
		DCB		0x7f, 0x04, 0x08, 0x10, 0x7f ;// 4e N
		DCB		0x3e, 0x41, 0x41, 0x41, 0x3e ;// 4f O
		DCB		0x7f, 0x09, 0x09, 0x09, 0x06 ;// 50 P
		DCB		0x3e, 0x41, 0x51, 0x21, 0x5e ;// 51 Q
		DCB		0x7f, 0x09, 0x19, 0x29, 0x46 ;// 52 R
		DCB		0x46, 0x49, 0x49, 0x49, 0x31 ;// 53 S
		DCB		0x01, 0x01, 0x7f, 0x01, 0x01 ;// 54 T
		DCB		0x3f, 0x40, 0x40, 0x40, 0x3f ;// 55 U
		DCB		0x1f, 0x20, 0x40, 0x20, 0x1f ;// 56 V
		DCB		0x3f, 0x40, 0x38, 0x40, 0x3f ;// 57 W
		DCB		0x63, 0x14, 0x08, 0x14, 0x63 ;// 58 X
		DCB		0x07, 0x08, 0x70, 0x08, 0x07 ;// 59 Y
		DCB		0x61, 0x51, 0x49, 0x45, 0x43 ;// 5a Z
		DCB		0x00, 0x7f, 0x41, 0x41, 0x00 ;// 5b [
		DCB		0x02, 0x04, 0x08, 0x10, 0x20 ;// 5c '\'
		DCB		0x00, 0x41, 0x41, 0x7f, 0x00 ;// 5d ]
		DCB		0x04, 0x02, 0x01, 0x02, 0x04 ;// 5e ^
		DCB		0x40, 0x40, 0x40, 0x40, 0x40 ;// 5f _
		DCB		0x00, 0x01, 0x02, 0x04, 0x00 ;// 60 `
		DCB		0x20, 0x54, 0x54, 0x54, 0x78 ;// 61 a
		DCB		0x7f, 0x48, 0x44, 0x44, 0x38 ;// 62 b
		DCB		0x38, 0x44, 0x44, 0x44, 0x20 ;// 63 c
		DCB		0x38, 0x44, 0x44, 0x48, 0x7f ;// 64 d
		DCB		0x38, 0x54, 0x54, 0x54, 0x18 ;// 65 e
		DCB		0x08, 0x7e, 0x09, 0x01, 0x02 ;// 66 f
		DCB		0x0c, 0x52, 0x52, 0x52, 0x3e ;// 67 g
		DCB		0x7f, 0x08, 0x04, 0x04, 0x78 ;// 68 h
		DCB		0x00, 0x44, 0x7d, 0x40, 0x00 ;// 69 i
		DCB		0x20, 0x40, 0x44, 0x3d, 0x00 ;// 6a j
		DCB		0x7f, 0x10, 0x28, 0x44, 0x00 ;// 6b k
		DCB		0x00, 0x41, 0x7f, 0x40, 0x00 ;// 6c l
		DCB		0x7c, 0x04, 0x18, 0x04, 0x78 ;// 6d m
		DCB		0x7c, 0x08, 0x04, 0x04, 0x78 ;// 6e n
		DCB		0x38, 0x44, 0x44, 0x44, 0x38 ;// 6f o
		DCB		0x7c, 0x14, 0x14, 0x14, 0x08 ;// 70 p
		DCB		0x08, 0x14, 0x14, 0x18, 0x7c ;// 71 q
		DCB		0x7c, 0x08, 0x04, 0x04, 0x08 ;// 72 r
  		DCB		0x48, 0x54, 0x54, 0x54, 0x20 ;// 73 s
  		DCB		0x04, 0x3f, 0x44, 0x40, 0x20 ;// 74 t
		DCB		0x3c, 0x40, 0x40, 0x20, 0x7c ;// 75 u
		DCB		0x1c, 0x20, 0x40, 0x20, 0x1c ;// 76 v
		DCB		0x3c, 0x40, 0x30, 0x40, 0x3c ;// 77 w
		DCB		0x44, 0x28, 0x10, 0x28, 0x44 ;// 78 x
		DCB		0x0c, 0x50, 0x50, 0x50, 0x3c ;// 79 y
		DCB		0x44, 0x64, 0x54, 0x4c, 0x44 ;// 7a z
  		DCB		0x00, 0x08, 0x36, 0x41, 0x00 ;// 7b {
  		DCB		0x00, 0x00, 0x7f, 0x00, 0x00 ;// 7c |
  		DCB		0x00, 0x41, 0x36, 0x08, 0x00 ;// 7d }
  		DCB		0x10, 0x08, 0x08, 0x10, 0x08 ;// 7e ~
		SPACE	1		; added for padding
		;"
		;DCB		0XFF, 0x81, 0xfd, 0xd5, 0xd5, 0x9a, 0x81, 0xff ;// Battleship
		;DCB		0xFF, 0x81, 0xFD, 0xC5, 0xC5, 0xA9, 0x81, 0XFF ;// Civilianship
;*****************************************************************
; Initializes Nokia display
Nokia_Init
	PUSH	{LR}
	;Setup GPIO
	LDR 	R1, =SYSCTL_RCGCGPIO	; start GPIO clock
	LDR 	R0, [R1]                   
	ORR		R0, #0x1				; set bit 0	
	STR 	R0, [R1]                   
	NOP								; allow clock to settle
	NOP
	NOP								
	LDR		R1,=GPIO_PORTA_DIR		; make PA2,3,5,6,7 output
	LDR		R0, = 2_11101100		; and make PA4 input
	STR		R0,[R1]
	LDR		R1,=GPIO_PORTA_AFSEL	; enable alt funct on PA2,3,4,5
	MOV		R0, #0x3C
	STR		R0,[R1]
	LDR		R1,=GPIO_PORTA_DEN		; enable digital I/O at PA2,3,4,5,6,7
	MOV		R0, #0xFC
	STR		R0,[R1]					
	LDR		R1,=GPIO_PORTA_PCTL 	; configure PA2,3,4,5 as SSI
	LDR		R0, = 0x00222200			
	STR		R0,[R1]
	LDR		R1,=GPIO_PORTA_AMSEL	; disable analog functionality
	MOV		R0, #0x0
	STR		R0,[R1]
		
	;Setup SSI	
	LDR 	R1,=SYSCTL_RCGCSSI		; start SSI clock
	LDR 	R0,[R1]                   
	MOV		R0, #0x1				; set bit 0 for SSI0
	STR 	R0,[R1]                
	; small delay
	MOV		R0,#0x0F
waitSSIClk								; allow clock to settle
	SUBS	R0,R0,#0x01
	BNE		waitSSIClk

	LDR		R1,=SSI0_CR1			; disable SSI during setup and also set to Master
	LDR		R0, [R1]				; clear bit 1	and  clear bit 2 (you can clear all bits)
	BIC		R0, #0x06
	STR		R0,[R1]

	; Configure baud rate PIOSC=16MHz,Baud=2MHz,CPSDVSR=4,SCR=1
	; BR=SysClk/(CPSDVSR * (1 + SCR))
	LDR		R1,=SSI0_CC				; use PIOSC (16MHz)		
	LDR		R0, [R1]				; set bits 3:0 of the SSICC to 0x5 
	ORR		R0, #0x05
	STR		R0,[R1]
	LDR		R1,=SSI0_CR0			; set SCR bits to 0x01
	LDR		R0,[R1]
	;		________________				;
	STR		R0,[R1]
	LDR		R1,=SSI0_CPSR			; set CPSDVSR (prescale) to 0x04
	MOV		R0, #0x04
	STR		R0,[R1]
	LDR		R1,=SSI0_CR0			; clear SPH,SPO
	LDR		R0,[R1]					; choose Freescale frame format
	BIC		R0, #0x30				; clear bits 5:4 	
	ORR		R0, #0x7				; choose 8-bit data (set DSS bits to 0x07)
	STR		R0,[R1]
	LDR		R1,=SSI0_CR1			; enable SSI
	LDR		R0,[R1]
	ORR		R0, #0x02				; set bit 1
	STR		R0,[R1]
	; DC = PA7
	; Reset LCD memory	- reset already low
	; ensure reset is low
	LDR		R1,=GPIO_PORTA_DATA	
	LDR		R0, [R1]; clear reset(PA7) 	
	BIC		R0, #0x80
	STR		R0,[R1]

	MOV		R0,#10
delReset		
	SUBS	R0,R0,#1
	BNE		delReset

	LDR		R1,=GPIO_PORTA_DATA		; 
	LDR		R0, [R1]; set reset(PA7)
	ORR		R0, #0x80
	STR		R0,[R1]					;

	; Setup LCD
	LDR		R1,=GPIO_PORTA_DATA		; set PA6 low for Command
	LDR		R0,[R1]
	BIC		R0, #0x40
	STR		R0,[R1]

	;chip active (PD=0)
	;horizontal addressing (V=0)
	;extended instruction set (H=1)
	MOV		R5,#0x21
	BL		TxByte	
	;set contrast
	MOV		R5,#0xB8
	BL		TxByte
	;set temp coefficient
	MOV		R5,#0x04
	BL		TxByte
	;set bias 1:48: try 0x13 or 0x14
	MOV		R5,#0x14
	BL		TxByte
	;change H=0
	MOV		R5,#0x20
	BL		TxByte
	;set control mode to normal
	MOV		R5,#0x0C
	BL		TxByte
	; clear screen
	; screen memory is undefined after startup
	BL		ClearNokia
		
waitCMDDone		
	LDR		R1,=SSI0_SR				; wait until SSI is done
	LDR		R0,[R1]
	ANDS	R0,R0,#0x10
	BNE		waitCMDDone

	POP{LR}
	BX		LR
;*****************************************************************		

;----------------------------------
; Send 8 bits , a byte, to screen.
; Pass data with R5.
; Edits R0, R1.
;----------------------------------
TxByte
	PUSH {R0-R1}	
	LDR	R1,=SSI0_SR	

waitFIFOnotFull	
	LDR	R0,[R1]
	ANDS R0,R0,#0x02
	BEQ	waitFIFOnotFull ; wait if FIFO is full
	LDR R1,=SSI0_DR
	STRB R5,[R1]
	POP {R0-R1}
	BX LR
;*****************************************************************			

;*****************************************************************
; Send Image to Nokia routine	
OutImgNokia
	PUSH	{R0-R4,LR}
	PUSH	{R5}					; save Img address
	LDR		R1,=GPIO_PORTA_DATA		; set PA6 low for Command
	LDR		R0,[R1]
	BIC		R0,#0x40
	STR		R0,[R1]
	MOV		R5,#0x20				; ensure H=0
	BL		TxByte	
	MOV		R5,#0x40				; set Y address to 0
	BL		TxByte
	MOV		R5,#0x80				; set X address to 0
	BL		TxByte	
waitImgReady		
	LDR		R1,=SSI0_SR				; wait until SSI is done
	LDR		R0,[R1]
	ANDS	R0,R0,#0x10
	BNE		waitImgReady
	LDR		R1,=GPIO_PORTA_DATA		; ready: set PA6 high for Data
	LDR		R0,[R1]
	ORR		R0,#0x40
	STR		R0,[R1]	
	POP		{R5}
	MOV		R0,#504					; 504 bytes in full image
	MOV		R1,R5					; put img address in R1
sendNxtByteNokia		
	LDRB	R5,[R1],#1		; load R5 with byte, post inc address
	BL		TxByte
	SUBS	R0,#1
	BNE		sendNxtByteNokia		
	POP		{R0-R4,LR}
	BX		LR
;*****************************************************************

;*****************************************************************

;------------------------------------
; Set coordinates (x,y) of the screen
; Pass x coordinate by R0.
; Pass y coordinate by R1.
; Edits R0, R1.
;------------------------------------
SetCoordinate	
	; DC is left high, so data can be sent after
	PUSH {R2-R5,LR}
	PUSH {R0-R1}
	LDR	R1,=GPIO_PORTA_DATA ; set PA6 low for Command
	LDR	R0,[R1]
	BIC	R0,#0x40
	STR	R0,[R1]
	MOV	R5,#0x20 ; ensure H=0
	BL TxByte	
	POP	{R0-R1}
	MOV	R5,R1 ; set Y address
	ORR	R5,#0x40
	BL	TxByte
	MOV	R5,R0 ; set X address
	ORR	R5,#0x80
	BL TxByte

waitEndOfTransmission		
	LDR	R1,=SSI0_SR				
	LDR	R0,[R1]
	ANDS R0,R0,#0x10
	BNE	waitEndOfTransmission ; wait if transmission continues
	LDR	R1,=GPIO_PORTA_DATA ; set PA6 high for Data
	LDR	R0,[R1]
	ORR	R0,#0x40
	STR	R0,[R1]
	POP	{R2-R5,LR}
	BX LR
;*****************************************************************

;*****************************************************************
; output ASCII character to LCD screen
	; ASCII hex value passed via R5
	; This routine assumes coordinates have already been set
OutCharNokia
	PUSH	{R0-R4,LR}
	LDR		R1,=GPIO_PORTA_DATA		; set PA6 high for Data
	LDR		R0,[R1]
	ORR		R0,#0x40
	STR		R0,[R1]
	LDR		R1,=ASCII				; load address of ASCII table
	SUB		R2,R5,#0x20				; calculate offset of char
	MOV		R3,#0x05
	MUL		R2,R2,R3
	ADD		R1,R1,R2
	PUSH	{R5}					; save state of R5
	MOV		R0,#0x05				; 5 bytes in every char
	MOV		R2,#0x00				; 1 empty column between chars
sendCharByte		
	LDRB	R5,[R1],#1				
	BL		TxByte				; send each byte of char
	SUBS	R0,R0,#1
	BNE		sendCharByte
	MOV		R5,R2
	BL		TxByte				; tack space on after char
waitCharDone		
	LDR		R1,=SSI0_SR				; wait until SSI is done
	LDR		R0,[R1]
	ANDS	R0,R0,#0x10
	BNE		waitCharDone
	POP		{R5}
	POP		{R0-R4,LR}
	BX		LR
;*****************************************************************	

;*****************************************************************
; output ASCII string to LCD screen
	; Address of start of message passed via R5
	; Ended using EOT character 0x04
OutStrNokia		
	PUSH	{R0-R12,LR}
	MOV		R1,R5
nextStrChar
	LDRB	R5,[R1],#1
	CMP		R5,#0x04
	BEQ		doneStrNokia
	BL		OutCharNokia
	B		nextStrChar
doneStrNokia
	POP		{R0-R12,LR}
	BX		LR
;*****************************************************************

;*****************************************************************
; clear LCD screen
ClearNokia
	PUSH	{R0-R5,LR}
	LDR		R1,=GPIO_PORTA_DATA		; set PA6 low for Command
	LDR		R0,[R1]
	BIC		R0,#0x40
	STR		R0,[R1]
	MOV		R5,#0x20				; ensure H=0
	BL		TxByte	
	MOV		R5,#0x40				; set Y address to 0
	BL		TxByte
	MOV		R5,#0x80				; set X address to 0
	BL		TxByte	
waitClrReady		
	LDR		R1,=SSI0_SR				; wait until SSI is done
	LDR		R0,[R1]
	ANDS	R0,R0,#0x10
	BNE		waitClrReady
	LDR		R1,=GPIO_PORTA_DATA		; set PA6 high for Data
	LDR		R0,[R1]
	ORR		R0,#0x40
	STR		R0,[R1]	
	MOV		R0,#504					; 504 bytes in full image
	MOV		R5,#0x00				; load zeros to send
clrNxtNokia		
	BL		TxByte
	SUBS	R0,#1
	BNE		clrNxtNokia
waitClrDone			
	LDR		R1,=SSI0_SR				; wait until SSI is done
	LDR		R0,[R1]
	ANDS	R0,R0,#0x10
	BNE		waitClrDone
	POP		{R0-R5,LR}
	BX		LR
	;*****************************************************************		
	ALIGN
	END