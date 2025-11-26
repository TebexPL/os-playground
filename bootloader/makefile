AS:=nasm
CC:=i386-elf-gcc
LD:=i386-elf-gcc
OBJCOPY:=i386-elf-objcopy
CFLAGS:=-ffreestanding -Wall -Wextra -m16 -Os -I $(CURDIR)/include
LDFLAGS:= -m16 -nostdlib -nostdlib -nostartfiles -nodefaultlibs -lgcc 

all: clean bootloader.bin

%.co : %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.ao : %.asm
	$(AS) -f elf32 $< -o $@

%.elf : %.co %.ao
	$(LD) $(LDFLAGS) -T bootloader.ld $^ -o $@ 

%.bin : %.elf
	$(OBJCOPY) -O binary $< $@


bootloader.elf : bootloader.ao bootloader.co 

clean:
	rm -rf *.bin *.co *.ao *.elf
