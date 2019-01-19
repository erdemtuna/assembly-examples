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
DECREASE EQU 0xF4240 ; 1e6 useconds
MAX_TIMER_A EQU 0x7A120 ; 5e5 useconds
Coordinate_Timer_X EQU 74
;---------------------------------------------------
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
		
MSG_20s DCB "20",0x04
MSG_19s DCB "19",0x04
MSG_18s DCB "18",0x04
MSG_17s DCB "17",0x04
MSG_16s DCB "16",0x04
MSG_15s DCB "15",0x04
MSG_14s DCB "14",0x04
MSG_13s DCB "13",0x04
MSG_12s DCB "12",0x04
MSG_11s DCB "11",0x04
MSG_10s DCB "10",0x04
MSG_9s DCB "09",0x04
MSG_8s DCB "08",0x04
MSG_7s DCB "07",0x04
MSG_6s DCB "06",0x04
MSG_5s DCB "05",0x04
MSG_4s DCB "04",0x04
MSG_3s DCB "03",0x04
MSG_2s DCB "02",0x04
MSG_1s DCB "01",0x04
MSG_0s DCB "00",0x04
MSG_ClearTimer DCB "  ",0x04

	AREA 	routines, CODE, READONLY
	THUMB

	EXPORT	WideTimer0A_Handler
	EXPORT	WideTimer0B_Handler
	EXPORT	Timers_Init
	EXPORT	Enable_Timers

	;----------------------------------
	; Screen functions
	;----------------------------------
	EXTERN	Nokia_Init			
	EXTERN	OutImgNokia
	EXTERN	SetCoordinate
	EXTERN	TxByte
	EXTERN	OutStrNokia
	EXTERN	ClearNokia
		
	EXTERN Set_Coordinates_Mine
					
;-------------------------------------------
; Clears all screen.
; Outputs to timer location of the screen.
; "20".
;-------------------------------------------					
WideTimer0A_Handler	PROC
	PUSH{R5-R11,LR} ; R0,R1,R2,R3,R12 are pushed to stack
					; when interrupt occurs
	LDR R1, =TIMER0_ICR	
	MOV R0, #0xF
	STR R0, [R1]
	BL	OutStrNokia	
	BL	ClearNokia ; clear the screen
	LDR	R5,=gameplayBorder 
	BL	OutImgNokia ; output the border
	LDR R0, = Coordinate_Timer_X
	MOV	R1, #0
	BL	SetCoordinate
	LDR	R5,=MSG_20s
	BL	OutStrNokia	
	ADD R4, R4, #1
	POP{R5-R11,LR}
	BX LR
	ENDP

;-------------------------------------------
; Calculates the remaining timer
; Outputs it to timer location of the screen.
;-------------------------------------------
WideTimer0B_Handler PROC
	PUSH{R0-R12,LR} 
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
	
	MOV32 R2, #1000000
	LDR R1, = TIMER0_TAR_B
	LDR R0, [R1]
	UDIV R0, R0 ,R2 ; R0 is the remaining time in seconds
	ADD R0, R0, #1
R19s
	CMP R0, #19
	BNE R18s
	LDR R4, = MSG_19s ; save the string in R4
	B Output_Remaning_Time
R18s 
	CMP R0, #18
	BNE R17s
	LDR R4, = MSG_18s ; save the string in R4
	B Output_Remaning_Time
R17s 
	CMP R0, #17
	BNE R16s
	LDR R4, = MSG_17s ; save the string in R4
	B Output_Remaning_Time
R16s 
	CMP R0, #16
	BNE R15s
	LDR R4, = MSG_16s ; save the string in R4
	B Output_Remaning_Time
R15s 
	CMP R0, #15
	BNE R14s
	LDR R4, = MSG_15s ; save the string in R4
	B Output_Remaning_Time
R14s 
	CMP R0, #14
	BNE R13s
	LDR R4, = MSG_14s ; save the string in R4
	B Output_Remaning_Time
R13s 
	CMP R0, #13
	BNE R12s
	LDR R4, = MSG_13s ; save the string in R4
	B Output_Remaning_Time
R12s 
	CMP R0, #12
	BNE R11s
	LDR R4, = MSG_12s ; save the string in R4
	B Output_Remaning_Time
