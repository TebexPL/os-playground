AS:=nasm

all: clean bootsector.bin

%.bin : %.asm
	$(AS) $< -o $@


bootsector.bin : bootsector.asm

clean:
	rm -rf *.bin 
