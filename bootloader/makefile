AS:=nasm
CC:=i386-elf-gcc
LD:=i386-elf-gcc
OBJCOPY:=i386-elf-objcopy
CFLAGS:= -c -ffreestanding -Wall -Wextra -m16 -Os -I ../include
LDFLAGS:= -m16 -nostdlib -nostdlib -nostartfiles -nodefaultlibs -lgcc -T bootloader.ld
ASFLAGS:= -f elf32 --include ../include/defines16.asm
OBJFLAGS:= -O binary

all: clean bootloader.bin

%.co : %.c
	$(CC) $(CFLAGS) $< -o $@

%.ao : %.asm
	$(AS) $(ASFLAGS) $< -o $@

%.elf : %.co %.ao
	$(LD) $(LDFLAGS) $^ -o $@ 

%.bin : %.elf
	$(OBJCOPY) $(OBJFLAGS) $< $@

bootloader.elf : bootloader.ao bootloader.co stdio.ao stdio.co

clean:
	rm -rf *.bin *.co *.ao *.elf
