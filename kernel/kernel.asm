BITS 32

extern main

section .entry

global start
start:
xchg bx,bx
call main
jmp $
