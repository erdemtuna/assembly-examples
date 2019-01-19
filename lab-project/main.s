;***************************************************************
; Program section					      
;***************************************************************
Memory_Battleship	EQU 0x20000700
Memory_Civilianship	EQU 0x20000734
Memory_Mine			EQU 0x20000768
	
Axis_X_Slice		EQU 56
Axis_Y_Slice		EQU 825
	
Axis_X_Offset		EQU 6
Axis_Y_Offset		EQU 1
	
;LABEL		DIRECTIVE	VALUE			COMMENT
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

MSG_Cursor DCB "+",0x04
MSG_Battleship DCB "[",0x04
MSG_Civilianship DCB "{",0x04
MSG_Mine DCB "*",0x04
MSG_Clear_Cursor DCB " ",0x04
MSG_InitialRun DCB	"EE447            Lab Project      Burkay Unsal     Erdem Tuna",0x04
MSG_Welcome DCB	"Place the ship   after border is  visible.",0x04
MSG_WaitUser2 DCB	"Waiting for      player2 to press both buttons.",0x04
	
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
; ADC functions
;----------------------------------
	EXTERN ADC_1_Read_Y
	EXTERN ADC_0_Read_X
	EXTERN Find_Pixel_Coordinate
	EXTERN ADC_Init
;----------------------------------
; PORT-F Button functions
;----------------------------------
	EXTERN PortF_Button_Init
	EXTERN Check_Interrupt_Status
	EXTERN Clear_Interrupt_Status
;----------------------------------
; Timer functions
;----------------------------------
	EXTERN	WideTimer0A_Handler
	EXTERN	WideTimer0B_Handler
	EXTERN	Timers_Init
	EXTERN	Enable_Timers
			
	EXPORT Start
	EXPORT Set_Coordinates_Mine
				
Start	
	BL Nokia_Init ; initialize LCD
	BL Timers_Init ; initialize LCD
	BL ADC_Init ; initialize ADC
	BL PortF_Button_Init ; initialize buttons
	CPSIE I
	B Clear_Ship_Memories ; clear ship memories
	
Clear_Ship_Memories
	MOV R2, #4 ; counter to clear 16 bytes
	LDR R3, = Memory_Battleship ; battleship memory address
Clear_Battleship_Memory
	MOV R4, #0x00000000
	STR R4, [R3], #4
	SUBS R2, #1
	BNE Clear_Battleship_Memory
	MOV R2, #4 ; counter to clear 16 bytes
	LDR R3, = Memory_Civilianship ; battleship memory address
Clear_Civilianship_Memory
	MOV R4, #0x00000000
	STR R4, [R3], #4
	SUBS R2, #1
	BNE Clear_Civilianship_Memory
	MOV R2, #4 ; counter to clear 16 bytes
	LDR R3, = Memory_Mine ; battleship memory address
Clear_Mine_Memory
	MOV R4, #0x00000000
	STR R4, [R3], #4
	SUBS R2, #1
	BNE Clear_Mine_Memory

	
	
loadRam

; output initial first run messages
Initial_Messages	
	MOV	R0, #0
	MOV	R1, #1
	BL	SetCoordinate	
	LDR	R5,=MSG_InitialRun
	BL	OutStrNokia
	;BL	delay
	BL	ClearNokia
	MOV	R0, #0
	MOV	R1, #1
	BL SetCoordinate	
	LDR	R5,=MSG_Welcome
	BL OutStrNokia
	;BL delay
	
; load game border
Load_GameBorder
	LDR	R5,=gameplayBorder
	BL	OutImgNokia
	MOV R10, #99 ; old x coordinate
	MOV R11, #99 ; old y coordinate 
	MOV R2, #0 ; difference counter
	MOV R6, #0 ; ship counter
	
