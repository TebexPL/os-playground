

section .text

	function putchar
		cdecl_entry
			mov eax, cdecl_param(0)
			mov ah, 0x0E
			int 0x10
		cdecl_exit
	
	function puts
		cdecl_entry
			mov ebx, cdecl_param(0)
			mov ah, 0x0E
			.loop:
				mov al, byte [ebx]
				cmp al, 0x00
				je .end
				int 0x10
				inc ebx
				jmp .loop
			.end:
		cdecl_exit

	function getchar
		cdecl_entry
			xor eax,eax
			int 0x16
			xor ah,ah
		cdecl_exit


	_PRINTX:
		add al, '0'
		cmp al, '9'
		jbe .print
		add al, 0x07
		.print:
		int 0x10 
		ret

	_PRINTBX:
		mov al, cl
		shr al, 0x04
		call _PRINTX
		mov al, cl
		and al, 0x0F
		call _PRINTX
		ret

	function printBX
	cdecl_entry
	mov ax, 0x0E30
	int 0x10
	mov al, 'x'
	int 0x10
	mov ecx, cdecl_param(0)
	call _PRINTBX
	cdecl_exit
