C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
C_HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

CFLAGS = -m32 -fno-pie -ffreestanding
LDFLAGS = -m elf_i386 -Ttext 0x1000 --oformat binary

all: os-image

run: all
	bochs -q

os-image: boot/boot_sect.bin kernel.bin	
	cat $^ > $@

kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld $(LDFLAGS) -o $@ $^

%.o: %.c ${C_HEADERS}
	gcc $(CFLAGS) -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -I 'boot/' -o $@

clean:
	rm -rf *.bin *.o os-image
	rm -rf boot/*.bin kernel/*.o drivers/*.o
