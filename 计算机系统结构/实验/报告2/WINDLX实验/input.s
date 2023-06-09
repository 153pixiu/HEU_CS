 .data

		;*** Data for Read-Trap
ReadBuffer:	.space		80               
ReadPar:	.word		0,ReadBuffer,80  

		;*** Data for Printf-Trap
PrintfPar:	.space		4

SaveR2:		.space		4
SaveR3:		.space		4
SaveR4:		.space		4
SaveR5:		.space		4

.text

        .global		InputUnsigned
InputUnsigned:	
		;*** save register contents
		sw		SaveR2,r2                 ;put SaveR2 to r2
		sw		SaveR3,r3
		sw		SaveR4,r4
		sw		SaveR5,r5
		addi    r10,r0,0
		addi    r11,r0,0

		;*** Prompt
		sw		PrintfPar,r1
		addi		r14,r0,PrintfPar      ;put PrintfPar to r14
		trap		5

		;*** call Trap-3 to read line
		addi		r14,r0,ReadPar
		trap		3                     ;read file

		;*** determine value
		addi		r2,r0,ReadBuffer
		addi		r1,r0,0
		addi		r4,r0,10	;Decimal system

Loop:		;*** reads digits to end of line
		lbu		    r3,0(r2)
		seqi		r5,r3,10	;LF -> Exit
		bnez		r5,Finish
			;***panduan
		slti        r11,r3,58
		beqz        r11,Error
		slti        r10,r3,48
		bnez        r10,Error

		subi		r3,r3,48	;??
		
		multu		r1,r1,r4	;Shift decimal
		add		    r1,r1,r3
		addi		r2,r2,1 	;increment pointer
		j		    Loop
		
Finish: 	;*** restore old register contents
		lw		r2,SaveR2
		lw		r3,SaveR3
		lw		r4,SaveR4
		lw		r5,SaveR5
		jr		r31		         ; Return

Error:
		addi    r10,r0,1
		jr      r31