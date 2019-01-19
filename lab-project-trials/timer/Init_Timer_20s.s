; Pulse.s
; Routine for creating a pulse train using interrupts
; This uses Channel 0, and a 1MHz Timer Clock (_TAPR = 15 )
; Uses 32/64-bit Timer 0 to create pulse train on PF2

;Nested Vector Interrupt Controller registers
;NVIC_EN0_INT94		EQU 0x00080000 ; Interrupt 94 enable
NVIC_EN0			EQU 0xE000E108 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E41C ; IRQ 92 to 95 Priority Register
	
; 32/64 Timer Registers
TIMER0_CFG			EQU 0x40036000

TIMER0_TAMR			EQU 0x40036004
TIMER0_TAMR_B		EQU 0x40036008

TIMER0_CTL			EQU 0x4003600C
TIMER0_IMR			EQU 0x40036018
TIMER0_RIS			EQU 0x4003601C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40036024 ; Timer Interrupt Clear

TIMER0_TAILR		EQU 0x40036028 ; Timer interval
TIMER0_TAILR_B		EQU 0x4003602C ; Timer interval

TIMER0_TAPR			EQU 0x40036038
TIMER0_TAPR_B		EQU 0x4003603C

TIMER0_TAR_B		EQU	0x4003604C ; Timer register
TIMER0_TAV			EQU	0x40036050 ; Timer register

TIMER0_TAMATCHR		EQU	0x40036030 ; Timer register
TIMER0_TAMATCHR_B	EQU	0x40036034 ; Timer register

TIMER0_TAPMR		EQU	0x40036040 ; Timer register
TIMER0_TAPMR_B		EQU	0x40036044 ; Timer register
	
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
MAX	EQU	0x1312D00 ; 20e6 useconds
DECREASE EQU 0xF4240
MAX_TIMERB EQU 0x7A120
;---------------------------------------------------
					
	AREA 	routines, CODE, READONLY
	THUMB
	EXPORT	WideTimer0A_Handler
	EXPORT	WideTimer0B_Handler
	EXPORT	Init_Timer_20s
					
;---------------------------------------------------					
WideTimer0A_Handler	PROC
	PUSH{LR}
	LDR R1, =TIMER0_ICR	
	MOV R0, #0xF
	STR R0, [R1]
End_Of_Mine_Placement

	POP{LR}
	BX 	LR 
	ENDP
;---------------------------------------------------
WideTimer0B_Handler PROC
	PUSH{LR}
	; clear interrupt flag
	LDR R1, =TIMER0_ICR	
	MOV R2, #0x911
	MOV R0, R2 ; clear the interrupts that are
				  ; due to MATCH and TIME-OUT
	STR R0, [R1]
	
	LDR R1, =TIMER0_TAR_B
	LDR R0, [R1]
	LDR R1, = MAX
	CMP R0, R1 ; check if the timer is reset
			   ; meaning 20s have passed
	BEQ End_Of_Mine_Placement
	
	
	LDR R2, =TIMER0_TAR_B
	LDR R1, [R2]
	LDR R0, =DECREASE
	SUB R0, R1, R0 ; set the next MATCH interrupt
	LDR R1, =TIMER0_TAMATCHR_B
	STR R0, [R1] ; store it

	; Toggle PortF Data, just for demonstration
	LDR R1, = GPIO_PORTF_DATA	
	LDR R0,[R1]
	EOR R0,R0,#0x04
	STR R0, [R1]

	; change the interrupt interval
	;LDR R1, =TIMER0_TAILR 
	;LDR R0 , [R1]
	;EOR R0, R0, #0x0A  ; 30usec <--> 20usec
	;STR R0, [R1]
	POP{LR}
	BX 	LR 
	ENDP

Init_Timer_20s PROC
	PUSH{R0-R1}
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
	LDR R0, [R1]
	ORR R0, R0, #0x01
	STR R0, [R1]
	NOP ; allow clock to settle
	NOP
	NOP
	LDR R1, =TIMER0_CTL ; disable timer during setup LDR R2, [R1]
	LDR R0, [R1]
	MOV R2, #0x101 
	BIC R0, R0, R2; clear A and B
	STR R0, [R1]
	LDR R1, =TIMER0_CFG ; set 32 bit mode
	MOV R0, #0x04
	STR R0, [R1]
	LDR R1, =TIMER0_TAMR_B
	MOV R0, #0x61 ; set to one shot, count down
	STR R0, [R1]

	;//////////////////////////////
	LDR R1, =MAX
	LDR R0, =DECREASE
	SUB R0, R1, R0
	LDR R1, =TIMER0_TAMATCHR_B
	STR R0, [R1]
	;//////////////////////////////

	;//////////////////////////////
	LDR R1, =TIMER0_TAILR_B ; initialize match clocks
	LDR R0, =MAX
	STR R0, [R1]
	;//////////////////////////////

	LDR R1, =TIMER0_TAPR_B
	MOV R0, #15 ; divide clock by 16 to
	STR R0, [R1] ; get 1us clocks
;	LDR R1, =TIMER0_TAPMR_B
;	MOV R0, #15 ; divide clock by 16 to
;	STR R0, [R1] ; get 1us clocks
	LDR R1, =TIMER0_IMR ; enable timeout interrupt
	MOV R0, #0x901 ; A and B interrupt enable
	STR R0, [R1]
	; - - - - - - - - - -- - - - - - -
	LDR R1, =TIMER0_TAMR
	MOV R0, #0x01 ; set to one shot, count down, wait trigger enabled
	STR R0, [R1]
	LDR R1, =TIMER0_TAPR
	MOV R0, #15 ; divide clock by 16 to
	STR R0, [R1] ; get 1us clocks
	LDR R1, =TIMER0_TAILR ; initialize match clocks
	LDR R0, =MAX_TIMERB
	STR R0, [R1]

	; - - - - - - - - - -- - - - - - -
; Configure interrupt priorities
; Timer0A is interrupt #94.
; Interrupts 92-95 are handled by NVIC register PRI23.
; set NVIC interrupt 94 to priority 2
	LDR R1, =NVIC_PRI4
	LDR R0, [R1]
	MOV32 R2, #0x0000FFFF
	AND R0, R0, R2 ; clear interrupt 19 priority
	MOV32 R2,  #0x40400000
	ORR R0, R0, R2 ; set interrupt 19 priority to 2
	STR R0, [R1]
; NVIC has to be enabled
; Interrupts 64-95 are handled by NVIC register EN2
; Interrupt 94 is controlled by bit 30
	LDR R1, =NVIC_EN0
	LDR R0, [R1] 
	ORR R0, R0, #0xC0000000; set bit 30 to enable interrupt 94-95
	STR R0, [R1]
; Enable timer
	LDR R1, =TIMER0_CTL
	LDR R0, [R1]
	MOV R2, #0x303
	ORR R0, R0, R2; set bit0 to enable A and B
	STR R0, [R1] ; and bit 1 to stall on debug
	POP{R0-R1}
	BX LR ; return
	ENDP
	END