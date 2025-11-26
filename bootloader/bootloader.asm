BITS 16
CPU 386

%define call call dword
%define ret o32 ret

extern main

section .entry

	global start
	start:
		call main
		jmp $



section .text

	global putchar
	putchar:
		push ebp
		mov ebp, esp
		mov eax, [ss:ebp+0x08]
		mov ah, 0x0E
		int 0x10
		pop ebp
		ret 
		
	global puts
	puts:
		push ebp
		mov ebp, esp
		mov ebx, [ss:ebp+0x08]
		mov ah, 0x0E
		.loop:
			mov al, [ebx]
			cmp al, 0x00
			je .end
			int 0x10
			inc ebx
			jmp .loop
		.end:
		pop ebp
		ret 

