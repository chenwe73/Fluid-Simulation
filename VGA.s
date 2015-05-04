.include "nios_macros.s"
.include "constants.s"


.section .text 
.global VGA

VGA:
	subi sp, sp, 12
	stw ra, 0(sp)
	stw r16, 4(sp)
	stw r17, 8(sp)
	
	movi r8, 0 #register to store current row of CURRENT
	movi r9, 0 #register to store current col of CURRENT
	movia r10, CURRENT #counter to store current address of CURRENT element
	movi r11, ROWS*ZOOM-1 #last row of CURRENT
	movi r12, COLS*ZOOM-1 #last col of CURRENT
	movia r13, ADDR_VGA + STARTINGPOINT #address to write pixel to
	movia r14, BLOCK
	movi r16, 1 # horizontal counter
	movi r17, 1 # vertical counter

	LOOP:
	bgt r8, r11, DONE # exit condition, if past last row

	ldwio r4, 0(r10)
	ldwio r5, 0(r14)
	call GET_COLOR
	sthio r2, 0(r13)

	DONE_CHECKING:
		movi r4, ZOOM
		bne r16, r4, SAME_CELL
			addi r10, r10, ELEMENTSIZE # incrementing CURRENT pointer
			addi r14, r14, ELEMENTSIZE # incrementing BLOCK pointer
			movi r16, 0
		SAME_CELL:
		addi r16, r16, 1

		addi r13, r13, 0x2 # going to next pixel location
		addi r9, r9, 1

	bgt r9, r12, UPDATE_ROW_AND_COL # if col goes out of bounds while incrementing, increase row and reset col
	br DONE_UPDATING:

	UPDATE_ROW_AND_COL:
		subi r13, r13, COLS*2*ZOOM
		addi r13, r13, 1024
		# updating address to write to when the row changes
		addi r8, r8, 1
		movi r9, 0

		movi r4, ZOOM
		bne r17, r4, SAME_ROW
			movi r17, 0
			br NEW_ROW
		SAME_ROW:
			subi r10, r10, ELEMENTSIZE*COLS # decrement CURRENT pointer
			subi r14, r14, ELEMENTSIZE*COLS # decrement BLOCK pointer
		NEW_ROW:
		addi r17, r17, 1

	DONE_UPDATING:
		br LOOP

	DONE:

	ldw r17, 8(sp)
	ldw r16, 4(sp)
	ldw ra, 0(sp)
	addi sp, sp, 12
ret


# r4 - CURRENT
# r5 - BLOCK
# r2 - color 16-bit
GET_COLOR:
	subi sp, sp, 8
	stw ra, 0(sp)
	stw r16, 4(sp)

	movi r16, FLUID
	beq r5, r16, FLUIDCELL
	movi r16, WALL
	beq r5, r16, WALLCELL

	FLUIDCELL:
		srli r2, r4, BLUE_SHIFT
		movui r16, FULL
		ble r4, r16, AFTER_BLUE #if more than FULL
			movui r2, FULL
			srli r2, r2, BLUE_SHIFT # return color of FULL

		AFTER_BLUE:
			/*movi r4, 0b1111
			slli r4, r4, 11
			add r2, r2, r4*/
		br AFTER_GET_COLOR
	WALLCELL:
		movui r2, WHITE
		br AFTER_GET_COLOR
	
	AFTER_GET_COLOR:

	
	ldw r16, 4(sp)
	ldw ra, 0(sp)
	addi sp, sp, 8
ret




