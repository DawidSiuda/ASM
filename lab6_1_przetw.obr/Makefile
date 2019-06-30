a.out: clear functions.o
	ld -g functions.o -o a.out
functions.o: functions.s
	as -g functions.s -o functions.o

clear:
	rm -f file2.bmp
	touch file2.bmp
