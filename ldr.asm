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
	;decimal print
	mov cl, 0x12
	call PRINT_BX
	call PRINT_NL
	mov cx, 0x1234
	call PRINT_WX
	call PRINT_NL
	mov ecx, 0x12345678
	call PRINT_DX
	call PRINT_NL

	;hex print
	mov cl, 123
	call PRINT_BD
	call PRINT_NL
	mov cx, 12345
	call PRINT_WD
	call PRINT_NL
	mov ecx, 1234567890
	call PRINT_DD
	call PRINT_NL

	;print with length
	mov si, EXAMPLE.msg
	mov cx, word [EXAMPLE.len]
	call PRINT_STRN
	call PRINT_NL
	
	;print zero terminated
	call PRINT_STR
	call PRINT_NL
	
	jmp $


PRINT_ERROR:
	mov si, READ_ERROR.msg
	call PRINT_STR
	jmp $

	
%include "print.asm"

BOOTDISKNUM: db 0x00

EXAMPLE:
	.msg: db "Test message", 0x00
	.len: dw $-.msg-1

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
