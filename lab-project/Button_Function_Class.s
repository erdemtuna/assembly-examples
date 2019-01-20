GPIO_PORTF_DATA_R  EQU 0x400253FC
GPIO_PORTF_DIR_R   EQU 0x40025400
GPIO_PORTF_AFSEL_R EQU 0x40025420
GPIO_PORTF_PUR_R   EQU 0x40025510
GPIO_PORTF_DEN_R   EQU 0x4002551C
	
GPIO_PORTF_IS_R   EQU 0x40025404
GPIO_PORTF_BE_R   EQU 0x40025408
GPIO_PORTF_IEV_R   EQU 0x4002540C
GPIO_PORTF_IM_R   EQU 0x40025410
GPIO_PORTF_ICR_R   EQU 0x4002541C
GPIO_PORTF_RIS_R   EQU 0x40025414
	
GPIO_PORTF_LOCK_R  EQU 0x40025520
GPIO_PORTF_CR_R    EQU 0x40025524
GPIO_PORTF_AMSEL_R EQU 0x40025528
GPIO_PORTF_PCTL_R  EQU 0x4002552C
GPIO_LOCK_KEY      EQU 0x4C4F434B  ; Unlocks the GPIO_CR register
SYSCTL_RCGCGPIO_R  EQU 0x400FE608

NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E41C ; IRQ 92 to 95 Priority Register
	
Memory_Battleship	EQU 0x20000700
Memory_Civilianship	EQU 0x20000734
Memory_Mine			EQU 0x20000768
Memory_ShipCount	EQU 0x2000079C
Memory_GamePhase	EQU 0x200007D0
Axis_X_Slice		EQU 56
Axis_Y_Slice		EQU 825
	
Axis_X_Offset		EQU 6
Axis_Y_Offset		EQU 1

	AREA    |.text|, CODE, READONLY, ALIGN=2
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
	
MSG_Cursor DCB "+",0x04
MSG_Battleship DCB "[",0x04
MSG_Civilianship DCB "{",0x04
MSG_Mine DCB "*",0x04
MSG_Clear_Cursor DCB " ",0x04
MSG_InitialRun DCB	"EE447            Lab Project      Burkay Unsal     Erdem Tuna",0x04
MSG_Welcome DCB	"Place the ship   after border is  visible.",0x04
MSG_WaitUser2 DCB	"Waiting for      player2 to press both buttons.",0x04
			
	EXPORT PortF_Button_Init
	EXPORT Check_Interrupt_Status
	EXPORT Clear_Interrupt_Status
	EXPORT GPIOPortF_Handler
		
	EXTERN MineShip_Coordinate_Save
	EXTERN MineShip_Output_Display
	;----------------------------------
	; ADC functions
	;----------------------------------
	EXTERN ADC_1_Read_Y
	EXTERN ADC_0_Read_X
	EXTERN Find_Pixel_Coordinate
	EXTERN ADC_Init
		
	;----------------------------------
	; Screen functions
	;----------------------------------
	EXTERN	Nokia_Init			
	EXTERN	OutImgNokia
	EXTERN	SetCoordinate
	EXTERN	TxByte
	EXTERN	OutStrNokia
	EXTERN	ClearNokia
	;----------------------------------
	; Timer functions
	;----------------------------------
	EXTERN	WideTimer0A_Handler
	EXTERN	WideTimer0B_Handler
	EXTERN	Timers_Init
	EXTERN	Enable_Timers
			
;-------------------------------------------
; Read PF4-PF0 Interrupt Status
; Return in R12
; Return Value either 0x11 or 0x10 or 0x01
;-------------------------------------------
Check_Interrupt_Status
	PUSH{R0-R11}
	PUSH{LR}
	LDR R1, = GPIO_PORTF_RIS_R
	LDR R12, [R1]
	AND R12, #0x11
	POP{LR}
	POP{R0-R11}
	BX LR
	
;-------------------------------------------
; Clear PF4-PF0 Interrupt Status
; No Return
;-------------------------------------------
Clear_Interrupt_Status
	PUSH{R0-R12}
	PUSH{LR}
	LDR R1, =GPIO_PORTF_ICR_R        ; enable commit for Port F
    MOV R0, #0xFF                   ; 1 means allow access
    STR R0, [R1]
	POP{LR}
	POP{R0-R12}
	BX LR
	
	
	
;-------------------------------------------
; Process data according to game phase indicated by R9.
; R9, game phase indicator:
	; 0 means ship deployment
	; 1 means ship deployment is done, wait handover
	; 2 means handover done, wait player2
	; 3 means mine deployment
; Can edit R7 and R9.
;-------------------------------------------
GPIOPortF_Handler PROC
	PUSH{R5-R6,R8,R10-R12,LR} ; R0,R1,R2,R3,R12 are pushed to stack
						   ; when interrupt occurs
   
	LDR R6, = Memory_GamePhase
	LDRB R9, [R6]					   
	CMP R9, #0
	BEQ ShipDeploy
	CMP R9, #1
	BEQ WaitHandover
	CMP R9, #2
	BEQ WaitPlayer2
	CMP R9, #3
	BEQ MineDeploy
	
ShipDeploy
	LDR R6, = Memory_ShipCount
	LDRB R7, [R6]
	ADD R7, R7, #1 ; increment ship count
	STRB R7, [R6]
