main: main.o
	ld main.o -o main
main.o: functions.s
	as functions.s -o main.o


a.out: clean main.c 
	gcc -g -O0 functions.s -o a.out

clean:
	rm -f *.o main a.out
