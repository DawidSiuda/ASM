main: main.o
	ld main.o -o main -dynamic-linker /lib/ld-linux.so.2 
 
main.o: main.s
	as main.s -o main.o

clean:
	rm *.o

useg:
	gcc main.s -o main

