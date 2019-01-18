;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
; ADC Registers
RCGCADC				EQU	0x400FE638	; ADC clock register
ADC_0_ACTSS			EQU 0x40038000	; Sample sequencer (ADC_0 base address)
ADC_0_RIS			EQU 0x40038004	; Interrupt status
ADC_0_IM			EQU 0x40038008	; Interrupt select
ADC_0_EMUX			EQU 0x40038014	; Trigger select
ADC_0_PSSI			EQU 0x40038028	; Initiate sample
ADC_0_SSCTL0		EQU 0x40038044	; Sample sequence control
ADC_0_SSFIFO3		EQU 0x400380A8	; Channel 3 results
ADC_0_PC			EQU 0x40038FC4	; Sample rate
	
ADC_1_ACTSS			EQU 0x40039000	; Sample sequencer (ADC_1 base address)
ADC_1_RIS			EQU 0x40039004	; Interrupt status
ADC_1_IM			EQU 0x40039008	; Interrupt select
ADC_1_EMUX			EQU 0x40039014	; Trigger select
ADC_1_SSMUX3		EQU 0x400390A0	; Sample sequencer
ADC_1_PSSI			EQU 0x40039028	; Initiate sample
ADC_1_SSCTL0		EQU 0x40039044	; Sample sequence control
ADC_1_SSFIFO3		EQU 0x400390A8	; Channel 3 results
ADC_1_PC			EQU 0x40039FC4	; Sample rate
	
; GPIO Registers 
RCGCGPIO		  	EQU 0x400FE608	; GPIO clock register
; PORT E base address = 0x40024000
GPIO_PORTE_DEN		EQU 0x4002451C	; Digital Enable
GPIO_PORTE_PCTL		EQU 0x4002452C	; Alternate function select
GPIO_PORTE_AFSEL	EQU 0x40024420	; Enable Alt functions
GPIO_PORTE_AMSEL	EQU 0x40024528	; Enable analog
	
TARGET EQU 0x20001000		
;LABEL DIRECTIVE VALUE COMMENT
		AREA sdata , DATA, READONLY
		THUMB
Volt_Text 	DCB     	"Voltage(mV): "
			DCB			0x0D
			DCB			0x04
DOT			DCB			0x2E
			DCB			0x0D
			DCB			0x04

;MSG		DCB    	"delaying..."

;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
		AREA 		main, READONLY, CODE
		THUMB
		EXPORT ADC_1_Read_Y
		EXPORT ADC_0_Read_X
		EXPORT Find_Pixel_Coordinate
		EXPORT ADC_Init
		EXPORT 		__main
		ENTRY
			
__main

	BL ADC_Init
loop
	BL ADC_0_Read_X
	MOV R3, #58
	BL Find_Pixel_Coordinate
	BL ADC_1_Read_Y
	MOV R3, #825
	BL Find_Pixel_Coordinate
	B loop	
;-------------------------------------------
; Read ADC_1 value and map to 0-3.3 V range
; Return in R1
;-------------------------------------------
ADC_1_Read_Y
	PUSH{R0, R2-R12} ; push general purpose registers
	PUSH{LR} ; push link register
	; initialize addess registers
	LDR	R2, =ADC_1_PSSI
	LDR	R3, =ADC_1_RIS 
	LDR	R4, =ADC_1_SSFIFO3
	LDR	R0, [R2]
	ORR R0, R0, #0x0F ; set bit 3 to enable seq 3
	STR	R0, [R2]
	NOP
	NOP
	NOP
	
	LDR	R0, [R3] ; check if sample is complete
	ANDS R0, R0, #0x08
	BNE	ADC_1_Read_Y
	
	LDR	R1, [R4] ; load reading in R1
	MOV R7, #3300 ; max voltage
	MOV	R8, #4096 ; max HEX value
	MUL	R1, R1, R7 ; R1 = R1 * 3300
	UDIV R1, R1, R8 ; R1 = R1 / 4096
	POP{LR} ; pop link register
	POP{R0, R2-R12} ; push general purpose registers
	BX LR
;-------------------------------------------

;-------------------------------------------
; Read ADC_0 value and map to 0-3.3 V range
; Return in R0
;-------------------------------------------
ADC_0_Read_X
	PUSH{R1, R2-R12} ; push general purpose registers
	PUSH{LR} ; push link register
	; initialize addess registers
	LDR	R2, =ADC_0_PSSI
	LDR	R3, =ADC_0_RIS 
	LDR	R4, =ADC_0_SSFIFO3
	LDR	R0, [R2]
	ORR R0, R0, #0x0F ; set bit 3 to enable seq 3
	STR	R0, [R2]
	NOP
	NOP
	NOP
	
	LDR	R0, [R3] ; check if sample is complete
	ANDS R0, R0, #0x08
	BNE	ADC_0_Read_X
	
	LDR	R0, [R4] ; load reading in R0
	MOV R7, #3300 ; max voltage
	MOV	R8, #4096 ; max HEX value
	MUL	R0, R0, R7 ; R0 = R0 * 3300
	UDIV R0, R0, R8 ; R0 = R0 / 4096
	POP{LR} ; pop link register
	POP{R1, R2-R12} ; push general purpose registers
	BX LR
;-------------------------------------------

;-------------------------------------------
; Find the pixel coordinate corresponding to ADC reading
; Pass divisor in R3 and readings in R0 or R1
; Return R0 or R1
;-------------------------------------------
Find_Pixel_Coordinate
	PUSH{R2-R12} ; push general purpose registers
	PUSH {LR}
	MOV	R11, #1 ; R11 = Local coordinate variable
	MOV R10, R3 ; R10 = Local divisor variable
	CMP R3, #57
	BEQ Coordinate_X