R11s 
	CMP R0, #11
	BNE R10s
	LDR R4, = MSG_11s ; save the string in R4
	B Output_Remaning_Time
R10s 
	CMP R0, #10
	BNE R9s
	LDR R4, = MSG_10s ; save the string in R4
	B Output_Remaning_Time
R9s
	CMP R0, #9
	BNE R8s
	LDR R4, = MSG_9s ; save the string in R4
	B Output_Remaning_Time
R8s 
	CMP R0, #8
	BNE R7s
	LDR R4, = MSG_8s ; save the string in R4
	B Output_Remaning_Time
R7s 
	CMP R0, #7
	BNE R6s
	LDR R4, = MSG_7s ; save the string in R4
	B Output_Remaning_Time
R6s 
	CMP R0, #6
	BNE R5s
	LDR R4, = MSG_6s ; save the string in R4
	B Output_Remaning_Time
R5s 
	CMP R0, #5
	BNE R4s
	LDR R4, = MSG_5s ; save the string in R4
	B Output_Remaning_Time
R4s 
	CMP R0, #4
	BNE R3s
	LDR R4, = MSG_4s ; save the string in R4
	B Output_Remaning_Time
R3s 
	CMP R0, #3
	BNE R2s
	LDR R4, = MSG_3s ; save the string in R4
	B Output_Remaning_Time
R2s 
	CMP R0, #2
	BNE R1s
	LDR R4, = MSG_2s ; save the string in R4
	B Output_Remaning_Time
R1s 
	CMP R0, #1
	BNE R0s
	LDR R4, = MSG_1s ; save the string in R4
	B Output_Remaning_Time
R0s 
	LDR R4, = MSG_0s ; save the string in R4
	B Output_Remaning_Time



Output_Remaning_Time
	LDR R0, = Coordinate_Timer_X
	MOV	R1, #0
	BL	SetCoordinate
	LDR R5, = MSG_ClearTimer
	BL	OutStrNokia	
	LDR R0, = Coordinate_Timer_X
	MOV	R1, #0
	BL	SetCoordinate
	MOV R5, R4
	BL	OutStrNokia	
	POP{R0-R12,LR} 
	BX 	LR 
	ENDP

;-------------------------------------------
; Enables timers.
; TimerA of 0.5 seconds triggers TimerB of 20 seconds.
;-------------------------------------------
Enable_Timers
	PUSH{R0-R2}
	PUSH{LR}
	LDR R1, =TIMER0_CTL
	LDR R0, [R1]
	MOV R2, #0x303 ; Enable timer
	ORR R0, R0, R2 ; set bit0 to enable A and B
	STR R0, [R1] ; and bit 1 to stall on debug
	POP{LR}
	POP{R0-R2}
	BX LR

Timers_Init PROC
	PUSH{R0-R2}
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
	LDR R1, =MAX
	LDR R0, =DECREASE
	SUB R0, R1, R0
	LDR R1, =TIMER0_TAMATCHR_B
	STR R0, [R1]
	LDR R1, =TIMER0_TAILR_B ; initialize match clocks
	LDR R0, =MAX
	STR R0, [R1]
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
	LDR R0, =MAX_TIMER_A
	STR R0, [R1]
	; - - - - - - - - - -- - - - - - -
; Configure interrupt priorities
; Timer0A is interrupt #94.
; Interrupts 92-95 are handled by NVIC register PRI23.
; set NVIC interrupt 94-95 to priority 2
	LDR R1, =NVIC_PRI4
	LDR R0, [R1]
	MOV32 R2, #0x0000FFFF
	AND R0, R0, R2 ; clear interrupt
	MOV32 R2,  #0x40400000
	ORR R0, R0, R2 ; set interrupt
	STR R0, [R1]
; NVIC has to be enabled
; Interrupts 64-95 are handled by NVIC register EN2
; Interrupt 94 is controlled by bit 30-31
	LDR R1, =NVIC_EN0
	LDR R0, [R1] 
	ORR R0, R0, #0xC0000000; set bit 30-31 to enable interrupt 94-95
	STR R0, [R1]
	POP{R0-R2}
	BX LR ; return
	ENDP
	END