#!/bin/bash
or32-elf-gcc -c -nostdlib -o instructionTest.o instructionTest.S
or32-elf-gcc -c -nostdlib -o exceptionHandlers.o exceptionHandlers.S
or32-elf-gcc -nostdlib -o instructionTest.or32 exceptionHandlers.o instructionTest.o
or32-elf-objcopy -O binary instructionTest.or32 instructionTest.bin
or32-elf-objdump -d instructionTest.or32 > instructionTest.asm
