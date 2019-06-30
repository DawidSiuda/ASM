#include <stdio.h>

extern int fcheckCoreNumber();


int main()
{
	int data = fcheckCoreNumber();

	printf("1) Output: %08x \n", data);

    return 0;
}
