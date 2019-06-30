main: main.o
	ld main.o -o main -m elf_i386
main.o: main.s
	as main.s -o main.o --32
