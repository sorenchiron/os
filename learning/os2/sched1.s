org 07c00h

mov ax, cs
mov ds, ax
mov es, ax

cli
call ClearS
call ResetCursor
lea bp,[STRPROC]
mov cx,STRLEN
mov dx,0
call DispStr
call hdread                 ;make read ready first

;; set interrupt
mov al,0x04
mov ah,0x08                 ;int number
mul ah ; ax=08h*4
                            ;lea dx,[foo]
mov dx,0x0330               ;assign IP
mov di,ax                   ;di=8*4
mov [di],dx                 ;put foo IP
add di,2
mov ax,0x07e0               ;assign CS
mov [di],ax                 ;put foo CS

mov esi,0
mov edi,0

mov ax,0x07e0
mov ss,ax
mov esp,0xff00
mov ebp,esp
jmp dword 0x07e0:0x0000 
jmp $

hdread:
push ebp
push esp
push ebx
mov ah,0
mov dl,0
int 13h
; force reset
mov ax,0x07e0 ;segment
mov es,ax
mov bx,0      ;offset
mov ah,02h
mov al,0x08 ;blocks
mov ch,0 ;cylinder
mov cl,1 ;sector
mov dh,0 ;head
mov dl,0 ;ata0
int 13h
pop ebx
pop esp
pop ebp
ret


foo:
mov [SEBP],eax
mov al,0x20
out 0x20,al
pop ax ; ip
pop ax ; cs
popf   ; pop 16 bits flags
mov eax,[SEBP]
sti
jmp $


ClearS:       ; clear screen 
mov al,0h
ScrollS:      ; al=lines up, when al=0, clear!
;; destory AX! others safe
push ebp      ; clear will destory ebp
push esp
push ax
push cx
push dx
mov ah,06h
mov cx,0h
mov dh,25
mov dl,80
int 10h
pop dx
pop cx
pop ax
pop esp
pop ebp
ret

ResetCursor:
mov dx,0
SetCursor:
; set cursor pos
; row=dh col=dl
; safe except for dx
push ebp
push esp
push ax
push bx
mov ah, 02h
mov bh, 0 ;; page no
int 10h
pop bx
pop ax
pop esp
pop ebp
ret

DispStr:
; bp=str
; cx=len(str)
; dh=row dl=col
push ebp
push esp 
push ebx
mov ax, 1301h
mov bx, 000fh
int 10h
pop ebx
pop esp
pop ebp
ret

STRPROC  db  "Bootloader is loaded. Now loading mini kernel."
STRLEN equ ($ - STRPROC)
TASK1 dw 0,0
BOOTS dd 0x07e00000
SEBP dd 0
SESP dd 0
SIP dw 0
SCS dw 0
SFLAGS dw 0


times 510-($-$$) db 0
dw 0xaa55






;push ebp
;mov ebp,esp
;pusha
;mov [esp+12],ebp ;old esp
;mov eax,[ebp]  ;get old ebp
;mov [esp+8],eax ;save old ebp
;mov ax,[ebp+8] ;old flags
;push ax
;mov ax,[ebp+6] ;old cs
;push ax        ;save cs
;mov ax,[ebp+4] ;old ip
;push ax        ;save old ip
;call dword 0x07e0:0000
;
;mov al, 0x20
;out 0x20, al
;pop eax
;pop ebp
;cli
;iret