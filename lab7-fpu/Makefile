main: clean main.c 
	gcc main.c functions.s -o main

a.out: clean main.c 
	gcc -g -O0 functions.s -o a.out

clean:
	rm -f *.o main 
