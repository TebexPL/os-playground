

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


