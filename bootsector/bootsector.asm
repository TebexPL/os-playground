BITS 16
CPU 386


START:
	mov ax, 0x07C0
	mov ds, ax
	mov ax, 0x0050
	mov es, ax
	cli
	call A20_TEST
		jc .open
	call A20_BIOS
	call A20_TEST
		jc .open
	call A20_KBD
	call A20_WAIT
	call A20_TEST
		jc .open
	call A20_FAST
	call A20_WAIT
	call A20_TEST
		mov si, ERROR_A20
		mov cx, _ERROR_A20-ERROR_A20
		jnc PRINT_ERROR
	.open:
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
	mov si, ERROR_READ
	mov cx, _ERROR_READ-ERROR_READ
	jc PRINT_ERROR
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	jmp 0x0000:0x1000


PRINT_ERROR:
	mov ah, 0x0E
	.loop:
		lodsb 
		int 0x10
		loop .loop
	jmp $

A20_WAIT:
	xor ax, ax
	.loop:
	inc ax
	jnz .loop
	ret



A20_BIOS:
	mov ax, 0x2403
	int 0x15
	jc .end
	cmp ah, 0x00
	jnz .end
	mov ax, 0x2402
	int 0x15
	jc .end
	cmp ah, 0x00
	jnz .end
	mov ax, 0x2401
	int 0x15
	.end:
	ret

%macro outbyte 2 
	call .write_wait
	mov al, %1
	out %2, al
%endmacro

%macro inbyte 1
	call .read_wait
	in al, %1
%endmacro

	
A20_FAST:
	in al, 0x92
	test al, 0x02
	jnz .end

	or al, 0x02
	and al, 0xFE
	out 0x92, al 
	.end:
	ret

A20_KBD:
	outbyte 0xAD, 0x64
	outbyte 0xD0, 0x64
	inbyte 0x60
	mov bl, al
	or bl, 0x02
	outbyte 0xD1, 0x64
	outbyte bl, 0x60
	outbyte 0xAE, 0x64
	ret
.write_wait:
	in al, 0x64
	test al, 0x02
	jnz .write_wait
	ret
.read_wait:
	in al, 0x64
	test al, 0x01
	jz .read_wait
	ret

A20_TEST:
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

ERROR_READ: db "Boot media error."
_ERROR_READ:

ERROR_A20: db "A20 error."
_ERROR_A20:

times 446-($-$$) db 0x00
