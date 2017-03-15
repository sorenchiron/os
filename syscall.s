	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 11
                                        ## Start of file scope inline assembly
	.code16


                                        ## End of file scope inline assembly
	.globl	_main
	.align	4, 0x90
_main:                                  ## @main
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	calll	L0$pb
L0$pb:
	popl	%eax
	## InlineAsm Start
	pushl	%eax
	movw	%cs, %ax
	movw	%ax, %ds
	movw	%ax, %es
	movw	%ax, %fs
	movw	%ax, %gs
	movw	%bp, %di
	popl	%eax

	## InlineAsm End
	movl	$1, %ecx
	xorl	%edx, %edx
	movl	$1, (%esp)
	movl	$0, 4(%esp)
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	movl	%ecx, -8(%ebp)          ## 4-byte Spill
	movl	%edx, -12(%ebp)         ## 4-byte Spill
	calll	_setcursor
	movl	-4(%ebp), %eax          ## 4-byte Reload
	leal	_roottask-L0$pb(%eax), %ecx
	xorl	%edx, %edx
	movl	%ecx, (%esp)
	movl	$0, 4(%esp)
	movl	%edx, -16(%ebp)         ## 4-byte Spill
	calll	_new_task
	movl	-4(%ebp), %eax          ## 4-byte Reload
	leal	_task1-L0$pb(%eax), %ecx
	movl	$1, %edx
	movl	%ecx, (%esp)
	movl	$1, 4(%esp)
	movl	%edx, -20(%ebp)         ## 4-byte Spill
	calll	_new_task
	xorl	%eax, %eax
	movl	$0, (%esp)
	movl	$0, 4(%esp)
	movl	%eax, -24(%ebp)         ## 4-byte Spill
	calll	_start_procedure
	addl	$40, %esp
	popl	%ebp
	retl

	.globl	_setcursor
	.align	4, 0x90
_setcursor:                             ## @setcursor
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%esi
	subl	$12, %esp
	calll	L1$pb
L1$pb:
	popl	%eax
	movb	12(%ebp), %cl
	movb	8(%ebp), %dl
	movb	%dl, -9(%ebp)
	movb	%cl, -10(%ebp)
	movb	-9(%ebp), %cl
	movb	-10(%ebp), %dl
	movl	%eax, -16(%ebp)         ## 4-byte Spill
	movb	%dl, -17(%ebp)          ## 1-byte Spill
	movb	-17(%ebp), %ch          ## 1-byte Reload
	## InlineAsm Start
	movb	$2, %ah
	movb	$0, %bh
	movb	%cl, %dh
	movb	%ch, %dl
	int	$16
	## InlineAsm End
	movb	-9(%ebp), %cl
	movl	-16(%ebp), %esi         ## 4-byte Reload
	movb	%cl, _tty_current_row-L1$pb(%esi)
	movb	-10(%ebp), %cl
	movb	%cl, _tty_current_col-L1$pb(%esi)
	addl	$12, %esp
	popl	%esi
	popl	%ebx
	popl	%ebp
	retl

	.globl	_new_task
	.align	4, 0x90
_new_task:                              ## @new_task
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	subl	$8, %esp
	calll	L2$pb
L2$pb:
	popl	%eax
	movb	12(%ebp), %cl
	movl	8(%ebp), %edx
	movl	L_pool$non_lazy_ptr-L2$pb(%eax), %eax
	movl	%edx, -12(%ebp)
	movb	%cl, -13(%ebp)
	movl	-12(%ebp), %edx
	movzbl	-13(%ebp), %esi
	imull	$180, %esi, %esi
	movl	%eax, %edi
	addl	%esi, %edi
	movl	%edx, 44(%edi)
	movb	-13(%ebp), %cl
	movzbl	-13(%ebp), %edx
	imull	$180, %edx, %edx
	movl	%eax, %esi
	addl	%edx, %esi
	movb	%cl, (%esi)
	movzbl	-13(%ebp), %edx
	imull	$180, %edx, %edx
	addl	%edx, %eax
	movb	$1, 1(%eax)
	addl	$8, %esp
	popl	%esi
	popl	%edi
	popl	%ebp
	retl

	.globl	_roottask
	.align	4, 0x90
