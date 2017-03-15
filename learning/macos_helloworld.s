.text

.macosx_version_min 10, 11
.global _main
.global start


ST:
    .ascii "Hello World\12\0"

_main:
pushl %ebp
movl %esp,%ebp
subl $8,%esp
movl $ST,%eax
movl $ST,(%esp)
calll _printf
movl $0,%eax
movl %ebp,%esp
popl %ebp
retl

start:
calll _main
retl 
