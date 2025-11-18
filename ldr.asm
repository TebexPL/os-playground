cli
mov ax, 0x07C0
mov ds, ax
sti
mov ax, 0x0E21
int 0x10
jmp $


times 512-($-$$) db 0xAA
times 4096-($-$$) db 0x55
