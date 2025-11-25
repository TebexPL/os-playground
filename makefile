AS:=nasm
CC:=i386-elf-gcc
LD:=i386-elf-gcc
OBJCOPY:=i386-elf-objcopy
CFLAGS:=-ffreestanding -Wall -Wextra -m16 -Os -I $(CURDIR)/include
LDFLAGS:= -m16 -nostdlib -nostdlib -nostartfiles -nodefaultlibs -lgcc 

all: clean bootsector.bin

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.o : %.asm
	$(AS) -f elf32 $< -o $@

%.elf : %.o
	$(LD) $(LDFLAGS) -T bootloader.ld $^ -o $@ 

%.bin : %.elf
	$(OBJCOPY) -O binary $< $@

%.bin : %.asm
	$(AS) $< -o $@

bootloader.elf : bootloader_asm.o bootloader.o 

#part.img: kernel.bin
#	dd if=/dev/zero of=part.img bs=1M count=50
#	mkfs.fat -F32 -n "OS" part.img
#	mmd -i part.img OS
#	mmd -i part.img OS/BOOT
#	mcopy -i part.img kern.bin ::OS/BOOT/kern.ab

disk.img: bootsector.bin bootloader.bin
	dd if=/dev/zero of=$@ bs=1M count=100
	parted $@ -s mklabel msdos
	parted $@ -s mkpart primary fat32 2048s 104448s
	dd if=bootsector.bin of=$@ conv=notrunc bs=1 count=446
	dd if=bootloader.bin of=$@ conv=notrunc seek=1 
	#dd if=part.img of=disk.img bs=512 seek=2048 conv=notrunc

run: clean disk.img 
	bochs -f bochs.conf -q

debug: clean disk.img
	bochs -f bochs.conf -q -debugger
	
clean:
	rm -rf *.bin
	rm -rf *.o
	rm -rf *.elf
	rm -rf *.img