_roottask:                              ## @roottask
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	## InlineAsm Start
	sti

	## InlineAsm End
LBB3_1:                                 ## =>This Inner Loop Header: Depth=1
	movl	$10, %eax
	movl	$10, (%esp)
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	calll	_sleep
	movl	$73, %eax
	movl	$73, (%esp)
	movl	%eax, -8(%ebp)          ## 4-byte Spill
	calll	_dispchar
	jmp	LBB3_1

	.globl	_task1
	.align	4, 0x90
_task1:                                 ## @task1
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	jmp	LBB4_1
LBB4_1:                                 ## =>This Inner Loop Header: Depth=1
	movl	$10, %eax
	movl	$10, (%esp)
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	calll	_sleep
	movl	$79, %eax
	movl	$79, (%esp)
	movl	%eax, -8(%ebp)          ## 4-byte Spill
	calll	_dispchar
	jmp	LBB4_1

	.globl	_start_procedure
	.align	4, 0x90
_start_procedure:                       ## @start_procedure
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%edi
	pushl	%esi
	subl	$12, %esp
	calll	L5$pb
L5$pb:
	popl	%eax
	movb	12(%ebp), %cl
	movb	8(%ebp), %dl
	movb	%dl, -13(%ebp)
	movb	%cl, -14(%ebp)
	movl	%eax, -20(%ebp)         ## 4-byte Spill
	calll	_getesp
	movl	-20(%ebp), %esi         ## 4-byte Reload
	movl	L_pool$non_lazy_ptr-L5$pb(%esi), %edi
	movzbl	-13(%ebp), %ebx
	imull	$180, %ebx, %ebx
	movl	%edi, %ecx
	addl	%ebx, %ecx
	movl	%eax, 8(%ecx)
	movzbl	-13(%ebp), %eax
	imull	$180, %eax, %eax
	addl	%eax, %edi
	movb	$2, 1(%edi)
	movb	-13(%ebp), %dl
	movb	%dl, _current_task-L5$pb(%esi)
	movzbl	-14(%ebp), %eax
	cmpl	$1, %eax
	jne	LBB5_2
## BB#1:
	## InlineAsm Start
	sti

	## InlineAsm End
LBB5_2:
	movl	-20(%ebp), %eax         ## 4-byte Reload
	movl	L_pool$non_lazy_ptr-L5$pb(%eax), %ecx
	movzbl	-13(%ebp), %edx
	imull	$180, %edx, %edx
	addl	%edx, %ecx
	calll	*44(%ecx)
	addl	$12, %esp
	popl	%esi
	popl	%edi
	popl	%ebx
	popl	%ebp
	retl

	.globl	_int08
	.align	4, 0x90
_int08:                                 ## @int08
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	## InlineAsm Start
	pushl	%eax
	pushal
	movl	%ebp, %eax
	addl	$10, %eax
	movl	%eax, 12(%esp)
	movl	(%ebp), %eax
	movl	%eax, 8(%esp)
	movw	8(%ebp), %ax
	pushw	$0
	pushw	%ax
	movw	6(%ebp), %ax
	pushw	$0
	pushw	%ax
	movw	4(%ebp), %ax
	pushw	$0
	pushw	%ax
	calll	_savecontext
	addl	$44, %esp
	popl	%eax

	## InlineAsm End
	calll	_switch_proc
	addl	$8, %esp
	popl	%ebp
	retl

	.globl	_switch_proc
	.align	4, 0x90
_switch_proc:                           ## @switch_proc
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%edi
	pushl	%esi
	subl	$28, %esp
	calll	L7$pb
L7$pb:
	popl	%eax
	movl	L_pool$non_lazy_ptr-L7$pb(%eax), %ecx
	movzbl	181(%ecx), %ecx
	cmpl	$1, %ecx
	movl	%eax, -28(%ebp)         ## 4-byte Spill
	jne	LBB7_2
