#include<stdio.h>

extern long myFactorial(long a);

/*
long add(long a, long b) 
{
    asm("\
        movq %rsi, %rax
	addq %rdi, %rax \n\
        ");
}	
*/

int main()
{	
	long a;
	scanf("%ld", &a);
	a = myFactorial(a);
	printf("silnia: %ld \n", a);

	return a;	
}

