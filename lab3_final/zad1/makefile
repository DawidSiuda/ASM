main: main.c fun.s 
	gcc main.c fun.s -o main

fun.o: fun.s
	as fun.s -o fun.o

main.o: main.c
	gcc main.c -c main.o

clean:
	rm *.o