Deploy_Ships
	;BL delayTrans
	LDR R8, = Memory_Battleship
	LDR R5, = MSG_Battleship
	BL MineShip_Output_Display ; print battleships while deployment
	LDR R8, = Memory_Civilianship
	LDR R5, = MSG_Civilianship
	BL MineShip_Output_Display ; print battleships while deployment
	BL Clear_Interrupt_Status ; clear button interrupts
	CMP R6, #4 ; check if all ships are deployed
	BEQ Placement_Done
	MOV R0, #0 ; clear x-coordinate
	MOV R1, #0 ; clear y-coordinate
	MOV R2, #0 ; reset counter
	BL ADC_0_Read_X
	LDR R3, = Axis_X_Slice
	BL Find_Pixel_Coordinate ; x-coordinae
	BL ADC_1_Read_Y
	LDR R3, = Axis_Y_Slice
	BL Find_Pixel_Coordinate
	ADD R0, R0, #Axis_X_Offset ; add x axis offset
	ADD R1, R1, #Axis_Y_Offset ; add y axis offset
	CMP R0, R10 ; check if x coordinate has changed
	ADDNE R2, #1
	CMP R1, R11 ; check if y coordinate has changed
	ADDNE R2, #1
	CMP R2, #0 ; if R2 == 0, then coordinates remained same, check again
		       ; if R2 != 0, then at least one of the coordinates
			   ; have changed
	BEQ Go_Check_Ship_Placement; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	BL Update_Cursor 
Go_Check_Ship_Placement
	;BL Check_Ship_Placement
	B Deploy_Ships

;-------------------------------------------
; Updates the position of the cursor.
; Pass old coordinates in R10(x) and R11(y);
; Pass new coordinates in R0(x) and R1(y).
;-------------------------------------------
Update_Cursor
	PUSH{R3-R9,LR}
	PUSH{R0-R2} ; save new coordinates
	MOV R0, R10 ; old x coordinate
	MOV R1, R11 ; old y coordinate
	BL SetCoordinate
	LDR	R5,=MSG_Clear_Cursor
	BL OutStrNokia
	POP{R0-R2} ; pop new coordinates
	MOV R10, R0 ; save change
	MOV R11, R1 ; save change
	BL SetCoordinate
	B Move_Cursor
Move_Cursor		
	LDR	R5,=MSG_Cursor
	BL OutStrNokia
;	BL delayTrans
	POP{R3-R9,LR}
	BX LR
	
donethis	B		donethis

;-------------------------------------------
; Let's user to have an overview of the
; deployed ships. No placement is allowed.
; Press both buttons to handover the turn.
; All preused registers can be reset from now on,
; because the game phase is going to change
;-------------------------------------------
Placement_Done
	BL Check_Interrupt_Status ; R9 has interrupt status
	CMP R9, #0x11 ; if R9 == 0x11, user wants handover to
				   ; other player
				   ; Otherwise wait for 0x11.
	BNE Placement_Done
	BL Clear_Interrupt_Status ; clear button interrupts
	B Wait_for_Second_Player

;-------------------------------------------
; Checks if a ship is to be placed
; if yes, then saves the ship to memory
; if not, returns back
;-------------------------------------------
Check_Ship_Placement
	PUSH{LR}
	BL Check_Interrupt_Status ; R9 has interrupt status
	CMP R9, #0x00 ; if R9 == 0x00, there is no ship placement
	BNE Determine_Ship_Type
	POP{LR}
	BX LR
;-------------------------------------------
; Checks which ship type is deployed.
; Redirects to save subroutine of respective ship
;-------------------------------------------
Determine_Ship_Type
	
	CMP R9, #0x10 ; if R9 == 0x10, place a batlleship
				  ; if R9 < 0x10, place a civilianship
				  ; if R9 > 0x10, ship placement is done
;	BEQ Placement_Battleship_Save
;	BLO Placement_Civilianship_Save
;	B	Placement_Done
	
;-------------------------------------------
; Outputs specified symbol, if saved to memory.
; Pass Memory Location in R8.
;-------------------------------------------
MineShip_Coordinate_Save
	PUSH{R0-R12}
	PUSH{LR}
	;ADD R6, R6, #1 ; increase the ship count
	;LDR R8, = Memory_Battleship
