org 07c00h
mov ax, cs
mov ds, ax
mov es, ax
call    DispStr
jmp $
DispStr:
mov ah, 02h
mov bh, 0
mov dh, 4h
mov dl, 4h
int 10h
mov ax, Str
mov bp, ax
mov cx, 13
mov ax, 01301h
mov bx, 000ch
mov dl, 0
int 10h
ret
Str:  db  "Hello, world!"
times   510-($-$$)   db  0   
dw  0xaa55
