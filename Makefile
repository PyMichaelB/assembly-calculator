assemble:
	nasm -f elf64 calculator.asm -o calculator.o

make link:
	ld calculator.o -o calculator