ENTRY(start)

SECTIONS
{
	. = 0x0;
	.text BLOCK(2K) : ALIGN(2K)
	{
		*(.entry)
		*(.text)
	}
	.rodata BLOCK(2K) : ALIGN(2K)
	{
		*(.rodata)
	}
	.data BLOCK(2K) : ALIGN(2K)
	{
		*(.data)
	}
	.bss BLOCK(2K) : ALIGN(2K)
	{
		*(COMMON)
		*(.bss)
	}


}
