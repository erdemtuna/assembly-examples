; Pulse.s
; Routine for creating a pulse train using interrupts
; This uses Channel 0, and a 1MHz Timer Clock (_TAPR = 15 )
; Uses 32/64-bit Timer 0 to create pulse train on PF2

;Nested Vector Interrupt Controller registers
;NVIC_EN0_INT94		EQU 0x00080000 ; Interrupt 94 enable
NVIC_EN0			EQU 0xE000E108 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E45C ; IRQ 92 to 95 Priority Register
	
; 32/64 Timer Registers
TIMER0_CFG			EQU 0x40036000
TIMER0_TAMR			EQU 0x40036004
TIMER0_CTL			EQU 0x4003600C
TIMER0_IMR			EQU 0x40036018
TIMER0_RIS			EQU 0x4003601C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40036024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40036028 ; Timer interval
TIMER0_TAPR			EQU 0x40036038
TIMER0_TAR			EQU	0x40036048 ; Timer register
	
;GPIO Registers
GPIO_PORTF_DATA		EQU 0x40025010 ; Access BIT2
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions

;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE65C ; GPTM Gate Control
								   ; 32/64-bit Timer 0

;---------------------------------------------------
LOW	EQU	0x1312D00 ; 20e6 useconds
HIGH EQU	0x1312D00
;---------------------------------------------------
					
	AREA 	routines, CODE, READONLY
	THUMB
	EXPORT	WideTimer0A_Handler
	EXPORT	Timer_20s_CD
					
;---------------------------------------------------					
WideTimer0A_Handler	PROC
	; clear interrupt flag
	LDR R1, =TIMER0_ICR		
	MOV R2, #0x01			
	STR R2, [R1]             

	; Toggle PortF Data
	LDR R1, = GPIO_PORTF_DATA	
	LDR R0,[R1]
	EOR R0,R0,#0x04
	STR R0, [R1]

	; change the interrupt interval
	LDR R1, =TIMER0_TAILR 
	LDR R0 , [R1]
	EOR R0, R0, #0x0A  ; 30usec <--> 20usec
	STR R0, [R1]

	; Enable timer
	;LDR R1, =TIMER0_CTL
	;LDR R2, [R1]
	;ORR R2, R2, #0x03 ; set bit0 to enable
	;STR R2, [R1] ; and bit 1 to stall on debug

	BX 	LR 
	ENDP
;---------------------------------------------------

Timer_20s_CD PROC
	LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
	LDR R0, [R1]
	ORR R0, R0, #0x20 ; set bit 5 for port F
	STR R0, [R1]
	NOP ; allow clock to settle
	NOP
	NOP
	LDR R1, =GPIO_PORTF_DIR ; set direction of PF2
	LDR R0, [R1]
	ORR R0, R0, #0x04 ; set bit2 for output
	STR R0, [R1]
	LDR R1, =GPIO_PORTF_AFSEL ; regular port function
	LDR R0, [R1]
	BIC R0, R0, #0x04
	STR R0, [R1]
	LDR R1, =GPIO_PORTF_PCTL ; no alternate function
	LDR R0, [R1]
	BIC R0, R0, #0x00000F00
	STR R0, [R1]
	LDR R1, =GPIO_PORTF_AMSEL ; disable analog
	MOV R0, #0
	STR R0, [R1]
	LDR R1, =GPIO_PORTF_DEN ; enable port digital
	LDR R0, [R1]
	ORR R0, R0, #0x04
	STR R0, [R1]

	LDR R1, =SYSCTL_RCGCTIMER ; Start 32/64-bit Timer 0
	LDR R2, [R1]
	ORR R2, R2, #0x01
	STR R2, [R1]
	NOP ; allow clock to settle
	NOP
	NOP
	LDR R1, =TIMER0_CTL ; disable timer during setup LDR R2, [R1]
	BIC R2, R2, #0x01
	STR R2, [R1]
	LDR R1, =TIMER0_CFG ; set 32 bit mode
	MOV R2, #0x04
	STR R2, [R1]
	LDR R1, =TIMER0_TAMR
	MOV R2, #0x01 ; set to one shot, count down
	STR R2, [R1]
	LDR R1, =TIMER0_TAILR ; initialize match clocks
	LDR R2, =LOW
	STR R2, [R1]
	LDR R1, =TIMER0_TAPR
	MOV R2, #15 ; divide clock by 16 to
	STR R2, [R1] ; get 1us clocks
	LDR R1, =TIMER0_IMR ; enable timeout interrupt
	MOV R2, #0x01
	STR R2, [R1]
; Configure interrupt priorities
; Timer0A is interrupt #94.
; Interrupts 92-95 are handled by NVIC register PRI23.
; Interrupt 19 is controlled by bits 21:23 of PRI23.
; set NVIC interrupt 19 to priority 2
	LDR R1, =NVIC_PRI4
	LDR R2, [R1]
	AND R2, R2, #0xFF00FFFF ; clear interrupt 19 priority
	ORR R2, R2, #0x00400000 ; set interrupt 19 priority to 2
	STR R2, [R1]
; NVIC has to be enabled
; Interrupts 64-95 are handled by NVIC register EN2
; Interrupt 94 is controlled by bit 30
; enable interrupt 19 in NVIC
	LDR R1, =NVIC_EN0
	LDR R2, [R1] 
	ORR R2, R2, #0x40000000; set bit 30 to enable interrupt 94
	STR R2, [R1]
; Enable timer
	LDR R1, =TIMER0_CTL
	LDR R2, [R1]
	ORR R2, R2, #0x03 ; set bit0 to enable
	STR R2, [R1] ; and bit 1 to stall on debug
	BX LR ; return
	ENDP
	END