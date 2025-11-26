BITS 16
CPU 386


START:
	mov ax, 0x07C0
	mov ds, ax
	mov ax, 0x0050
	mov es, ax
	cli
	mov si, START
	mov di, START
	mov cx, 0x200
	cld
	rep movsb
	mov ax, 0x0050
	mov ds, ax
	mov sp, 0x1000
	sti
	jmp 0x0050:LOAD_STAGE2


LOAD_STAGE2:
	mov byte [BOOTDISKNUM], dl
	mov ax, 0x0207
	mov cx, 0x0002
	mov dh, 0x00
	mov bx, 0x0100
	mov es, bx
	xor bx, bx
	int 0x13
	jc PRINT_ERROR
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	jmp 0x0000:0x1000


PRINT_ERROR:
	mov si, ERROR_READ
	mov cx, _ERROR_READ-ERROR_READ
	mov ah, 0x0E
	.loop:
		lodsb 
		int 0x10
		loop .loop
	jmp $

	

BOOTDISKNUM: db 0x00

ERROR_READ: db "Boot process failed - disk read error."
_ERROR_READ:

times 446-($-$$) db 0x00
