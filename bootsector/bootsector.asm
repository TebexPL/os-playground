BITS 16
CPU 386

%define START_SEGMENT 0x07C0
%define SECTOR_SIZE 0x0200
%define STAGE2_SEGMENT 0xFFFF
%define STAGE2_OFFSET 0x0010

%macro outbyte 2 
	call write_wait
	mov al, %1
	out %2, al
%endmacro


START:
	cli
	mov ax, START_SEGMENT
	mov ds, ax
	xor ax, ax 
	mov fs, ax
	not ax
	mov gs, ax
	call A20_TEST
		jnz LOAD_STAGE2
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
	call A20_TEST
		jnz LOAD_STAGE2
	A20_KBD:
		outbyte 0xAD, 0x64
		outbyte 0xD0, 0x64
		.read_wait:
			in al, 0x64
			test al, 0x01
			jz .read_wait
		in al, 0x60
		mov bl, al
		or bl, 0x02
		outbyte 0xD1, 0x64
		outbyte bl, 0x60
		outbyte 0xAE, 0x64
	call A20_WAIT
	call A20_TEST
		jnz LOAD_STAGE2
	A20_FAST:
		in al, 0x92
		test al, 0x02
		jnz .end

		or al, 0x02
		and al, 0xFE
		out 0x92, al 
		.end:
	call A20_WAIT
	call A20_TEST
		mov si, ERROR_A20
		mov cx, _ERROR_A20-ERROR_A20
		jz PRINT_ERROR

LOAD_STAGE2:	
	sti
	mov ax, 0x023F
	mov cx, 0x0002
	mov dh, 0x00
	push STAGE2_SEGMENT
	pop es
	mov bx, STAGE2_OFFSET
	int 0x13
	mov si, ERROR_READ
	mov cx, _ERROR_READ-ERROR_READ
	jc PRINT_ERROR
	cli
	mov ax, STAGE2_SEGMENT
	mov ss, ax
	mov ds, ax
	mov ax, 0xFFFE
	mov sp, ax
	sti
	jmp STAGE2_SEGMENT:STAGE2_OFFSET


PRINT_ERROR:
	sti
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

write_wait:
	in al, 0x64
	test al, 0x02
	jnz write_wait
	ret


A20_TEST:
	xor ax,ax
	mov word[fs:0x0500], ax
	not ax
	mov word[gs:0x0510], ax
	cmp word[fs:0x0500], ax
	ret
	

ERROR_READ: db "Boot media error."
_ERROR_READ:

ERROR_A20: db "A20 error."
_ERROR_A20:

times 446-($-$$) db 0x00
