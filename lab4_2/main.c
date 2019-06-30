#include <stdio.h>

extern int fcheck();
extern int fset(unsigned long precizion);
extern int fcheckFPSR();

int main()
{
    int loop = 1;
    while(loop)
    {
    	int option=-1;

    	printf("1) Check precision \n2) Set precission \n3) Chesk state  \n");
    	scanf("%d", &option);
 
   		switch(option)
   		{
        	case 1:
        	{
	    		 long result = fcheck();
	   			switch(result)
	    		{
				case 0://00
	    	        printf("\nr. to nearest(00)\n");
	        	    break;
				case 1://01
	        	    printf("\nr. down(01)\n");
		    		break;
	 			case 2://10
	    	        printf("\nr. upi(10)\n");
	    	        break;
				case 3://11
		    		printf("\nr. toward zero(11)\n");
		    		break;
				}
				break;
	    	}	
			case 2:
	    	{
				unsigned long prc = 0;
	    	
	        	printf("--> set value: \n");
	    		scanf("%d", &option);
		
				fset(option);
	    
	       		break;
	   		}
			case 3:
			{
				int fpustate = fcheckFPSR();
				printf("fpu state: %d\n", fpustate);
			// 	while (fpustate) 
			// 	{
			// 		if (fpustate & 1)
			// 			printf("1");
			// 		else
			// 			printf("0");

			// 		fpustate >>= 1;
			// 	}
			// 	printf("\n");
			}
	    	case 0:
	   		{
  				loop = 0;
				break;
			}
 	   }
    }

    return 0;
}
