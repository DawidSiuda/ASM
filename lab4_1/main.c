#include <stdio.h>

//extern int sprawdz();
extern int set(int precizion);

int main()
{
    int nr_opcji=-1;

    printf("press 1 to check, pres 2 to set:\n");
    scanf("%d", &nr_opcji);

    switch(nr_opcji)
    {
    case 1:
        printf("\nTO DO: \n");
        // switch(sprawdz())
        // {
        //     case 0: printf("Single Precision\n\n"); break;
        //     case 2: printf("Double Precision\n\n"); break;
        //     case 3: printf("Double Extended Precison\n\n");
        //             break;
        // }
        // break;

    case 2:
        printf("\n1 - Single Precision\n");
        printf("2 - Double Precision\n");
        printf("3 - Double Extended Precision\n");
        scanf("%d", &precyzja);
        if (precyzja>3 || precyzja<1)
            printf("Podano zla wartosc\n");
        else ustaw(precyzja);
        printf("\n");
        break;
    }

    return 0;
}