MineShip_Zero_Memory
	LDRB R4, [R8], #2
	CMP R4, #0
	BNE MineShip_Zero_Memory
	SUB R8, R8, #2
	STRB R0, [R8], #1 ; store x coordinate of the ship
	STRB R1, [R8], #1 ; store y coordinate of the ship
	POP{LR}
	POP{R0-R12}
	BX LR ; return to last call of Check_Ship_Placement

;-------------------------------------------
; Outputs specified symbol, if saved to memory.
; Pass Memory Location in R8, and message in R5.
;-------------------------------------------
MineShip_Output_Display	
	PUSH{R0-R12}
	PUSH{LR}
	;LDR R8, = Memory_Battleship ; battleship memory address
Output_Battleship
	LDRB R0, [R8], #1 ; load x coordinate of the ship
	CMP R0, #0
	BEQ MineShip_Output_Display_Return ; if R0 == 0, then it is end of saved symbols
										   ; return 
	LDRB R1, [R8], #1 ; load y coordinate of the ship
	BL SetCoordinate
	;LDR	R5, = MSG_Battleship
	BL	OutStrNokia
	;BL delayTrans
	B Output_Battleship ; loop through all saved symbols	
MineShip_Output_Display_Return	
	POP{LR}
	POP{R0-R12}
	BX LR
	
;************************ SECOND PLAYER PHASE ************************
Wait_for_Second_Player
	BL Clear_Interrupt_Status ; clear button interrupts
	BL	ClearNokia
	LDR	R5, = MSG_WaitUser2 ; output prompt message
	BL	OutStrNokia
Wait_for_Second_Player_Interrupt
	BL Check_Interrupt_Status ; R9 has interrupt status
	CMP R9, #0x11 ; if R9 == 0x11, user2 wants to start mine placement
				   ; otherwise, wait for user2 to concentrate on.
	BNE Wait_for_Second_Player_Interrupt
	BL Clear_Interrupt_Status ; clear button interrupts
	B Place_Mines_Init

Place_Mines_Init
	; clear all registers
	MOV R0, #0
	MOV R1, #0
	MOV R2, #0
	MOV R3, #0
	MOV R4, #0
	MOV R5, #0
	MOV R6, #0
	MOV R7, #0
	MOV R8, #0
	MOV R9, #0
	MOV R10, #0
	MOV R11, #0
	MOV R12, #0
	BL Enable_Timers
	BL	ClearNokia ; clear the screen
	LDR	R5,=gameplayBorder 
	BL	OutImgNokia ; output the border
;	BL Placement_Battleship_Output ; print battleships while deployment
;	BL Placement_Civilianship_Output ; print civilianships while deployment
	MOV R4, #0
	BL Clear_Interrupt_Status ; clear button interrupts
Wait_Mine_Interrupt
	CMP R4, #1
	BNE Wait_Mine_Interrupt
	
Set_Coordinates_Mine
	BL delayTrans
	BL Placement_Mine_Output ; print battleships while deployment
	BL Clear_Interrupt_Status ; clear button interrupts
	CMP R6, #4 ; check if all mines are deployed
	BEQ Mine_Done
	MOV R0, #0 ; clear x-coordinate
	MOV R1, #0 ; clear y-coordinate
	MOV R2, #0 ; reset counter
	BL ADC_0_Read_X
	LDR R3, = Axis_X_Slice
	BL Find_Pixel_Coordinate ; x-coordinae
	BL ADC_1_Read_Y
	LDR R3, = Axis_Y_Slice
	BL Find_Pixel_Coordinate
	ADD R0, R0, #6 ; add x axis offset
	ADD R1, R1, #1 ; add y axis offset
	CMP R0, R10 ; check if x coordinate has changed
	ADDNE R2, #1
	CMP R1, R11 ; check if y coordinate has changed
	ADDNE R2, #1
	CMP R2, #0 ; if R2 == 0, then coordinates remained same, check again
		       ; if R2 != 0, then at least one of the coordinates
			   ; have changed
	;BEQ Go_Check_Ship_Placement; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	BEQ Go_Mine_Placement; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	B Clear_Old_MineCursor 
