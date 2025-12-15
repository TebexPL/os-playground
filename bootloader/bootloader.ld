ENTRY(start)

SECTIONS
{
	. = 0x0500;
	.text BLOCK(16) : ALIGN(16)
	{
		*(.entry)
		*(.lowmem)
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
