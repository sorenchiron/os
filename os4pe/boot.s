%include	"pm.inc"	

org	07e00h
jmp	LABEL_BEGIN

[SECTION .gdt]
; GDT
;0x7c04
LABEL_GDT:	   Descriptor	    0,		      0,            0	
LABEL_DESC_CODE32: Descriptor       0, SegCode32Len - 1, DA_C + DA_32
LABEL_DESC_VIDEO:  Descriptor 0B8000h,           0ffffh, DA_DRW	     
; GDT finished

GdtLen		equ	$ - LABEL_GDT	
GdtPtr		dw	GdtLen - 1	
		dd	0	

; GDT Selector
SelectorCode32		equ	LABEL_DESC_CODE32 - LABEL_GDT
SelectorVideo		equ	LABEL_DESC_VIDEO  - LABEL_GDT
; END of [SECTION .gdt]


; IDT
[SECTION .idt]
ALIGN	32
[BITS	32]
LABEL_IDT:	;0x00007c40
.00h:		Gate	SelectorCode32,    ClockHandler,      0, DA_386IGate
.01h:		Gate	SelectorCode32,  UserIntHandler,      0, DA_386IGate 

IdtLen		equ	$ - LABEL_IDT
IdtPtr		dw	IdtLen - 1	
		dd	0		
; END of [SECTION .idt]

[SECTION .s16]
[BITS	16]
LABEL_BEGIN:	;0x00007c58
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax
	mov	sp, 0100h

	xor	eax, eax
	mov	ax, cs
	shl	eax, 4
	add	eax, LABEL_SEG_CODE32
	mov	word [LABEL_DESC_CODE32 + 2], ax
	shr	eax, 16
	mov	byte [LABEL_DESC_CODE32 + 4], al
	mov	byte [LABEL_DESC_CODE32 + 7], ah

	xor	eax, eax
	mov	ax, ds
	shl	eax, 4
	add	eax, LABEL_GDT	
	mov	dword [GdtPtr + 2], eax	

	xor	eax, eax
	mov	ax, ds
	shl	eax, 4
	add	eax, LABEL_IDT		
	mov	dword [IdtPtr + 2], eax	 

	lgdt	[GdtPtr]
	
	cli
		
	lidt	[IdtPtr]
	
	;;A20 4G

	in	al, 92h
	or	al, 00000010b
	out	92h, al

	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax

	jmp	dword SelectorCode32:0
; END of [SECTION .s16]


[SECTION .s32]
[BITS	32]

LABEL_SEG_CODE32:	;0x00007ccc
	mov	ax, SelectorVideo
	mov	gs, ax			
	call	Init8259A	
	sti
	jmp	$
	
main1:	
	cmp 	sp, 0x0100
	je	Normal1
	pop	eax
Normal1:
	mov 	word [CHAR], 0942h ;'B'
	call 	_UserIntHandler
	jmp 	main1

main2:	
	cmp 	sp, 0x0100
	je	Normal2
	pop	eax
Normal2:
	mov 	word [CHAR], 0c41h ;'A'
	call 	_UserIntHandler
	jmp 	main2
Init8259A:	;0x00007cdc
	mov	al, 011h 
	out	020h, al	;ICW1
	call	io_delay

	out	0A0h, al	
	call	io_delay

	mov	al, 00h		; IRQ0:0x00
	out	021h, al	; ICW2
	call	io_delay

	mov	al, 08h		; IRQ8:0x08
	out	0A1h, al	; ICW2
	call	io_delay

	mov	al, 004h	; IR2:sub-8259 
	out	021h, al	; ICW3
	call	io_delay

	mov	al, 002h	; host-8259:IR2
	out	0A1h, al	; ICW3
	call	io_delay

	mov	al, 001h 	
	out	021h, al	; ICW4
	call	io_delay

	out	0A1h, al	; ICW4
	call	io_delay

	;mov	al, 11111111b	 
	mov	al, 11111110b	
	out	021h, al	; OCW1
	call	io_delay

	mov	al, 11111111b	
	out	0A1h, al	; OCW1
	call	io_delay

	ret
; Init8259A 
io_delay:	;0x7d51
	nop
	nop
	nop
	nop
	ret

; int handler 
_ClockHandler:	;0x7d3b
ClockHandler	equ	_ClockHandler - $$
	;call	io_delay
	push 	ebp
	mov 	ebp ,esp	
	push 	eax
	push 	edx
	push 	ecx
	mov 	ax, [SCHED_SAVE]

	cmp 	ax, 0
	jnz 	state0end
	lea 	eax, [main1]
	sub 	ax, 0x7ecc
	mov 	word [dword ebp+4], ax
	mov 	ax, 1
	jmp 	savestate
	;jmp $	;0x7d79
state0end:
	cmp 	ax, 1
	jnz 	savestate
	lea 	eax, [main2]
	sub 	ax, 0x7ecc	
	mov 	word [dword ebp+4], ax
	mov 	ax, 0
	jmp 	savestate

savestate:
	mov 	[SCHED_SAVE],ax
	pop	ecx
	pop 	edx
	pop 	eax
	pop 	ebp
	mov	al, 20h
	out	20h, al				;EOI
	iretd  

_UserIntHandler:
UserIntHandler	equ	_UserIntHandler - $$
	mov 	ax, 0
	mov 	bx, 0
	mov	al, 80	
	cmp	dl, 80
	jb	CheckRow
	mov	dl, 0
	inc 	dh
CheckRow:
	cmp	dh, 25
	jb 	DispAL
	mov	dh, 0
DispAL:
	mul	dh
	mov	bl, dl
	add	ax, bx	
	mov 	di, ax
	mov	ax, 2
	mov 	bx, dx
	mul	di
	mov	dx, bx
	mov 	di, ax
	mov	ax, word [CHAR]
	mov	[gs:di], ax
	inc 	dl
	ret

SCHED_SAVE	dw 	0
CHAR		dw     	0942h
 
SegCode32Len	equ	$ - LABEL_SEG_CODE32
; END of [SECTION .s32]
