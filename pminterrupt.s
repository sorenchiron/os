%include	"pm.inc"	

jmp	LABEL_BEGIN

[SECTION .gdt]
; GDT

LABEL_GDT:	   Descriptor       0,                0, 0           
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
LABEL_IDT:
%rep 32               
		Gate	SelectorCode32, SpuriousHandler,      0, DA_386IGate
%endrep
.020h:		Gate	SelectorCode32,    ClockHandler,      0, DA_386IGate   
%rep 95
		Gate	SelectorCode32, SpuriousHandler,      0, DA_386IGate
%endrep
.080h:		Gate	SelectorCode32,  UserIntHandler,      0, DA_386IGate 

IdtLen		equ	$ - LABEL_IDT
IdtPtr		dw	IdtLen - 1	
		dd	0		
; END of [SECTION .idt]

[SECTION .s16]
[BITS	16]
LABEL_BEGIN:
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

LABEL_SEG_CODE32:
	mov	ax, SelectorVideo
	mov	gs, ax			
	call	Init8259A
	int	080h 
	sti 
	jmp	$ 
	
; Init8259A 
Init8259A:
	mov	al, 011h 
	out	020h, al	;ICW1
	call	io_delay

	out	0A0h, al	
	call	io_delay

	mov	al, 020h	; IRQ0:0x20
	out	021h, al	; ICW2
	call	io_delay

	mov	al, 028h	; IRQ8:0x28
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
io_delay:
	nop
	nop
	nop
	nop
	ret

; int handler 
_ClockHandler:
ClockHandler	equ	_ClockHandler - $$
	inc	byte [gs:((80 * 0 + 70) * 2)]	;0th row, 70th column
	mov	al, 20h
	out	20h, al				;EOI
	iretd  

_UserIntHandler:
UserIntHandler	equ	_UserIntHandler - $$
	mov	ah, 0Ch				
	; 0000:black bg  1100:red words
	mov	al, 'I'
	mov	[gs:((80 * 0 + 70) * 2)], ax
	iretd

_SpuriousHandler:
SpuriousHandler	equ	_SpuriousHandler - $$
	mov	ah, 0Ch				
	mov	al, '!'
	mov	[gs:((80 * 0 + 75) * 2)], ax
	jmp	$
	iretd
; 
SegCode32Len	equ	$ - LABEL_SEG_CODE32
; END of [SECTION .s32]
