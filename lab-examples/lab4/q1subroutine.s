; Use of Timer interrupts to create square wave
; Signal on PortF Pins 1,2,3 (LEDs)
; Bill Eads 10-27-2018
;16/32 bit TIMER0 Timer Registers
TIMER0_CFG		EQU 0x40030000
TIMER0_TAMR		EQU 0x40030004
TIMER0_CTL		EQU 0x4003000C
TIMER0_IMR		EQU 0x40030018
TIMER0_RIS		EQU 0x4003001C
TIMER0_ICR		EQU 0x40030024
TIMER0_TAILR	EQU 0x40030028
TIMER0_TAMATCHR	EQU 0x40030030
TIMER0_TAPR		EQU 0x40030038
TIMER0_TAPMR	EQU 0x40030040
SYSCTL_RCGCTIMER EQU 0x400FE604		; 16/32 Gate Control
; Use built-in LED on Port F
GPIO_PORTF_DATA_R  	EQU 	0x400253FC
GPIO_PORTF_DIR_R   	EQU 	0x40025400
GPIO_PORTF_AFSEL_R 	EQU 	0x40025420
GPIO_PORTF_PUR_R   	EQU 	0x40025510
GPIO_PORTF_DEN_R   	EQU 	0x4002551C
GPIO_PORTF_AMSEL_R 	EQU 	0x40025528
GPIO_PORTF_PCTL_R  	EQU 	0x4002552C
SYSCTL_RCGCGPIO_R  	EQU 	0x400FE608
PCTLCNST           	EQU 	0x0000FFF0
;Nested Vector Interrupt Controller registers
NVIC_EN0		EQU 0xE000E100  ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4		EQU 0xE000E410  ; IRQ 16 to 19 Priority Register

		EXPORT	Timer0A_Handler	   
		EXPORT	__main
;***************************************************************	
; Program Area
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT	
		AREA    |.text|, READONLY, CODE
__main		
		BL	Timer0A_Init	; Initialize Timer0A for Interrupts
		BL	_Init_PortF		; Initialize PortF LEDs as outputs		
		CPSIE	I			; Enable Interrupts
wait_int
		WFI					; Wait for next interrupt

		B wait_int			; Continue forever                   
		
done	B	done			; program finished

Timer0A_Init	  ; Initialize Timer0A for interrupt use
		LDR R1,=SYSCTL_RCGCTIMER ;; Start Timer clock
		LDR R2,[R1]                    
		ORR R2,R2, #0x01	; start timer 0     
		STR R2,[R1]                  
		NOP
		NOP  
		NOP					; allow clock to settle
		LDR R1, =TIMER0_CTL	; disable timer during setup
		LDR R2, [R1]                    
		BIC R2, R2, #0x01	; clear bit0 to disable TimerA
		STR R2, [R1]                    
		LDR R1, =TIMER0_CFG		       
		MOV R2, #0x04		; 16 bit mode
		STR R2, [R1]                  
		LDR R1, =TIMER0_TAMR		 
		MOV R2, #0x02		; periodic, count down
		STR R2, [R1]                  
		LDR R1, =TIMER0_TAPR ; divide clock by 250
		MOV R2, #249			; 62.5nsec*250=15.625usec period
		STR R2, [R1]                   
		LDR R1, =TIMER0_TAILR ; initialize match clock
		MOV R2, #64000		; 15.625us*64,000=1s interrupt
		STR R2, [R1]
		LDR R1, =TIMER0_IMR           
		MOV R2, #0x01		; enable Time Out Interrupt 
		STR R2, [R1]