Go_Mine_Placement
	BL Check_Mine_Placement
	B Set_Coordinates_Mine
	
Clear_Old_MineCursor
	PUSH{R0-R2} ; save new coordinates
	MOV R0, R10 ; old x coordinate
	MOV R1, R11 ; old y coordinate
	BL SetCoordinate
	LDR	R5,=MSG_Clear_Cursor
	BL	OutStrNokia
	POP{R0-R2} ; pop new coordinates
	MOV R10, R0 ; save change
	MOV R11, R1 ; save change
	BL SetCoordinate
	B Move_Cursor_Mine
Move_Cursor_Mine		
	LDR	R5,=MSG_Cursor
	BL	OutStrNokia
;	BL delayTrans
	B	Set_Coordinates_Mine

;-------------------------------------------
; Checks if a ship is to be placed
; if yes, then saves the ship to memory
; if not, returns back
;-------------------------------------------
Check_Mine_Placement
	PUSH{LR}
	BL Check_Interrupt_Status ; R9 has interrupt status
	CMP R9, #0x00 ; if R9 == 0x00, there is no ship placement
	BNE Mine_Placement
	POP{LR}
	BX LR

Mine_Placement
	PUSH{R0-R5,R7-R12}
	ADD R6, R6, #1 ; increase the ship count
	LDR R3, = Memory_Mine
Find_Mine_Zero_Memory
	LDRB R4, [R3], #2
	CMP R4, #0
;	BNE Find_Civilianship_Zero_Memory
	SUB R3, R3, #2
	STRB R0, [R3], #1 ; store x coordinate of the mine
	STRB R1, [R3], #1 ; store y coordinate of the mine
	POP{R0-R5,R7-R12}
	POP{LR}
	BX LR ; return to last call of Check_Ship_Placement
	
Placement_Mine_Output	
	PUSH{R0-R12}
	PUSH{LR}
	LDR R3, = Memory_Mine ; battleship memory address
Output_Mine
	LDRB R0, [R3], #1 ; load x coordinate of the ship
	CMP R0, #0
	BEQ Placement_Mine_Output_Return ; if R0 == 0, then it is end of battleships
										   ; return 
	LDRB R1, [R3], #1 ; load y coordinate of the ship
	BL SetCoordinate
	LDR	R5, = MSG_Mine
	BL	OutStrNokia
	;BL delayTrans
	B Output_Mine ; loop through all battleships
Placement_Mine_Output_Return	
	POP{LR}
	POP{R0-R12}
	BX LR
	
	
Mine_Done
	B Mine_Done
	
	
	
	
	
	
	

;			BL		delay				; leave image for a few s

;			MOV							; reset XY position to 0,0
;			MOV							; using setXY routine
;	BL		SetCoordinate			; DC is left high ready to send data
; transition to CSU											
		;	MOV		R0,#504				; 504 bytes in full image
		;	LDR		R1,=imgCSU			; put img address in R1
sendNxtCSUByte		
	;			LDRB					; load R5 with byte, post inc addr
	BL		TxByte			; use byte routine
	BL		delayTrans			; slow down loading of next byte
	SUBS	R0,#1
	BNE		sendNxtCSUByte

	BL		delay				; leave image for a few s

;clear screen using ClearNokia routine
	BL		ClearNokia


	;			MOV							; X pos (0-83)
	;			MOV							; Y pos (0-5)
	BL		SetCoordinate			; set XY position
	LDR		R5,=MSG_Cursor
	BL		OutStrNokia

	BL		delay				; leave text up
		
done		B		loadRam				; loop 		
	
	
delay		
	PUSH	{R0}
	MOV		R0,#0x8555
	MOVT	R0,#0x0140
del			
	SUBS	R0,#1
	BNE		del
	POP		{R0}
	BX		LR

delayTrans	PUSH	{R0}
	MOV		R0,#0xF55			;~250ms, 0x5855
;	MOVT	R0,#0x0001
dt			
	SUBS	R0,#1
	BNE		dt
	POP		{R0}
	BX		LR
			
			
	ALIGN
	END