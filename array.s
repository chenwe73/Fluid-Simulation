.include "nios_macros.s"
.equ RED_LEDS, 0x10000000
# for debugging purposes
.equ ROWS, 10
.equ COLS, 10
.equ ELEMENTSIZE, 4
# array specifications

.data

.align 2
ARRAY: 
	.skip ROWS*COLS*ELEMENTSIZE
	
	
.text

.global _start
_start:

subi sp, sp, 4
stw ra, 0(sp)

TRAVERSE_ARRAY:
	movi r8, 0 #register to store current row of array
	movi r9, 0 #register to store current col of array
	movia r10, ARRAY #counter to store current address of array element
	movi r11, ROWS-1 #last row of array
	movi r12, COLS-1 #last col of array

	LOOP:
	bgt r8, r11, DONE # exit condition, if past last row

	# see if we can access array elements above, below, to the left and to the right

	CHECK_ABOVE: 
		beq r8, r0, CHECK_BELOW # if on edge, do not process element out of bounds, continue to next check
		call PROCESS_ELEMENT_ABOVE
	CHECK_BELOW:
		beq r8, r11, CHECK_LEFT # if on edge, do not process element out of bounds, continue to next check
		call PROCESS_ELEMENT_BELOW
	CHECK_LEFT:
		beq r9, r0, CHECK_RIGHT # if on edge, do not process element out of bounds, continue to next check
		call PROCESS_ELEMENT_LEFT
	CHECK_RIGHT:
		beq r9, r12, DONE_CHECKING # if on edge, do not process element out of bounds, continue to next check
		call PROCESS_ELEMENT_RIGHT

	DONE_CHECKING:
		addi r10, r10, ELEMENTSIZE # incrementing array pointer
		addi r9, r9, 1

	bgt r9, r12, UPDATE_ROW_AND_COL # if col goes out of bounds while incrementing, increase row and reset col
	br DONE_UPDATING:

	UPDATE_ROW_AND_COL:
		addi r8, r8, 1
		movi r9, 0

	DONE_UPDATING:
		br LOOP

		
DONE:
	br DONE

ARRAY_ACCESS: #for array[i][j] ...put i in r4 and j in r5, then returns array element address in r2
	movia r2, ARRAY
	muli r4, r4, ELEMENTSIZE*COLS
	add r2, r2, r4
	muli r5, r5, ELEMENTSIZE
	add r2, r2, r5
	ret	
	
PROCESS_ELEMENT_ABOVE:
	subi r2, r10, COLS*ELEMENTSIZE # array pointer r2 contains address of element above
	ret

PROCESS_ELEMENT_BELOW:
	addi r2, r10, COLS*ELEMENTSIZE # array pointer r2 contains address of element below
	ret

PROCESS_ELEMENT_LEFT:
	subi r2, r10, ELEMENTSIZE # array pointer r2 contains address of element to left
	ret

PROCESS_ELEMENT_RIGHT:
	addi r2, r10, ELEMENTSIZE # array pointer r2 contains address of element to right
	ret
