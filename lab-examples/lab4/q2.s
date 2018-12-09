;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
; Timer Gate Control and Timer Registers
; Timer Gate Control and Timer Registers

SYSCTL_RCGCTIMER EQU 0x400FE604 ; Timer Clock Gating
TIMER0_CFG EQU 0x40032000 ; Configuration Register
TIMER0_TAMR EQU 0x40032004 ; Mode Register
TIMER0_CTL EQU 0x4003200C ; Control Register
TIMER0_RIS EQU 0x4003201C ; Raw interrupt Status
TIMER0_ICR EQU 0x40032024 ; Interrupt Clear Register
TIMER0_TAILR EQU 0x40032028 ; Interval Load Register
TIMER0_TAMATCHR EQU 0x40032030 ; Match Register
TIMER0_TAPR EQU 0x40032038 ; Prescaling Divider
TIMER0_TAR EQU 0x40032048 ; Counter Register
	
;GPIO Gate Control and GPIO Registers
SYSCTL_RCGCGPIO EQU 0x400FE608
;Port B base 0x40005000
GPIO_PORTB_DIR EQU 0x40005400 ; Port Direction
GPIO_PORTB_AFSEL EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN EQU 0x4000551C ; Digital Enable
GPIO_PORTB_AMSEL EQU 0x40005528 ; Analog enable
GPIO_PORTB_PCTL EQU 0x4000552C ; Alternate Functions
	
TARGET EQU 0x20001000	
	
	
;LABEL DIRECTIVE VALUE COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
FREQ     	DCB     	"Frequency(Hz): "
			DCB			0x0D
			DCB			0x04
PWIDTH     	DCB     	"PulseWidth(msec): "
			DCB			0x0D
			DCB			0x04
DCYCLE     	DCB     	"DutyCycle(%): "
			DCB			0x0D
			DCB			0x04

;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
		AREA 		main, READONLY, CODE
		THUMB
		EXTERN		CONVRT
		EXTERN		PULSE_INIT
		EXTERN		OutStr	; Reference external subroutine	
		EXTERN		InChar	; Reference external subroutine	
		EXPORT 		__main
		ENTRY
			
__main 	
	BL setup_port_b
	BL setup_timer_0
	BL PULSE_INIT
	CPSIE	I; DISABLE Interrupts
	MOV R3, #0 ;result keeper
	
	MOV R6, #0 ;edge keeper
	MOV R7, #0 ;edge keeper
	MOV R8, #0 ;edge keeper
	
	MOV R9, #0 ; counter
	MOV32 R10, #0x3B9ACA00 ; 1e9

	; Await edge capture event
loop LDR R1, =TIMER0_RIS
	LDR R2, [R1]
	ANDS R2, #0X4 ; isolate CAERIS bit
	BEQ loop ; if no capture, then loop
	LDR R1, = TIMER0_ICR ; clear CAERIS
	LDR R0, [R1]
	ORR R0, R0, #0x04
	STR R0, [R1]
	LDR R1, =TIMER0_TAR ; address of timer register
	
	CMP R9, #1
	BEQ edge_2
	BHI edge_3
	
edge_1	
	LDR R6, [R1] ; Get timer register value
	ADD R9, #1
	B isEnoughData
	
edge_2
	LDR R7, [R1] ; Get timer register value
	ADD R9, #1
	B isEnoughData
	
edge_3
	LDR R8, [R1] ; Get timer register value
	ADD R9, #1
	B isEnoughData
	
isEnoughData
	CMP R9, #3
	BEQ checkValidity
	B loop
	
checkValidity
	MOV R9, #0 ; reset counter
	CMP R6, R7
	BLE loop
	CMP R7, R8
	BLE loop
	B printData
	
printData
	
	SUB R3, R6, R8
	MOV R4, #63
	MUL R3, R3, R4 
	UDIV R3, R10, R3
	LDR	R5,=FREQ
	BL OutStr	    
	LDR	R5, = TARGET 
	BL	CONVRT
	BL	OutStr
	
	SUB R3, R6, R7
	SUB R4, R7, R8
	
	CMP R3, R4
	BLE lowEdgeFirst
	
