main: main.c 
	gcc main.c functions.s -o main

functions.o: functions.s
	as functions.s -o functions.o

main.o: main.c
	gcc main.c -c main.o

clean:
	rm *.o
