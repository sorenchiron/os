#include "stdio.h"
int add(int a,int b)
{
	return a+b;
}

int main(void)
{
	add(1,2);
	printf("%lu\n",sizeof(short int));
	return 0;
}