Coordinate_Y
	MOV R3, R1
	B Process
Coordinate_X
	MOV R3, R0
	B Process
Process
	MUL R9, R10, R11
	CMP R3, R9
	ADDGT R11, #1
	BGT Process
	SUB R11, R11, #1
	CMP R10, #57
	BEQ Coordinate_X_Return
Coordinate_Y_Return
	MOV R1, R11
	B Return_Coordinate
Coordinate_X_Return
	MOV R0, R11
	B Return_Coordinate
Return_Coordinate
	POP {LR}
	POP{R2-R12} ; push general purpose registers
	BX LR

		
;Print
;	LDR	R5,=Volt_Text
;	BL 	OutStr
;	
;	MOV R6, R11
;	MOV R3, R11
;	LDR	R5, = TARGET 
;	BL CONVRT
;	BL OutStr
;	;MOV	R11, #1
;	;MOV	R10, #52
;	;B Reset_Constants
;	;B ADC_1_Read ; Return from caller_Y
	
ADC_Init
	PUSH{R0-R12}
	PUSH{LR}
GPIO_Init
	; Start clocks for features to be used

	LDR	R1, =RCGCADC ; start on ADC clock
	LDR	R0, [R1]
	ORR R0, R0, #0x03 ; set bit 0:! to enable ADC_0 ADC_1 clock
	STR	R0, [R1]
	NOP	 ; Let clock stabilize
	NOP
	NOP 

	LDR	R1, =RCGCGPIO ; start on GPIO clock
	LDR	R0, [R1]
	ORR	R0, R0, #0x12 ;!!!! set bit 4 to enable port E clock and bit 1 to enable port B
	STR	R0, [R1]
	NOP ; Let clock stabilize
	NOP
	NOP 	

	; Enable alternate functions
	LDR	R1, =GPIO_PORTE_AFSEL
	LDR	R0, [R1]
	ORR R0, R0, #0x0C ; set bit 3:2 to enable alt functions on PE3, PE2
	STR	R0, [R1]
	; PCTL does not have to be configured since ADC_0 is automatically selected
	; when port pin is set to analog.

	; Disable digital on  PE3, PE2
	LDR	R1, =GPIO_PORTE_DEN
	LDR	R0, [R1]
	BIC R0, R0, #0x0C ; clear bit 3:2 to disable digital on PE2
	STR	R0, [R1]

	; Eanable analog on PE3
	LDR	R1, =GPIO_PORTE_AMSEL
	LDR	R0, [R1]
	ORR R0, R0, #0x0C ; set bit 3:2 to enable analog on PE3, PE2
	STR	R0, [R1]

ADC_0_Init
	; Disable sequencer while ADC setup
	LDR	R1, =ADC_0_ACTSS
	LDR	R0, [R1]
	BIC R0, R0, #0x08 ; clear bit 3 to disable seq 3
	STR	R0, [R1]	

	; Disable interrupts
	LDR	R1, =ADC_0_IM
	LDR	R0, [R1]
	BIC R0, R0, #0x08 ; clear bit 3 to not use interrupts
	STR	R0, [R1] ; 

	; Select trigger source
	LDR	R1, =ADC_0_EMUX
	LDR	R0, [R1]
	BIC R0, R0, #0xF000 ; clear bits 15:12 to select software
	STR	R0, [R1] ; trigger

	; Config sample sequence			
	LDR	R1, =ADC_0_SSCTL0
	LDR	R0, [R1]
	BIC R0, R0, #0x0006 ; set bits 2:1 (IE0, END0)
	STR	R0, [R1]	

	; Set sample rate
	LDR	R1, =ADC_0_PC
	LDR	R0, [R1]
	ORR R0, R0, #0x01 ; set bits 3:0 to 0x01 for 125kHz
	STR	R0, [R1]	

	; Done with setup, enable sequencer
	LDR	R1, =ADC_0_ACTSS
	LDR	R0, [R1]
	ORR R0, R0, #0x08 ; set bit 3 to enable seq 3
	STR	R0, [R1]
	
ADC_1_Init
	; Disable sequencer while ADC setup
	LDR	R1, =ADC_1_ACTSS
	LDR	R0, [R1]
	BIC R0, R0, #0x08 ; clear bit 3 to disable seq 3
	STR	R0, [R1]	

	; Disable interrupts
	LDR	R1, =ADC_1_IM
	LDR	R0, [R1]
	BIC R0, R0, #0x08 ; clear bit 3 to not use interrupts
	STR	R0, [R1] ; 

	; Select trigger source
	LDR	R1, =ADC_1_EMUX
	LDR	R0, [R1]
	BIC R0, R0, #0xF000 ; clear bits 15:12 to select software
	STR	R0, [R1] ; trigger
	
	LDR R1, =ADC_1_SSMUX3
	LDR R0, [R1]
	ORR R0, R0, #0x1 ; Select PE2
	STR R0, [R1]

	; Config sample sequence			
	LDR	R1, =ADC_1_SSCTL0
	LDR	R0, [R1]
	BIC R0, R0, #0x0006 ; set bits 2:1 (IE0, END0)
	STR	R0, [R1]	

	; Set sample rate
	LDR	R1, =ADC_1_PC
	LDR	R0, [R1]
	ORR R0, R0, #0x01 ; set bits 3:0 to 0x01 for 125kHz
	STR	R0, [R1]	

	; Done with setup, enable sequencer
	LDR	R1, =ADC_1_ACTSS
	LDR	R0, [R1]
	ORR R0, R0, #0x08 ; set bit 3 to enable seq 3
	STR	R0, [R1]

	POP{LR}
	POP{R0-R12}
	BX	LR ; Return from caller
	
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END