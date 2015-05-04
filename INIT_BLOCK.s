.include "nios_macros.s"
.include "constants.s"


.section .text 
.global INIT_MAP

INIT_MAP:
	subi sp, sp, 4
	stw ra, 0(sp)

	movi r8, 0 #register to store current row of array
	movi r9, 0 #register to store current col of array
	movia r10, NEXT #counter to store current address of array element
	movi r11, ROWS-1 #last row of array
	movi r12, COLS-1 #last col of array
	movia r13, BLOCK

	LOOP:
	bgt r8, r11, DONE # exit condition, if past last rowWALL
	# see if we can access array elements above, below, to the left and to the right
	beq r8, r0, EDGE
	beq r8, r11, EDGE
	beq r9, r0, EDGE
	beq r9, r12, EDGE



	NOT_EDGE:
		movi r2, FLUID
		stw r2, 0(r13)

		# diagonal wall
		/*bne r8, r9, AFTER_WALL1
			movi r2, WALL
			stw r2, 0(r13)
			br AFTER_NOT_EDGE
		AFTER_WALL1:
		*/
		subi r4, r8, ROWS
		sub r4, r0, r4
		bne r4, r9, AFTER_WALL2
			movi r2, WALL
			stw r2, 0(r13)
			br AFTER_NOT_EDGE
		AFTER_WALL2:

		subi r4, r8, ROWS
		sub r4, r0, r4
		addi r4, r4, 10
		bne r4, r9, AFTER_WALL3
			movi r2, WALL
			stw r2, 0(r13)
			br AFTER_NOT_EDGE
		AFTER_WALL3:

		# tap
		movi r4, 5 # row
		bgt r8, r4, AFTER_NOT_EDGE
		movi r4, 50 # max col
		bgt r9, r4, AFTER_NOT_EDGE
		movi r4, 40 # min col
		blt r9, r4, AFTER_NOT_EDGE
			movui r4, FULL
			movi r5, 2
			div r4, r4, r5
			#addi r4, r4, 0xf
			stw r4, 0(r10)

		br DONE_CHECKING
	AFTER_NOT_EDGE:
		#stw r0, 0(r10)
		
	br DONE_CHECKING
	EDGE: # edge are wall
		movi r2, WALL
		stw r2, 0(r13)


	

	DONE_CHECKING:
		addi r10, r10, ELEMENTSIZE # incrementing array pointer
		addi r13, r13, ELEMENTSIZE # incrementing array pointer
		addi r9, r9, 1

	bgt r9, r12, UPDATE_ROW_AND_COL # if col goes out of bounds while incrementing, increase row and reset col
	br DONE_UPDATING:

	UPDATE_ROW_AND_COL:
		addi r8, r8, 1
		movi r9, 0

	DONE_UPDATING:
	br LOOP

	DONE:

	

	
	ldw ra, 0(sp)
	addi sp, sp, 4
ret





