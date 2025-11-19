START:
	mov ax, 0x07C0
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	xor ax, ax
	cli
	mov ss, ax
	sti
	jmp 0x07C0:LOAD_STAGE2


LOAD_STAGE2:
	mov byte [BOOTDISKNUM], dl
	mov ax, 0x0207
	mov cx, 0x0002
	mov dh, 0x00
	mov bx, 0x07E0
	mov es, bx
	xor bx, bx
	int 0x13
	mov si, READ_ERROR.msg
	mov cx, READ_ERROR.len
	jc PRINT_ERROR
PARSE_MBR:

	mov ecx, 0x6AB969CD
	call PRINT_DX
	
	jmp $


BOOTDISKNUM: db 0x00

PRINT_X:
	cmp al, 0x0A
	jae .l
	add al, '0'
	jmp .print

	.l:
	add al, 0x37
	.print:
	int 0x10 
	ret

_PRINT_BX:
	mov al, cl
	shr al, 0x04
	call PRINT_X
	mov al, cl
	and al, 0x0F
	call PRINT_X
	ret

PRINT_BX:
	push ax
	mov ax, 0x0E30
	int 0x10
	mov al, 'x'
	int 0x10
	call _PRINT_BX
	pop ax
	ret

_PRINT_WX:
	xchg ch, cl
	call _PRINT_BX
	xchg ch, cl
	call _PRINT_BX
	ret 
	
PRINT_WX:
	push ax
	mov ax, 0x0E30
	int 0x10
	mov al, 'x'
	int 0x10
	call _PRINT_WX
	pop ax
	ret

PRINT_DX:
	push ax
	mov ax, 0x0E30
	int 0x10
	mov al, 'x'
	int 0x10
	ror ecx, 0x10
	call _PRINT_WX
	ror ecx, 0x10
	call _PRINT_WX
	pop ax
	ret

PRINT_ERROR:
	mov ah, 0x0E
	.loop:
		lodsb
		int 0x10
		loop .loop
	cli
	jmp $


READ_ERROR:
	.msg: db "Disk error..."
	.len: dw $-.msg

times 446-($-$$) db 0x00
MBR:

times 512-($-$$) db 0x00


;GET_DISK_INFO:
;	mov byte [BOOTDISK], dl
;	mov ah, 0x08
;	push 0x0000
;	pop es
;	mov di, 0x0000
;	int 0x13
;	push cx
;	mov si, READ_PARAM_ERROR.msg
;	mov cx, word [READ_PARAM_ERROR.msglen]
;	jc PRINT_ERROR
;	pop cx
;	mov ax, 0x003F
;	and ax, cx
;	mov byte [BOOTDISK.SMAX], al
;	shr cl, 0x06
;	ror cx, 0x08
;	mov word [BOOTDISK.CMAX], cx
;	mov byte [BOOTDISK.HMAX], dh
;READ_FULL_LDR:
;	
;	
;	jmp $
;
;READ_PARAM_ERROR:
;	.msg: db 'Cannot read disk parameters', 0x0A, 0x0D
;	.msglen: dw $-.msg
;BOOTDISK:
;	.CMAX: dw 0x0000
;	.HMAX: db 0x00
;	.SMAX: db 0x00
;
times 4096-($-$$) db 0x55
