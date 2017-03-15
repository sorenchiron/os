cli
cli
mov ax,cs
mov ds,ax
mov es,ax

call ClearS
call ResetCursor
mov al,43h ;'C'
call DispAL
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
mov dh,[CRT_ROW]
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


DispChar: ;;display A by default
mov al,41h ;;'A'
DispAL: ;; put ascii hex into al to print char
push ebp
push esp
push ax
push bx
push cx
mov ah,09h
mov bh,0
mov bl,0fh
mov cx,1
int 10h
pop cx
pop bx
pop ax
pop esp
pop ebp
ret

cursor_deal:
;; deal with dh,dl
;; safe to other regs
push ax
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
pop ax
ret

CRT_ROW db 24
DX_SAVE dw 0
SCHED_SAVE dw 0

times 510-($-$$) db 0
dw 0xaa55
