.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	//
	//mov # to reg
	//
	movs	r0,	#100
	movs	r1,	#101
	mov	r2,	#102
	movw	r3,	#103

	//
	//push
	//
	push	{r0,r1,r2,r3}

	//
	//pop
	//
	pop	{r2}

	//
        //push
        //
        push    {r2,r0,r3,r1}

	//
        //pop
        //
        pop     {r1,r2}



label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.
