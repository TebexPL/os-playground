BITS 16
CPU 386


START:
	mov ax, 0x07C0
	mov ds, ax
	mov ax, 0x0050
	mov es, ax
	cli
	xchg bx,bx	
	call TEST_A20
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
	mov ax, 0x021F
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


TEST_A20:
	push 0x0000
	pop fs
	push 0xFFFF
	pop gs
	push word[fs:0x0500]
	push word[gs:0x0510]
	mov word[fs:0x0500], ax
	not ax
	mov word[gs:0x0510], ax
	cmp word[fs:0x0500], ax
	pop word[gs:0x0510]
	pop word[fs:0x0500]
	je .eq
	.neq:
		stc
		ret

	.eq:
		clc
		ret
	

BOOTDISKNUM: db 0x00

ERROR_READ: db "Boot process failed - disk read error."
_ERROR_READ:

times 446-($-$$) db 0x00
