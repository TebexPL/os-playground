AS:=nasm
CC:=i386-elf-gcc
LD:=i386-elf-gcc
OBJCOPY:=i386-elf-objcopy
CFLAGS:= -c -ffreestanding -Wall -Wextra -Os -I ../include
LDFLAGS:= -nostdlib -nostartfiles -nodefaultlibs -T bootloader.ld 
LIBS:= -lgcc
ASFLAGS:= -f elf32 --include ../include/defines.asm
OBJFLAGS:= -O binary

all: clean bootloader.bin

%.co : %.c
	$(CC) $(CFLAGS) $< -o $@

%.ao : %.asm
	$(AS) $(ASFLAGS) $< -o $@

%.elf : %.co %.ao
	$(LD) $(LDFLAGS) $^ -o $@ $(LIBS)

%.bin : %.elf
	$(OBJCOPY) $(OBJFLAGS) $< $@

bootloader.elf : bootloader.ao bootloader.co stdio.ao stdio.co

clean:
	rm -rf *.bin *.co *.ao *.elf
