help:
	@echo "    all"
	@echo "    simulator - x86 OR1K simulator"
	@echo "    inline - Simple bare metal program that calls IIE handler"
	@echo "    interrupt - Build just the IIE handler to run at address 0x08000000"
	@echo "    mmu - Build just the IIE handler to run at address 0x08000000 with MMU support"

all: simulator inline interrupt mmu

simulator:
	make -f Makefile.sim

inline:
	or32-elf-gcc -g -mboard=ml505 -O0 -o simple.or32 cpu.c mmu_support.c simulator.c runSim.c iieHandler.S simple.c
	or32-elf-objdump -d simple.or32 > simple.asm

interrupt:
	or32-elf-gcc -nostdlib -O0 -Ttext=0x08000000 -DSTANDALONE -o iieHandler.or32 iieHandler.S cpu.c mmu_support.c simulator.c runSim.c
	or32-elf-objdump -d iieHandler.or32 > iieHandler.asm
	or32-elf-gcc -mboard=ml505 -g -O0 -o loop.or32 loop.c
	or32-elf-objdump -d loop.or32 > loop.asm

mmu:
	or32-elf-gcc -nostdlib -O3 -Ttext=0x08000000 -DSTANDALONE -DMMU_SUPPORT -o iieHandler.or32 iieHandler.S cpu.c mmu_support.c simulator.c runSim.c
	or32-elf-objdump -d iieHandler.or32 > iieHandler.asm
	or32-elf-gcc -mboard=ml505 -g -O0 -o loopMMU.or32 loopMMU.c
	or32-elf-objdump -d loopMMU.or32 > loopMMU.asm
	or32-linux-gcc -DLINUX -I/opt/or32-linux/include -L/opt/or32-linux/lib -o loopMMU.linux loopMMU.c
	or32-linux-objdump -d loopMMU.linux > loopMMU.linux.asm

sim: mmu
	or32-elf-gcc -mboard=ml505 -g -O0 -DSIMNO -o loopMMU.or32 loopMMU.c
	or32-elf-objdump -d loopMMU.or32 > loopMMU.asm
	or32-elf-objcopy -O binary loopMMU.or32 loopMMU.bin
	../utils/bin2vmem loopMMU.bin > loopMMU.vmem
	echo  "" >> loopMMU.vmem
	or32-elf-objcopy -O binary iieHandler.or32 iieHandler.bin
	../utils/bin2vmem iieHandler.bin | sed s/@000/@020/ >> loopMMU.vmem
	rm -rf *.bin
bare:
	or32-elf-gcc -nostdlib -O3 -Ttext=0x08000000 -DSTANDALONE -DMMU_SUPPORT -o iieHandler.or32 iieHandler.S cpu.c mmu_support.c simulator.c runSim.c
	or32-elf-objdump -d iieHandler.or32 > iieHandler.asm
	or32-elf-objcopy -O binary iieHandler.or32 iieHandler.bin
	../utils/bin2vmem iieHandler.bin | sed s/@000/@020/ > iieHandler.vmem
	rm -rf *.bin	
clean:
	rm -rf *.{o,or32,asm,d,bin,vmem,linux} simulator
