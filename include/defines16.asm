BITS 16
CPU 386

%define call call dword
%define ret o32 ret

%macro cdecl_entry 0
	push ebp 
	mov ebp, esp
%endmacro

%macro cdecl_exit 0
	pop ebp 
	ret 
%endmacro

%define cdecl_param(i) [ss:ebp+0x08+(i*4)]


%macro function 1
	global %1
	%1:
%endmacro
