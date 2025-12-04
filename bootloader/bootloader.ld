ENTRY(start)

SECTIONS
{
	. = 0x0010;
	.text BLOCK(16) : ALIGN(16)
	{
		*(.entry)
		*(.text)
	}
	.rodata BLOCK(16) : ALIGN(16)
	{
		*(.rodata)
	}
	.data BLOCK(16) : ALIGN(16)
	{
		*(.data)
	}
	.bss BLOCK(16) : ALIGN(16)
	{
		*(COMMON)
		*(.bss)
	}


}
