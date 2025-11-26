BITS 16
CPU 386

extern main

section .entry

global start
start:
xchg bx,bx
call dword main
jmp $