; Configure interrupt priorities		
	; Timer0A is interrupt #19.
	; Interrupts 16-19 are handled by NVIC register PRI4.
	; Interrupt 19 is controlled by bits 31:29 of PRI4.
	
    ; set NVIC interrupt 19 to priority 2
		LDR 	R1, =NVIC_PRI4           
		LDR 	R2, [R1]                 
		AND 	R2, R2, #0x00FFFFFF	; clear interrupt 19 priority
		ORR 	R2, R2, #0x40000000 ; set interrupt 19 priority to 2
		STR 	R2, [R1]        

	; NVIC has to be enabled
	; Interrupts 0-31 are handled by NVIC register EN0
	; Interrupt 19 is controlled by bit 19
	
    ; enable interrupt 19 in NVIC
		LDR 	R1, =NVIC_EN0	          
		MOVT 	R2, #0x08		; set bit 19 to enable interrupt 19
		STR		R2, [R1]                   
; Interrupt enable complete
		LDR		R1, =TIMER0_CTL	; enable timer 
		LDR 	R2, [R1]                    
		ORR 	R2, R2, #0x03	; set bit0 to enable
		STR 	R2, [R1]		; and bit1 to stall on debug
		BX		LR				; return from Timer initialization

Timer0A_Handler		;Timer 0A ISR
		LDR R1, =TIMER0_ICR		; clear interrupt flag
		MOV R2, #0x01			
		STR R2, [R1]             

		LDR R1, =GPIO_PORTF_DATA_R	; Toggle PortF Data
		LDR R0,[R1]
		EOR R0,R0,#0x0E
		STR R0, [R1]
		
		LDR R1, =TIMER0_TAILR ; initialize match clock
		LDR R2 , [R1]
		EOR R2, R2, #0x8700
		STR R2, [R1]
		
		BX	LR					; Return from ISR
		ALIGN
;------------_Init_PortF------------
; Make Port F 1-3 outputs, enable digital I/O, ensure alt. functions off.
; Input: none  Output: none   Modifies: R0, R1
_Init_PortF
    LDR 	R1, =SYSCTL_RCGCGPIO_R      ; load R1 with RCGCGPIO address
    LDR 	R0, [R1]                 	; load R0 with value in RCGCGPIO
    ORR 	R0, #0x20 					; set bit 5 to turn on clock
    STR 	R0, [R1]                  	; store value in RCGCGPIO
    NOP
    NOP
    NOP      	                       ; allow time for clock to finish
    LDR 	R1, =GPIO_PORTF_AMSEL_R     ; load R1 with AMSEL address
    LDR 	R0, [R1]                    ; load R0 with value in AMSEL
    BIC 	R0, #0x0E                   ; clear bits PF1-3 to disable analog
    STR 	R0, [R1]                    ; store value in AMSEL
    LDR 	R1, =GPIO_PORTF_PCTL_R      ; load R1 with PCTL address
    LDR 	R0, [R1]                    ; load R0 with value in PCTL
	LDR		R3, =PCTLCNST				; load R3 with 0xFFF0
    BIC 	R0, R3		             	; clear PF1-3 bits for regular function
    STR 	R0, [R1]                  	; store in PCTL
    LDR 	R1, =GPIO_PORTF_DIR_R       ; load R1 with DIR address
    LDR 	R0, [R1]                    ; load R0 value in DIR
    ORR 	R0,#0x0E                    ; set bits PF1-3 for output
    STR 	R0, [R1]                    ; store in DIR
    LDR 	R1, =GPIO_PORTF_AFSEL_R     ; load R1 with AFSEL address
    LDR 	R0, [R1]                    ; load R0 value in AFSEL
    BIC 	R0, #0x0E                   ; clear bits PF1-3 for regular function
    STR 	R0, [R1]                    ; store in AFSEL
    LDR 	R1, =GPIO_PORTF_DEN_R       ; load R1 with DEN address
    LDR 	R0, [R1]                    ; load R0 value in DEN
    ORR 	R0,#0x0E                    ; set bits 1-3 to enable digital I/O
    STR 	R0,[R1]    				; store in DEN
	LDR 	R1,=GPIO_PORTF_DATA_R			; load R1 with PortF data address
	MOV 	R0,#0x00
    STR 	R0,[R1] 						; Turn Off LEDs
	BX  	LR							; Return from init subroutine	
    ALIGN                           	; make sure the end of this section is aligned	
		END
