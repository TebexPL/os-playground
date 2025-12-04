.PHONY: clean bootsector bootloader kernel disk partition run debug all vhd



clean:
	cd bootsector && make clean
	cd bootloader && make clean
	cd kernel && make clean
	rm -rf disk.vhd
	rm -rf disk.img.lock

disk: 
	dd if=/dev/zero of=disk.img bs=1M count=100
	parted disk.img -s mklabel msdos
	
partition: 
	dd if=/dev/zero of=part.img bs=1M count=50
	mkfs.fat -F32 -n "OS" part.img
	mmd -i part.img OS
	parted disk.img -s mkpart primary fat32 2048s 104448s

bootsector: disk
	cd bootsector && make all;
	dd if=bootsector/bootsector.bin of=disk.img conv=notrunc bs=1 count=446

bootloader: disk 
	cd bootloader && make all;
	dd if=bootloader/bootloader.bin of=disk.img conv=notrunc seek=1 

kernel: partition disk
	cd kernel && make all;
	mcopy -i part.img kernel/kernel.bin ::OS/kernel.bin
	dd if=part.img of=disk.img bs=512 seek=2048 conv=notrunc

all: bootsector bootloader kernel

vhd: clean all
	VBoxManage convertfromraw disk.img disk.vhd --format=vhd --uuid "d57780cc-0323-4090-b7bf-471de6309212"
	VirtualBoxVM --startvm OS

run: clean all
	bochs -f bochs.conf -q
	
debug: clean all
	bochs -f bochs.conf -q -debugger

