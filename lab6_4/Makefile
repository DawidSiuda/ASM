a.out: clear main.c 
	gcc -O0 -g -o a.out main.c  `sdl-config --cflags` `sdl-config --libs` -lSDL_image -msse2
functions.o: functions.s
	as -g functions.s -o functions.o

clear:
	rm -f file2.bmp
	touch file2.bmp
# -lSDL2_image  `sdl2-config --cflags --libs`