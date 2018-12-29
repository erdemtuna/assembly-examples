;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
; ADC Registers
;RCGCADC				EQU	0x400FE638	; ADC clock register
;ADC_0_ACTSS			EQU 0x40038000	; Sample sequencer (ADC_0 base address)
;ADC_0_RIS			EQU 0x40038004	; Interrupt status
;ADC_0_IM				EQU 0x40038008	; Interrupt select
;ADC_0_EMUX			EQU 0x40038014	; Trigger select
;ADC_0_PSSI			EQU 0x40038028	; Initiate sample
;ADC_0_SSMUX0			EQU 0x40038040	; Input channel select
;ADC_0_SSCTL0			EQU 0x40038044	; Sample sequence control
;ADC_0_SSFIFO3		EQU 0x400380A8	; Channel 3 results
;ADC_0_PC				EQU 0x40038FC4	; Sample rate
;	
;; GPIO Registers 
;RCGCGPIO		  	EQU 0x400FE608	; GPIO clock register
;; PORT E base address = 0x40024000
;GPIO_PORTE_DEN			EQU 0x4002451C	; Digital Enable
;GPIO_PORTE_PCTL		  	EQU 0x4002452C	; Alternate function select
;GPIO_PORTE_AFSEL		 	EQU 0x40024420	; Enable Alt functions
;GPIO_PORTE_AMSEL		 	EQU 0x40024528	; Enable analog
	
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
		EXTERN		Start
		EXTERN		CONVRT
		EXTERN		OutStr	; Reference external subroutine	
		EXTERN		InChar	; Reference external subroutine	
		EXPORT 		__main
		ENTRY
			
__main 	
	BL Start
	
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