Check_Last_Coordinates
	MOV R0, #0 ; clear x-coordinate
	MOV R1, #0 ; clear y-coordinate
	BL ADC_0_Read_X
	LDR R3, = Axis_X_Slice
	BL Find_Pixel_Coordinate ; x-coordinae
	BL ADC_1_Read_Y
	LDR R3, = Axis_Y_Slice
	BL Find_Pixel_Coordinate
	ADD R0, R0, #Axis_X_Offset ; add x axis offset
	ADD R1, R1, #Axis_Y_Offset ; add y axis offset
	
	BL Check_Interrupt_Status
	CMP R12, #0x10
	BNE Civilian_Save
Battle_Save
	LDR R8, = Memory_Battleship
	BL MineShip_Coordinate_Save
	B Button_Return
Civilian_Save
	LDR R8, = Memory_Civilianship
	BL MineShip_Coordinate_Save
	B Button_Return
	 
WaitHandover
	LDR R6, = Memory_GamePhase
	LDRB R9, [R6]
	ADD R9, R9, #1
	STRB R9, [R6]
	B Button_Return
WaitPlayer2

	BL Enable_Timers
	BL	ClearNokia ; clear the screen
	LDR	R5,=gameplayBorder 
	BL	OutImgNokia ; output the border
	LDR R8, = Memory_Battleship
	LDR R5, = MSG_Battleship
	BL MineShip_Output_Display ; print battleships while deployment
	LDR R8, = Memory_Civilianship
	LDR R5, = MSG_Civilianship
	BL MineShip_Output_Display ; print battleships while deployment
	B Button_Return
	
MineDeploy
	MOV R0, #0 ; clear x-coordinate
	MOV R1, #0 ; clear y-coordinate
	BL ADC_0_Read_X
	LDR R3, = Axis_X_Slice
	BL Find_Pixel_Coordinate ; x-coordinae
	BL ADC_1_Read_Y
	LDR R3, = Axis_Y_Slice
	BL Find_Pixel_Coordinate
	ADD R0, R0, #Axis_X_Offset ; add x axis offset
	ADD R1, R1, #Axis_Y_Offset ; add y axis offset

	LDR R8, = Memory_Mine
	BL MineShip_Coordinate_Save
	B Button_Return
	
Button_Return
	BL delayTrans
	BL Clear_Interrupt_Status ; clear interrupts before leaving
	POP{R5-R6,R8,R10-R12,LR}
	BX LR
	ENDP
		
delayTrans
	PUSH	{LR}
	PUSH	{R0}
	MOV		R0,#0xF55			;~250ms, 0x5855
;	MOVT	R0,#0x0001
dt			
	SUBS	R0,#1
	BNE		dt
	POP		{R0}
	POP	{LR}
	BX		LR

;------------delay------------
; Delay function for testing, which delays about 3*count cycles.
; Input: R1  count
; Output: none

;delay
    ;SUBS R1, R1, #1                 ; R1 = R1 - 1 (count = count - 1)
    ;BNE delay                       ; if count (R1) != 0, skip to 'delay'
    ;BX  LR                          ; return

;------------PortF_Button_Init------------
; Initialize GPIO Port F for negative logic switches on PF0 and
; PF4 as the Launchpad is wired.  Weak internal pull-up
; resistors are enabled, and the NMI functionality on PF0 is
; disabled.  Make the RGB LED's pins outputs.
; Modifies: R0, R1, R2'
;------------PortF_Button_Init------------
PortF_Button_Init
    PUSH{R0-R12}
    PUSH{LR}
    LDR R1, =SYSCTL_RCGCGPIO_R      ; 1) activate clock for Port F
    LDR R0, [R1]                 
    ORR R0, R0, #0x20               ; set bit 5 to turn on clock
    STR R0, [R1]                  
    NOP
    NOP                             
    LDR R1, =GPIO_PORTF_LOCK_R      
    LDR R0, =0x4C4F434B             ; unlock GPIO Port F Commit Register
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTF_CR_R        ; enable commit for Port F
    MOV R0, #0xFF                   ; 1 means allow access
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTF_AMSEL_R     ; 3) disable analog functionality
    MOV R0, #0                      ; 0 means analog is off
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTF_PCTL_R      ; 4) configure as GPIO
    MOV R0, #0x00000000             ; 0 means configure Port F as GPIO
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTF_DIR_R       ; 5) set direction register
    MOV R0,#0x0E                    ; PF0 and PF7-4 input, PF3-1 output
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTF_AFSEL_R     ; 6) regular port function
    MOV R0, #0                      ; 0 means disable alternate function 
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTF_PUR_R       ; pull-up resistors for PF4,PF0
    MOV R0, #0x11                   ; enable weak pull-up on PF0 and PF4
    STR R0, [R1]              
    LDR R1, =GPIO_PORTF_DEN_R       ; 7) enable Port F digital port
    MOV R0, #0xFF                   ; 1 means enable digital I/O
    STR R0, [R1]  

    LDR R1, =GPIO_PORTF_IS_R       ; 7) enable Port F digital port
    MOV R0, #0x00                   ; 1 means enable digital I/O
    STR R0, [R1] 
	
    LDR R1, =GPIO_PORTF_BE_R       ; 7) enable Port F digital port
    MOV R0, #0x00                   ; 1 means enable digital I/O
    STR R0, [R1] 
	
    LDR R1, =GPIO_PORTF_IEV_R       ; 7) enable Port F digital port
    MOV R0, #0x00                   ; 1 means enable digital I/O
    STR R0, [R1] 
	
    LDR R1, =GPIO_PORTF_IM_R       ; 7) enable Port F digital port
    MOV R0, #0x11                  ; 1 means enable digital I/O
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
    POP{LR}
    POP{R0-R12}
    BX  LR      
    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file