## BB#1:
	## InlineAsm Start
	pushl	%eax
	movw	$0, %ax
	pushw	%ax
	popfw
	movb	$32, %al
	outb	%al, $32
	popl	%eax

	## InlineAsm End
	movl	$1, %eax
	movl	$1, (%esp)
	movl	$1, 4(%esp)
	movl	%eax, -32(%ebp)         ## 4-byte Spill
	calll	_start_procedure
LBB7_2:
	movl	-28(%ebp), %eax         ## 4-byte Reload
	movl	L_pool$non_lazy_ptr-L7$pb(%eax), %ecx
	movzbl	_current_task-L7$pb(%eax), %edx
	imull	$180, %edx, %edx
	addl	%edx, %ecx
	movb	$3, 1(%ecx)
	movzbl	_current_task-L7$pb(%eax), %ecx
	cmpl	$0, %ecx
	jne	LBB7_4
## BB#3:
	movl	-28(%ebp), %eax         ## 4-byte Reload
	movb	$1, _current_task-L7$pb(%eax)
	jmp	LBB7_5
LBB7_4:
	movl	-28(%ebp), %eax         ## 4-byte Reload
	movb	$0, _current_task-L7$pb(%eax)
LBB7_5:
	movl	-28(%ebp), %eax         ## 4-byte Reload
	movl	L_pool$non_lazy_ptr-L7$pb(%eax), %ecx
	movzbl	_current_task-L7$pb(%eax), %edx
	imull	$180, %edx, %edx
	movl	%ecx, %esi
	addl	%edx, %esi
	movb	$2, 1(%esi)
	movzbl	_current_task-L7$pb(%eax), %edx
	imull	$180, %edx, %edx
	addl	%edx, %ecx
	movl	%ecx, -16(%ebp)
	movl	-16(%ebp), %ecx
	movl	8(%ecx), %ecx
	movl	-16(%ebp), %edx
	subl	16(%edx), %ecx
	addl	$3, %ecx
	movl	%ecx, -20(%ebp)
	movl	-16(%ebp), %ecx
	addl	$52, %ecx
	movl	%ecx, -24(%ebp)
	cmpl	$128, -20(%ebp)
	jb	LBB7_7
## BB#6:
	movl	$128, -20(%ebp)
LBB7_7:
	movl	-16(%ebp), %eax
	movl	16(%eax), %esi
	movl	-16(%ebp), %eax
	movw	6(%eax), %ax
	movl	-16(%ebp), %ecx
	movw	2(%ecx), %bx
	movl	-16(%ebp), %ecx
	movl	40(%ecx), %ecx
	movl	-16(%ebp), %edx
	movl	36(%edx), %edx
	## InlineAsm Start
	movw	$0, -2(%esi)
	movw	%ax, -4(%esi)
	movw	%bx, -6(%esi)
	movl	%ecx, -10(%esi)
	movl	%edx, -14(%esi)

	## InlineAsm End
	movl	-16(%ebp), %ecx
	movl	20(%ecx), %eax
	movl	-16(%ebp), %ecx
	movl	24(%ecx), %ebx
	movl	-16(%ebp), %ecx
	movl	28(%ecx), %ecx
	movl	-16(%ebp), %edx
	movl	32(%edx), %edx
	## InlineAsm Start
	movl	%eax, -18(%esi)
	movl	%ebx, -22(%esi)
	movl	%ecx, -26(%esi)
	movl	%edx, -30(%esi)
	movl	%esi, %edx

	## InlineAsm End
	movl	-16(%ebp), %eax
	movl	12(%eax), %ebx
	## InlineAsm Start


	## InlineAsm End
	movl	-20(%ebp), %ecx
	movl	-24(%ebp), %esi
	movl	-16(%ebp), %eax
	movl	16(%eax), %edi
	## InlineAsm Start
	cld
	rep
	movsb	(%esi), %es:(%edi)

	## InlineAsm End
	## InlineAsm Start
	movl	%ebx, %ebp
	movl	%edx, %esp
	movb	$32, %al
	outb	%al, $32
	subl	$30, %esp
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax
	popl	%esi
	popl	%edi
	popfw
	sti
	retl

	## InlineAsm End
	addl	$28, %esp
	popl	%esi
	popl	%edi
	popl	%ebx
	popl	%ebp
	retl

	.globl	_getesp
	.align	4, 0x90
