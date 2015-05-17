#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <sys/time.h>
#include <stdint.h>
#include "mpi.h"
#define MAX 100
#define MIN 1
int main(int argc,char *argv[])
{
	int count=0;
	int size;
	int dimension=strtol(argv[1],(char **)NULL,10); //http://stackoverflow.com/questions/9748393/how-can-i-get-argv-as-int
	int rank, nprocs;
	double **a;
	int i=0;
	int j=0;
	int k=0;
	a = (double **)malloc(sizeof(double *) * (dimension));

	for ( i = 0; i < dimension; i++){
		a[i]= (double*)malloc(sizeof(double) * dimension);
	}
	
	for( i = 0; i<dimension; i++)
	 {	 
       for(j = 0; j<dimension; j++)
	   {	   
            a[i][j] = rand() % (MAX - MIN) + MIN;
	   } 
	 }    
	

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	int *alloc =malloc(dimension * (sizeof( *alloc)));
	double time0=0;
	 time0 = MPI_Wtime();
	for(i=0; i<dimension; i++)
	{
		alloc[i]= i % nprocs;
	}

	for(j =0; j < dimension-1; j++) {
        if(alloc[j] == rank)
        {
        	for(i = j+1; i < dimension; i++) {
        		a[i][j] = a[i][j]/a[j][j];
        	}
        }
        MPI_Bcast (&a[j][j],dimension-j,MPI_DOUBLE,alloc[j],MPI_COMM_WORLD);

        		for(k = j+1; k < dimension; k++)
        		{
        			if(alloc[j] == rank)
        			{
        				for(i = j+1; i < dimension; i++) {
        					a[k][i]= a[k][i] - (a[k][j] * a[j][i]);
        				}
        			}
        		}
        }
	float temp =0;
	double time1=0;
	time1 = MPI_Wtime();
	printf("%f,%d\n",(time1-time0),dimension);
	return 0;

}	



