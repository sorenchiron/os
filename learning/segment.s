;; Experiment on segment-addressing
;; Result is a Success!
;; Conclusion: linear_addr = ss*0xf+esp

org 07c00h
mov ax,cs
mov ds,ax
mov es,ax
;; By the time 7c00 is called, esp is already used upto 0xffd6.
;; Ebp is initialized as 0x0, and is not changed till now.
;; ax is stack segment most significant 16b: 0x04
mov ax,4
mov ss,ax
;; ss=0x0004 now, ebp=0, esp=ffd4
inc ebp
push 0xeeaa
;; esp=esp-2=ffd2
;; ss*0xf+esp=0x40+0xffd4=0x10014
;; eeaa is found at physical 0x10014!
jmp $
times 510-($-$$) db 0
dw 0xaa55