_getesp:                                ## @getesp
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%eax
	movl	$0, -4(%ebp)
	## InlineAsm Start
	movl	%ebp, %edx
	addl	$8, %edx
	movl	%edx, %eax

	## InlineAsm End
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	addl	$4, %esp
	popl	%ebp
	retl

	.globl	_savecontext
	.align	4, 0x90
_savecontext:                           ## @savecontext
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%edi
	pushl	%esi
	subl	$80, %esp
	calll	L9$pb
L9$pb:
	popl	%eax
	movzwl	16(%ebp), %ecx
	movw	%cx, %dx
	movzwl	12(%ebp), %ecx
	movw	%cx, %si
	movzwl	8(%ebp), %ecx
	movw	%cx, %di
	movl	48(%ebp), %ecx
	movl	44(%ebp), %ebx
	movl	%eax, -68(%ebp)         ## 4-byte Spill
	movl	40(%ebp), %eax
	movl	%eax, -72(%ebp)         ## 4-byte Spill
	movl	36(%ebp), %eax
	movl	%eax, -76(%ebp)         ## 4-byte Spill
	movl	32(%ebp), %eax
	movl	%eax, -80(%ebp)         ## 4-byte Spill
	movl	28(%ebp), %eax
	movl	%eax, -84(%ebp)         ## 4-byte Spill
	movl	24(%ebp), %eax
	movl	%eax, -88(%ebp)         ## 4-byte Spill
	movl	20(%ebp), %eax
	movl	%eax, -92(%ebp)         ## 4-byte Spill
	movl	-68(%ebp), %eax         ## 4-byte Reload
	movl	L_pool$non_lazy_ptr-L9$pb(%eax), %eax
	movw	%di, -14(%ebp)
	movw	%si, -16(%ebp)
	movw	%dx, -18(%ebp)
	movl	-92(%ebp), %esi         ## 4-byte Reload
	movl	%esi, -24(%ebp)
	movl	-88(%ebp), %esi         ## 4-byte Reload
	movl	%esi, -28(%ebp)
	movl	-84(%ebp), %esi         ## 4-byte Reload
	movl	%esi, -32(%ebp)
	movl	-80(%ebp), %esi         ## 4-byte Reload
	movl	%esi, -36(%ebp)
	movl	-76(%ebp), %esi         ## 4-byte Reload
	movl	%esi, -40(%ebp)
	movl	-72(%ebp), %esi         ## 4-byte Reload
	movl	%esi, -44(%ebp)
	movl	%ebx, -48(%ebp)
	movl	%ecx, -52(%ebp)
	movl	$0, -56(%ebp)
	movl	-68(%ebp), %ecx         ## 4-byte Reload
	movzbl	_current_task-L9$pb(%ecx), %ebx
	imull	$180, %ebx, %ebx
	addl	%ebx, %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	addl	$52, %eax
	movl	%eax, -64(%ebp)
	movw	-14(%ebp), %dx
	movl	-60(%ebp), %eax
	movw	%dx, 6(%eax)
	movw	-16(%ebp), %dx
	movl	-60(%ebp), %eax
	movw	%dx, 4(%eax)
	movw	-18(%ebp), %dx
	movl	-60(%ebp), %eax
	movw	%dx, 2(%eax)
	movl	-24(%ebp), %eax
	movl	-60(%ebp), %ebx
	movl	%eax, 40(%ebx)
	movl	-28(%ebp), %eax
	movl	-60(%ebp), %ebx
	movl	%eax, 36(%ebx)
	movl	-32(%ebp), %eax
	movl	-60(%ebp), %ebx
	movl	%eax, 12(%ebx)
	movl	-36(%ebp), %eax
	movl	-60(%ebp), %ebx
	movl	%eax, 16(%ebx)
	movl	-40(%ebp), %eax
	movl	-60(%ebp), %ebx
	movl	%eax, 24(%ebx)
	movl	-44(%ebp), %eax
	movl	-60(%ebp), %ebx
	movl	%eax, 32(%ebx)
	movl	-48(%ebp), %eax
	movl	-60(%ebp), %ebx
	movl	%eax, 28(%ebx)
	movl	-52(%ebp), %eax
	movl	-60(%ebp), %ebx
	movl	%eax, 20(%ebx)
	movl	-60(%ebp), %eax
	movl	8(%eax), %eax
	movl	-60(%ebp), %ebx
	subl	16(%ebx), %eax
	movl	%eax, -56(%ebp)
	movl	-56(%ebp), %eax
	addl	$3, %eax
	movl	%eax, -56(%ebp)
	cmpl	$128, -56(%ebp)
	jb	LBB9_2
