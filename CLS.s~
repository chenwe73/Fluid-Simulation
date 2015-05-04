.include "nios_macros.s"
.include "constants.s"

.equ MAXCOLS, 320
.equ MAXROWS, 240

.section .text 
.global CLEAR

CLEAR:
	movi r8, 0 #register to store current row of CURRENT
	movi r9, 0 #register to store current col of CURRENT
	movia r2, ADDR_VGA
	movi r11, MAXROWS-1  #last row 
	movi r12, MAXCOLS-1  #last col 

	LOOP:
	bgt r8, r11, DONE # exit condition, if past last row

	sthio r0, 0(r2)

	DONE_CHECKING:
		addi r2, r2, 0x2 # going to next pixel location
		addi r9, r9, 1

	bgt r9, r12, UPDATE_ROW_AND_COL # if col goes out of bounds while incrementing, increase row and reset col
	br DONE_UPDATING:

	UPDATE_ROW_AND_COL:
		subi r2, r2, MAXCOLS*2
		addi r2, r2, 1024
		# updating address to write to when the row changes
		addi r8, r8, 1
		movi r9, 0

	DONE_UPDATING:
		br LOOP

		
DONE:
	ret

