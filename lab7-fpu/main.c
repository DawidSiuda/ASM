#include <stdio.h>

extern float fun(float a, float b, float c);


int main()
{
	float out = fun(3, 2, 1);

	printf("Output: %f\n", out);

    return 0;
}
