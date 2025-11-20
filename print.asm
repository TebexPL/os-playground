PRINT_NL:
	push ax
	mov ax, 0x0E0A
	int 0x10
	mov al, 0x0D
	int 0x10
	pop ax
	ret

PRINT_D:
	push edx
	push ebx
	push ecx
	xor edx, edx
	mov ebx, 0x0000000A
	xor ecx, ecx
	.div_loop:
		div ebx
		cmp edx, 0x00000000
		jne .continue 
		cmp eax, 0x00000000
		je .print_loop
		.continue:
		xchg edx, eax
		add al, '0'
		mov ah, 0x0E
		inc cx
		push ax
		xor eax, eax
		xchg edx, eax
		jmp .div_loop
	.print_loop:
	pop ax
	int 0x10
	loop .print_loop
	pop ecx
	pop ebx
	pop edx
	ret

PRINT_BD:
	push eax
	xor eax, eax
	mov al, cl
	call PRINT_D
	pop eax
	ret

PRINT_WD:
	push eax
	xor eax, eax
	mov ax, cx
	call PRINT_D
	pop eax
	ret
	
PRINT_DD:
	push eax
	xor eax, eax
	mov eax, ecx
	call PRINT_D
	pop eax
	ret

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

_PRINT_DX:
	ror ecx, 0x10
	call _PRINT_WX
	ror ecx, 0x10
	call _PRINT_WX
	ret
	
PRINT_DX:
	push ax
	mov ax, 0x0E30
	int 0x10
	mov al, 'x'
	int 0x10
	call _PRINT_DX
	pop ax
	ret



PRINT_STRN:
	push ax
	push cx
	push si
	mov ah, 0x0E
	.loop:
		lodsb
		int 0x10
		loop .loop
	pop si
	pop cx
	pop ax
	ret

PRINT_STR:
	push ax
	push si
	mov ah, 0x0E
	.loop:
		lodsb
		cmp al, 0x00
		je .end
		int 0x10
		jmp .loop
	.end:
	pop si
	pop ax
	ret
