#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <sys/time.h>
#include <omp.h>
#define MAX 100
#define MIN 1
int main(int argc,char *argv[])
{
	
	int count=0;
	
	int dim[10];
	dim[0]=10;
	dim[1]=100;
	dim[2]=200;
	dim[3]=500;
	dim[4]=700;
	dim[5]=1000;
	dim[6]=2000;
	dim[7]=5000;
	dim[8]=7000;
	dim[9]=10000;
	for(count=0;count<10;count++){
	int dimension=dim[count];
	int i,j,k,p;
	float **u;
	float **l ;
	float **a;
	a = malloc(dimension * sizeof(float *));
	l = malloc(dimension * sizeof(float *));
	u = malloc(dimension * sizeof(float *));
	
	for(i = 0; i < dimension; i++)
	{
		a[i] = malloc(dimension * sizeof(float));
		l[i] = malloc(dimension * sizeof(float));
		u[i] = malloc(dimension * sizeof(float));
	}

	#pragma omp parallel for shared(a,u,l,dimension) private(i,j)
	for(i = 0; i<dimension; i++)
	 {	 
		
		for(j = 0; j<dimension; j++)
		{	   
          	  a[i][j] = rand() % (MAX - MIN) + MIN;
		  u[i][j] = a[i][j];
		  
		  if(i == j)
		  {
			l[i][j] = 1;  
		  }
		  else
		  {
			l[i][j] = 0;  
		  }		
	   } 
	} 
	double time0=omp_get_wtime();
	for(k = 0; k < dimension-1; k++)
	{
		#pragma omp parallel for schedule(static,128) shared(u,l,k,dimension) private(j,i)
		for(j=k+1; j < dimension; j++ )
		{
			l[j][k] = u[j][k]/u[k][k];
			u[j][k] =0;	
			for(i=k+1; i < dimension; i++) 
			{
				u[j][i] = u[j][i] - (u[k][i] * l[j][k]);		
			}
		}	
	}

 	double time1=omp_get_wtime();
	printf(" %f,%d\n",(time1-time0),dimension);

	float temp =0;
	float x=0;
	for(i =0; i < dimension; i++)
	{
		#pragma omp parallel for shared(u,l,a,i,dimension) private(j,k,temp,x)
		for(j=0; j < dimension; j++)
		{
			temp =0;
			for(k=0; k < dimension; k++)
			{
			   temp = temp + l[i][k] * u[k][j];	
			}
			//printf("%15f",temp);
		   	 if((abs(temp-a[i][j])>50))   
			{
				x=abs(temp-a[i][j]);
				printf("problem");
				//printf("diff: %5f\n",x);
			}		
		}	
	}		
	}
		return 0;
		

}	


