org 07c00h
mov ax, cs
mov ds, ax
mov es, ax
;; set interrupt
sti
push ax
mov al,0x04
mov ah, 0x1c
mul ah ;; ax=1ch*4
lea dx,[foo]
mov di,ax ;;di=1ch*4
pop ax ;;ax=CS
mov [di],dx ;;put foo IP
add di,2
mov [di],ax ;;put foo CS
;; INT 
call ClearS
mov dx,0
call DispStr
mov dx,0x0101
call DispStr
mov al,1
call ScrollS
mov dx,0x0102
call DispStr

jmp $

ClearS:       ; clear screen 
mov al,0h
ScrollS:      ; al=lines up, when al=0, clear!
push ebp      ; clear will destory ebp
push esp
push dx
mov ah,06h
mov cx,0h
mov dh,[CRT_ROW]
mov dl,80
int 10h
pop dx
pop esp
pop ebp
ret

ResetCursor:
mov dx,0
SetCursor:
; set cursor pos
; row=dh col=dl
push ebp
push esp
mov ah, 02h
mov bh, 0 ;; page no
int 10h
pop esp
pop ebp
ret

DispStr:
; bp=str
; cx=len(str)
; dh=row dl=col
lea ax, [Str1]
mov bp, ax
mov cx, Str1len
mov ax, 1301h
mov bx, 000fh
int 10h
ret

DispChar:
push ebp
push esp
mov ah,09h
mov al,41h ;;'A'
mov bh,0
mov bl,0fh
mov cx,1
int 10h
pop esp
pop ebp
ret

foo:
push dx
mov  dx,[DX_SAVE]
call SetCursor
call DispChar
call cursor_deal
mov [DX_SAVE],dx
pop dx
iret

cursor_deal:
cmp dl,80
jb CD_COLS_GOOD
;; if col is too large
mov dl,0 ;reset col
inc dh ;dh++
jmp CD_ROWS_DEAL
CD_COLS_GOOD
inc dl ;dl++
CD_ROWS_DEAL
cmp dh,[CRT_ROW]
jbe CD_ROWS_GOOD
mov al,1
call ScrollS
mov dh,[CRT_ROW] ;;if row>ROW, fix row=ROW
CD_ROWS_GOOD
ret

times 16 db 0

Str1  db  "Hello, world!"
Str1len equ $ - Str1
Chi  db  "0"
Chi2 db  "0"
CRT_ROW db 24
DX_SAVE dw 0x0000
times   510-($-$$)   db  0
dw  0xaa55
