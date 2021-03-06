;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
; ADC Registers
RCGCADC				EQU	0x400FE638	; ADC clock register
ADC_0_ACTSS			EQU 0x40038000	; Sample sequencer (ADC_0 base address)
ADC_0_RIS			EQU 0x40038004	; Interrupt status
ADC_0_IM				EQU 0x40038008	; Interrupt select
ADC_0_EMUX			EQU 0x40038014	; Trigger select
ADC_0_PSSI			EQU 0x40038028	; Initiate sample
ADC_0_SSMUX0			EQU 0x40038040	; Input channel select
ADC_0_SSCTL0			EQU 0x40038044	; Sample sequence control
ADC_0_SSFIFO3		EQU 0x400380A8	; Channel 3 results
ADC_0_PC				EQU 0x40038FC4	; Sample rate
	
; GPIO Registers 
RCGCGPIO		  	EQU 0x400FE608	; GPIO clock register
; PORT E base address = 0x40024000
GPIO_PORTE_DEN			EQU 0x4002451C	; Digital Enable
GPIO_PORTE_PCTL		  	EQU 0x4002452C	; Alternate function select
GPIO_PORTE_AFSEL		 	EQU 0x40024420	; Enable Alt functions
GPIO_PORTE_AMSEL		 	EQU 0x40024528	; Enable analog
	
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
		EXTERN		PULSE_INIT
		EXTERN		CONVRT
		EXTERN		OutStr	; Reference external subroutine	
		EXTERN		InChar	; Reference external subroutine	
		EXPORT 		__main
		ENTRY
			
__main 	
	BL ADC_Init
	; PD 3,2,1,0 for A/D (AIN4,5,6,7)
	; PB 0,1,2,3 for display
ADC_Sample_Constants
	MOV R7, #330
	MOV	R8, #4096
	MOV	R10, #10
	LDR	R6, = 0x0000FFFF
		
ADC_Sample_start
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
	BNE	ADC_Sample_start
	
	LDR	R3, [R4] ; load results
	MUL	R3, R3, R7 ; value = value * 330
	UDIV R3, R3, R8 ; value = value / 4096
	SUB	R9, R3, R6
	CMP	R9,#20
	BGT	Print
	SUB	R9, R6, R3
	CMP	R9,#20
	BGT	Print
	B	ADC_Sample_start
		
Print
	MOV	R6, R3 ; save the last value
	MUL	R3,R3,R10
	LDR	R5,=Volt_Text
	BL 	OutStr
	LDR	R5, = TARGET 
	BL CONVRT
	BL OutStr
	B ADC_Sample_start ; Return from caller
	
ADC_Init

	; Start clocks for features to be used

	LDR	R1, =RCGCADC ; start on ADC clock
	LDR	R0, [R1]
	ORR R0, R0, #0x01 ; set bit 0 to enable ADC_0 clock
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
	ORR R0, R0, #0x08 ; set bit 3 to enable alt functions on PE3
	STR	R0, [R1]
	; PCTL does not have to be configured since ADC_0 is automatically selected
	; when port pin is set to analog.

	; Disable digital on  PE3
	LDR	R1, =GPIO_PORTE_DEN
	LDR	R0, [R1]
	BIC R0, R0, #0x08 ; clear bit 3 to disable digital on PE3
	STR	R0, [R1]

	; Eanable analog on PE3
	LDR	R1, =GPIO_PORTE_AMSEL
	LDR	R0, [R1]
	ORR R0, R0, #0x08 ; set bit 3 to enable analog on PE3
	STR	R0, [R1]

; Setup ADC
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

	BX	LR ; Return from caller
	
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
