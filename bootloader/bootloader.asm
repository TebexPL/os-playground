
extern main

section .entry

	global start
	start:
		[BITS 16]
		cli
		lgdt [GDTR]
		mov eax, cr0
		or eax, 1
		mov cr0, eax
		;jmp dword 0x08:(0xFFFF0+.protected32)
		jmp dword 0x08:(.protected32)
		[BITS 32]
		.protected32:
			mov ax, 0x0010
			mov ds, ax
			mov es, ax
			mov fs, ax
			mov gs, ax
			mov ss, ax
			;mov eax, esp
			;add eax, 0xFFFF0
			;mov esp, eax
			;lidt [IDTR+0xFFFF0]	
		lidt [IDTR]
		
		sti

		call main
		jmp $

	goto16:
	jmp dword 0x18:.protected16
	[BITS 16]
	.protected16:
	push eax
	mov ax, 0x0020
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	;mov eax, esp
	;sub eax, 0xFFFF0
	;mov esp, eax

	mov eax, cr0
	and eax, 0xFFFFFFFE
	mov cr0, eax
	;jmp 0xFFFF:.real
	jmp 0x0000:.real
	.real:
	;mov ax, 0xFFFF
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	pop eax

	;push ebp
	;mov ebp, esp
	;sub dword [ss:bp+4], 0xFFFF0
	;pop ebp
	lidt [IDTR16]
	ret	


	goto32:
	push eax
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	;jmp dword 0x08:(0xFFFF0+.protected32)
	jmp dword 0x08:(.protected32)
	[BITS 32]
	.protected32:
		mov ax, 0x0010
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		mov ss, ax
		;mov eax, esp
		;add eax, 0xFFFF0
		;mov esp, eax
		pop eax
		;push ebp
		;mov ebp, esp
		;add dword [ss:ebp+4], 0xFFFF0
		;pop ebp
		;lidt [IDTR+0xFFFF0]	
		lidt [IDTR]
		ret



ISRS:
%assign i 0 
%rep    256
	[BITS 32]
	call goto16
	[BITS 16]
	int i
	call goto32
	[BITS 32]
	iret

%assign i i+1 
%endrep
.end:

section .text

	global flatRead
	flatRead:
		
	

	global flatWrite
	flatWrite:

section .data
	GDTR:
	.size: dw (GDT.end - GDT)-1
	.address: dd GDT
	GDT:
		dq 0x0000000000000000 ;NULL segment
		dq 0x00CF9B000000FFFF ;32 bit CODE segment
		dq 0x00CF93000000FFFF ;32 bit DATA segment
		dq 0x00009B000000FFFF ;16 bit CODE segment
		dq 0x000093000000FFFF ;16 bit DATA segment
	.end:

	IDTR16:
	.size: dw 0xFFFF
	.address: dd 0x00000000

	IDTR:
	.size: dw (IDT.end - IDT)-1
	.address: dd IDT
	IDT:
%assign i 0 
%rep    256
	dq 0x00008E0000080000 | ((0x500+(i*(((ISRS.end-start)-(ISRS-start))/256))+(ISRS-start))&0xFFFF) | (((0x500+(i*(((ISRS.end-start)-(ISRS-start))/256))+(ISRS-start))&0xFFFF0000)<<32)
%assign i i+1 
%endrep
	.end:


	
