BITS 16
section .entry


extern main
global start
start:
xchg bx,bx
call 0x0000:main
jmp $
