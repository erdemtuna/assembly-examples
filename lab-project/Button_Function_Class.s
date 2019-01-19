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

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
		EXPORT PortF_Button_Init
		EXPORT Check_Interrupt_Status
		EXPORT Clear_Interrupt_Status
		EXPORT GPIOPortF_Handler
		
;-------------------------------------------
; Read PF4-PF0 Interrupt Status
; Return in R9
; Return Value either 0x11 or 0x10 or 0x01
;-------------------------------------------
Check_Interrupt_Status
	PUSH{R0-R8,R10-R12}
	PUSH{LR}
	LDR R1, = GPIO_PORTF_RIS_R
	LDR R9, [R1]
	ANDS R9, #0x11
	POP{LR}
	POP{R0-R8,R10-R12}
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
	
GPIOPortF_Handler PROC
	PUSH{R5-R11,LR} ; R0,R1,R2,R3,R12 are pushed to stack
					; when interrupt occurs

	POP{R5-R11,LR}
	BX LR
	ENDP

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
;	LDR R1, =NVIC_PRI4
;	LDR R0, [R1]
;	MOV32 R2, #0x0000FFFF
;	AND R0, R0, R2 ; clear interrupt
;	MOV32 R2,  #0x40400000
;	ORR R0, R0, R2 ; set interrupt
;	STR R0, [R1]
;; NVIC has to be enabled
;; Interrupts 64-95 are handled by NVIC register EN2
;; Interrupt 94 is controlled by bit 30-31
;	LDR R1, =NVIC_EN0
;	LDR R0, [R1] 
;	ORR R0, R0, #0xC0000000; set bit 30-31 to enable interrupt 94-95
;	STR R0, [R1]
    POP{LR}
    POP{R0-R12}
    BX  LR      
    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file