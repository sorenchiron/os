org 07c00h

mov ax, cs
mov ds, ax
mov es, ax
;; set interrupt
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
cld
call ClearS
call hdread
jmp dword BOOTS ;0x07e0:0x0000 
sti
jmp $

hdread:
push ebp
push esp
push ebx
mov ah,0
mov dl,0
int 13h
;cmp ah,0
;jnz hdread ;; force reset
mov ax,0x7e0
mov es,ax
mov bx,0

mov ah,02h
mov al,1 ;blocks
mov ch,0 ;cylinder
mov cl,1 ;sector
mov dh,0 ;head
mov dl,0 ;ata0
;les bx,[BOOTS]
int 13h
pop ebx
pop esp
pop ebp
; jc hdread
ret

main1:
main1lp
mov al,41h ;'A'
call Sprintal
jmp main1lp
ret

main2:
main2lp
mov al,42h ;'B'
call Sprintal
jmp main2lp
ret

foo:
push ebp
mov ebp,esp
push eax
push edx
push ecx
mov ax,[SCHED_SAVE]

cmp ax,0
jnz .state0end
.state0 ;;no task is loaded
lea eax,[main1]
mov word [dword ebp+16],ax
mov ax,1
jmp .savestate
.state0end

cmp ax,1
jnz .state1end
.state1 ;;task 1 is interrupted, task2 not loded
lea esi, [dword ebp+4]
lea edi, [TASK1]
mov ecx, 18
rep movsb
lea eax,[main2]
mov word [dword ebp+16],ax
mov ax,2
jmp .savestate
.state1end

cmp ax,2
jnz .state2end
.state2 ;;task 1 is saved, task 2 is interrupted
lea esi, [dword ebp+4]
lea edi, [TASK2]
mov ecx, 18
rep movsb
lea esi, [TASK1]
lea edi, [dword ebp+4]
mov ecx, 18
rep movsb
mov ax, 3
jmp .savestate
.state2end

cmp ax,3
jnz .state3end
.state3 ;;task 2 is saved, task 1 is interrupted
lea esi, [dword ebp+4]
lea edi, [TASK1]
mov ecx, 18
rep movsb
lea esi, [TASK2]
lea edi, [dword ebp+4]
mov ecx, 18
rep movsb
mov ax, 2
.state3end

.savestate
mov [SCHED_SAVE],ax
pop ecx
pop edx
pop eax
pop ebp
iret

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

Sprintal: 
;; put ascii code in AL to print
;; safe to other regs
cli
push dx
mov  dx,[DX_SAVE]
call SetCursor
call DispAL
call cursor_deal
mov [DX_SAVE],dx
pop dx
sti
ret

;Str1  db  "Hello, world!"
;Str1len equ $ - Str1
CRT_ROW db 24
DX_SAVE dw 0
SCHED_SAVE dw 0
TASK1 times 18 db 0
TASK2 times 18 db 0
BOOTS dd 0x07e00000
times 510-($-$$) db 0
dw 0xaa55
