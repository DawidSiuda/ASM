main: main.o Add.so
	ld main.o -o main -m32 -lc -dynamic-linker ./Add.so

main.o: main.s
	as main.s -o main.o --32

Add.so: Add.o
	gcc -shared Add.o -o Add.so -m32

Add.o: Add.c Add.h
	gcc -c -fpic -O0 Add.c -o Add.o -m32

clean:
	rm *.o