## BB#1:
	movl	$128, -56(%ebp)
LBB9_2:
	movl	-56(%ebp), %ecx
	movl	-36(%ebp), %esi
	movl	-64(%ebp), %edi
	## InlineAsm Start
	cld
	rep
	movsb	(%esi), %es:(%edi)

	## InlineAsm End
	addl	$80, %esp
	popl	%esi
	popl	%edi
	popl	%ebx
	popl	%ebp
	retl

	.globl	_sleep
	.align	4, 0x90
_sleep:                                 ## @sleep
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$0, -8(%ebp)
LBB10_1:                                ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB10_3 Depth 2
	movl	-8(%ebp), %eax
	cmpl	-4(%ebp), %eax
	jge	LBB10_8
## BB#2:                                ##   in Loop: Header=BB10_1 Depth=1
	movl	$0, -12(%ebp)
LBB10_3:                                ##   Parent Loop BB10_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	cmpl	$1000, -12(%ebp)        ## imm = 0x3E8
	jae	LBB10_6
## BB#4:                                ##   in Loop: Header=BB10_3 Depth=2
	jmp	LBB10_5
LBB10_5:                                ##   in Loop: Header=BB10_3 Depth=2
	movl	-12(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -12(%ebp)
	jmp	LBB10_3
LBB10_6:                                ##   in Loop: Header=BB10_1 Depth=1
	jmp	LBB10_7
LBB10_7:                                ##   in Loop: Header=BB10_1 Depth=1
	movl	-8(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -8(%ebp)
	jmp	LBB10_1
LBB10_8:
	addl	$12, %esp
	popl	%ebp
	retl

	.globl	_dispchar
	.align	4, 0x90
_dispchar:                              ## @dispchar
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%eax
	movb	8(%ebp), %al
	movb	%al, -5(%ebp)
	movsbl	-5(%ebp), %ecx
	cmpl	$10, %ecx
	jne	LBB11_2
## BB#1:
	calll	_newlinecursor
	jmp	LBB11_3
LBB11_2:
	movb	-5(%ebp), %al
	movb	%al, -6(%ebp)           ## 1-byte Spill
	movb	-6(%ebp), %dl           ## 1-byte Reload
	## InlineAsm Start
	movb	$9, %ah
	movb	$0, %bh
	movb	$15, %bl
	movw	$1, %cx
	movb	%dl, %al
	int	$16

	## InlineAsm End
	calll	_setnextcursor
LBB11_3:
	addl	$4, %esp
	popl	%ebx
	popl	%ebp
	retl

	.globl	_scroll
	.align	4, 0x90
_scroll:                                ## @scroll
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%eax
	movb	8(%ebp), %al
	movb	%al, -5(%ebp)
	movb	$25, -6(%ebp)
	movb	-5(%ebp), %al
	movb	%al, -7(%ebp)
	movb	-7(%ebp), %bl
	## InlineAsm Start
	movw	$0, %cx
	movb	$25, %dh
	movb	$80, %dl
	movb	$6, %ah
	movb	%bl, %al
	int	$16

	## InlineAsm End
	addl	$4, %esp
	popl	%ebx
	popl	%ebp
	retl

	.globl	_clear
	.align	4, 0x90
_clear:                                 ## @clear
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	xorl	%eax, %eax
	movl	$0, (%esp)
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	calll	_scroll
	addl	$8, %esp
	popl	%ebp
	retl

	.globl	_resetcursor
	.align	4, 0x90
_resetcursor:                           ## @resetcursor
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	xorl	%eax, %eax
	movl	$0, (%esp)
	movl	$0, 4(%esp)
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	calll	_setcursor
	addl	$24, %esp
	popl	%ebp
	retl

	.globl	_newlinecursor
	.align	4, 0x90
_newlinecursor:                         ## @newlinecursor
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	calll	L15$pb
L15$pb:
	popl	%eax
	movzbl	_tty_current_row-L15$pb(%eax), %ecx
	cmpl	$24, %ecx
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	jl	LBB15_2
## BB#1:
	movl	$1, %eax
	movl	$1, (%esp)
	movl	%eax, -8(%ebp)          ## 4-byte Spill
	calll	_scroll
	movl	-4(%ebp), %eax          ## 4-byte Reload
	movb	$24, _tty_current_row-L15$pb(%eax)
	movb	$0, _tty_current_col-L15$pb(%eax)
	jmp	LBB15_3
LBB15_2:
	movl	-4(%ebp), %eax          ## 4-byte Reload
	movb	_tty_current_row-L15$pb(%eax), %cl
	addb	$1, %cl
	movb	%cl, _tty_current_row-L15$pb(%eax)
	movb	$0, _tty_current_col-L15$pb(%eax)
LBB15_3:
	movl	-4(%ebp), %eax          ## 4-byte Reload
	movb	_tty_current_row-L15$pb(%eax), %cl
	movzbl	%cl, %edx
	movl	%edx, (%esp)
	movzbl	_tty_current_col-L15$pb(%eax), %edx
	movl	%edx, 4(%esp)
	calll	_setcursor
	addl	$24, %esp
	popl	%ebp
	retl

	.globl	_setnextcursor
	.align	4, 0x90
_setnextcursor:                         ## @setnextcursor
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	calll	L16$pb
L16$pb:
	popl	%eax
	movzbl	_tty_current_col-L16$pb(%eax), %ecx
	cmpl	$79, %ecx
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	jl	LBB16_2
## BB#1:
	movl	-4(%ebp), %eax          ## 4-byte Reload
	movb	_tty_current_row-L16$pb(%eax), %cl
	addb	$1, %cl
	movb	%cl, _tty_current_row-L16$pb(%eax)
	movb	$0, _tty_current_col-L16$pb(%eax)
	jmp	LBB16_3
LBB16_2:
	movl	-4(%ebp), %eax          ## 4-byte Reload
	movb	_tty_current_col-L16$pb(%eax), %cl
	addb	$1, %cl
	movb	%cl, _tty_current_col-L16$pb(%eax)
LBB16_3:
	movl	-4(%ebp), %eax          ## 4-byte Reload
	movzbl	_tty_current_row-L16$pb(%eax), %ecx
	cmpl	$25, %ecx
	jl	LBB16_5
## BB#4:
	movl	$1, %eax
	movl	-4(%ebp), %ecx          ## 4-byte Reload
	movb	$24, _tty_current_row-L16$pb(%ecx)
	movl	$1, (%esp)
	movl	%eax, -8(%ebp)          ## 4-byte Spill
	calll	_scroll
LBB16_5:
	movl	-4(%ebp), %eax          ## 4-byte Reload
	movb	_tty_current_row-L16$pb(%eax), %cl
	movzbl	%cl, %edx
	movl	%edx, (%esp)
	movzbl	_tty_current_col-L16$pb(%eax), %edx
	movl	%edx, 4(%esp)
	calll	_s_setcursor
	addl	$24, %esp
	popl	%ebp
	retl

	.globl	_s_setcursor
	.align	4, 0x90
_s_setcursor:                           ## @s_setcursor
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%esi
	subl	$12, %esp
	calll	L17$pb
L17$pb:
	popl	%eax
	movb	12(%ebp), %cl
	movb	8(%ebp), %dl
	movb	%dl, -9(%ebp)
	movb	%cl, -10(%ebp)
	movb	-9(%ebp), %cl
	movb	-10(%ebp), %dl
	movl	%eax, -16(%ebp)         ## 4-byte Spill
	movb	%dl, -17(%ebp)          ## 1-byte Spill
	movb	-17(%ebp), %ch          ## 1-byte Reload
	## InlineAsm Start
	movb	$2, %ah
	movb	$0, %bh
	movb	%cl, %dh
	movb	%ch, %dl
	int	$16
	## InlineAsm End
	movb	-9(%ebp), %cl
	movl	-16(%ebp), %esi         ## 4-byte Reload
	movb	%cl, _tty_current_row-L17$pb(%esi)
	movb	-10(%ebp), %cl
	movb	%cl, _tty_current_col-L17$pb(%esi)
	addl	$12, %esp
	popl	%esi
	popl	%ebx
	popl	%ebp
	retl

	.globl	_s_dispchar
	.align	4, 0x90
_s_dispchar:                            ## @s_dispchar
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movb	8(%ebp), %al
	movb	%al, -1(%ebp)
	## InlineAsm Start
	cli

	## InlineAsm End
	movsbl	-1(%ebp), %ecx
	movl	%ecx, (%esp)
	calll	_dispchar
	## InlineAsm Start
	sti

	## InlineAsm End
	addl	$8, %esp
	popl	%ebp
	retl

	.globl	_len
	.align	4, 0x90
_len:                                   ## @len
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$0, -8(%ebp)
LBB19_1:                                ## =>This Inner Loop Header: Depth=1
	movl	-8(%ebp), %eax
	movl	-4(%ebp), %ecx
	movsbl	(%ecx,%eax), %eax
	cmpl	$0, %eax
	je	LBB19_3
## BB#2:                                ##   in Loop: Header=BB19_1 Depth=1
	movl	-8(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -8(%ebp)
	jmp	LBB19_1
LBB19_3:
	movl	-8(%ebp), %eax
	addl	$8, %esp
	popl	%ebp
	retl

	.globl	_print
	.align	4, 0x90
_print:                                 ## @print
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	calll	_len
	movl	%eax, -8(%ebp)
	movl	$0, -12(%ebp)
LBB20_1:                                ## =>This Inner Loop Header: Depth=1
	movl	-12(%ebp), %eax
	cmpl	-8(%ebp), %eax
	jge	LBB20_4
## BB#2:                                ##   in Loop: Header=BB20_1 Depth=1
	movl	-12(%ebp), %eax
	movl	-4(%ebp), %ecx
	movsbl	(%ecx,%eax), %eax
	movl	%eax, (%esp)
	calll	_dispchar
## BB#3:                                ##   in Loop: Header=BB20_1 Depth=1
	movl	-12(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -12(%ebp)
	jmp	LBB20_1
LBB20_4:
	addl	$24, %esp
	popl	%ebp
	retl

	.globl	_current_task           ## @current_task
.zerofill __DATA,__common,_current_task,1,0
	.globl	_tty_current_row        ## @tty_current_row
.zerofill __DATA,__common,_tty_current_row,1,0
	.globl	_tty_current_col        ## @tty_current_col
.zerofill __DATA,__common,_tty_current_col,1,0
	.comm	_pool,360,2             ## @pool
	.comm	_taskbuffer,180,2       ## @taskbuffer

	.section	__IMPORT,__pointers,non_lazy_symbol_pointers
L_pool$non_lazy_ptr:
	.indirect_symbol	_pool
	.long	0

.subsections_via_symbols