posEdgeFirst	
	SUB R3, R6, R7
	MOV R4, #63
	MUL R3, R3, R4
	LDR	R5,=PWIDTH
	BL OutStr
	LDR	R5, = TARGET 
	BL	CONVRT
	BL	OutStr
	;R3 HAS PULSE WIDTHH
	
	SUB R3, R6, R7
	SUB R4, R7, R8
	ADD R4, R3, R4
	MOV R0, #100
	MUL R3, R0
	UDIV R3, R3, R4
	LDR	R5,=DCYCLE
	BL OutStr
	LDR	R5, = TARGET 
	BL	CONVRT
	BL	OutStr
	; R3 HAS DUTY CYCLE
	
	B loop
	
lowEdgeFirst	
	SUB R3, R7, R8
	MOV R4, #63
	MUL R3, R3, R4
	LDR	R5,=PWIDTH
	BL OutStr
	LDR	R5, = TARGET 
	BL	CONVRT
	BL	OutStr
	;R3 HAS PULSE WIDTHH
	
	SUB R3, R7, R8
	SUB R4, R6, R7
	ADD R4, R3, R4
	MOV R0, #100
	MUL R3, R0
	UDIV R3, R3, R4
	LDR	R5,=DCYCLE
	BL OutStr
	LDR	R5, = TARGET 
	BL	CONVRT
	BL	OutStr
	; R3 HAS DUTY CYCLE
	
	B loop
	

setup_port_b

	LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
	LDR R0, [R1]
	ORR R0, R0, #0x02 ; set bit 5 for port B
	STR R0, [R1]
	NOP ; allow clock to settle
	NOP
	NOP
	; Setup Port B for signal input
	; set direction of PB6
	LDR R1, =GPIO_PORTB_DIR
	LDR R0, [R1]
	BIC R0, R0, #2_00000001 ; clear bit 1 for input
	STR R0, [R1]
	; enable alternate function
	LDR R1, =GPIO_PORTB_AFSEL
	LDR R0, [R1]
	ORR R0, R0, # 2_00000001 ; set bit6 for alternate fuction on PB6
	STR R0, [R1]
	; set alternate function to T0CCP0 (7)
	LDR R1, =GPIO_PORTB_PCTL
	LDR R0, [R1]
	ORR R0, R0, #0x00000007 ; set bits 3:0 of PCTL to 7
	STR R0, [R1] ; to enable T0CCP0 on PB0
	; disable analog
	LDR R1, =GPIO_PORTB_AMSEL
	MOV R0, #0 ; clear AMSEL to diable analog
	STR R0, [R1] 
	; enable digital inputs
	LDR R1, =GPIO_PORTB_DEN
	LDR R0, [R1]
	ORR R0, #0x01
	STR R0, [R1]
	BX LR
	
setup_timer_0
	; Start Timer 0 clock
	LDR R1, =SYSCTL_RCGCTIMER
	LDR R2, [R1] ; Start timer 0
	ORR R2, R2, #0x04 ; Timer module = bit position (0)
	STR R2, [R1]
	NOP
	NOP
	NOP ; allow clock to settle
	; disable timer during setup
	LDR R1, =TIMER0_CTL 
	LDR R2, [R1]
	BIC R2, R2, #0x01 ; clear bit 0 to disable Timer 0
	STR R2, [R1]
	; set to 16bit Timer Mode
	LDR R1, =TIMER0_CFG
	MOV R2, #0x04 ; set bits 2:0 to 0x04 for 16bit timer
	STR R2, [R1]
	; set for edge time and capture mode
	LDR R1, =TIMER0_TAMR
	MOV R2, #0x07 ; set bit2 to 0x01 for Edge Time Mode,
	STR R2, [R1] ; set bits 1:0 to 0x03 for Capture Mode
	;; set edge detection to both
	LDR R1, =TIMER0_CTL
	LDR R2, [R1]
	ORR R2, R2, #0x0C ; set bits 3:2 to 0x03
	STR R2, [R1]
	; set start value
	LDR R1, =TIMER0_TAILR ; counter counts down,
	MOV R0, #0xFFFFFFFF ; so start counter at max value
	STR R0, [R1]
	; Enable timer
	LDR R1, =TIMER0_CTL ;
	LDR R2, [R1] ;
	ORR R2, R2, #0x03 ; set bit 0 to enable
	STR R2, [R1] 
	BX LR

	 
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            END
