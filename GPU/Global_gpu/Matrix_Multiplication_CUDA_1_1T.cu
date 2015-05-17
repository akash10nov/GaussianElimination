#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <unistd.h>
#include <sys/time.h>
#include <stdint.h>
#define MAX 10
#define MIN 1

void lu_decomp(float *a, float *u,int dimension);
__global__ void DUKernel(float *D_a, float *D_u,unsigned int size);
uint64_t getTime();

int main(int argc, char **argv){	
	float *a, *u, *l;
	int dimension;
	
	dimension = atoi(argv[1]);
	a= (float*)malloc(sizeof(float) * (dimension*dimension));
	l= (float*)malloc(sizeof(float) * (dimension*dimension));
	u= (float*)malloc(sizeof(float) * (dimension*dimension));
	for(int i = 0; i<dimension; i++)
	 {	 
       for(int j = 0; j<dimension; j++)
	   {	   
            a[(i*dimension)+j] = rand() % (MAX - MIN) + MIN;
		   u[(i*dimension)+j] =  a[(i*dimension)+j];
		  
		  if(i == j)
		  {
			 l[(i*dimension)+j] = 1;  
		  }
		  else
		  {
			 l[(i*dimension)+j] = 0;  
		  }		
	   } 
	 }  
	 for(int k = 0; k < dimension-1; k++)
	 {
		for(int j=k+1; j < dimension; j++ )
		{
			l[(j*dimension)+k] = a[(j*dimension)+k]/a[(k*dimension)+k];
			u[(j*dimension)+k]=0;
		}
	}
	/*printf("U before\n");
	for(int i = 0; i<dimension; i++)
	 {		
	 for(int j = 0; j<dimension; j++)
	   {	   
            printf("%15f",u[(i*dimension)+j]);
	   }
	   printf("\n");
	 }*/
	float diff_allowed=10;
      
	lu_decomp(a,u,dimension); 	
	float temp =0;
	float x=0;


	/* remove this comment for verification





	for(int i =0; i < dimension; i++)
	{
		for(int j=0; j < dimension; j++)
		{
			temp =0;
			for(int k=0; k < dimension; k++)
			{
			   temp = temp + l[(i*dimension)+k]* u[(k*dimension)+j];
			   temp=a[(i*dimension)+j];	
			}
			
			//printf("%15f",temp);
			
		   	 if((abs(temp-a[(i*dimension)+j])>diff_allowed))   
			{
				x=abs(temp-a[(i*dimension)+j]);
				printf("problem");
				printf("diff: %5f\n",x);
			}		
		}	
		//printf("\n");
	}
	


	REMOVE THIS COMMENT FOR VERIFICATION.

	*/ 
	//printf("\n");
        //printf("U Matrix:\n");
	/*
	for(int i = 0; i<dimension; i++)
	 {		
	 for(int j = 0; j<dimension; j++)
	   {	   
            printf("%15f",u[(i*dimension)+j]);
	   }
	   printf("\n");
	 }
	
	for(int i = 0; i<dimension; i++)
	 {		
	 for(int j = 0; j<dimension; j++)
	   {	   
            printf("%15f",l[(i*dimension)+j]);
	   }
	   printf("\n");
	 }
	 printf("\n");
	 printf("Original Matrix:\n");

	for(int i = 0; i<dimension; i++)
	 {		
	 for(int j = 0; j<dimension; j++)
	   {	   
            printf("%15f",a[(i*dimension)+j]);
	   }
	   printf("\n");
	 }*/
	return 0;
}

void lu_decomp(float *a,float *u, int dimension) 
{ 
    float *d_a ,*d_u; 
    uint64_t astart, aend;
    cudaMalloc(&d_a, (dimension*dimension)*sizeof(float));
	cudaMalloc(&d_u, (dimension*dimension)*sizeof(float));
    astart = getTime();
    //Copying data to device from host 
    cudaMemcpy(d_a, a, sizeof(float)*dimension*(dimension),cudaMemcpyHostToDevice);
	cudaMemcpy(d_u, u, sizeof(float)*dimension*(dimension),cudaMemcpyHostToDevice);
    
    //Kernel call 
    if(dimension<1001)
   	 DUKernel<<<dimension ,dimension>>>(d_a, d_u ,dimension); 
    else
	 DUKernel<<<(dimension*dimension/1000),1000>>>(d_a, d_u ,dimension); 
    //DUKernel<<<1024 ,100,4*dimension*dimension>>>(d_a,d_u, dimension); 
    //Coping data to host from device 
    //cudaMemcpy(a,d_a,sizeof(float)*dimension*(dimension),cudaMemcpyDeviceToHost);
	//cudaMemcpy(l,d_l,sizeof(float)*dimension*(dimension),cudaMemcpyDeviceToHost);
	cudaMemcpy(u,d_u,sizeof(float)*dimension*(dimension),cudaMemcpyDeviceToHost);
	aend = getTime();
	 printf("%d, %f  \n",dimension,(aend-astart)/1000000.0);
    //Deallocating memory on the device 
    cudaFree(d_a); 
    cudaFree(d_u); 
}


__global__ void DUKernel(float *D_a,float *D_u, unsigned int dimension)
{
	// 10x10 size matrix is for experiment, so argv[1]=10
	 
	 int k=threadIdx.x;
	 int j=blockIdx.x;
	 int p= threadIdx.x+(blockIdx.x*blockDim.x);
	 __syncthreads();
	int i=0;
	int s=0;
	 while(i<threadIdx.x && s< blockIdx.x)
	 {
		D_u[p]=D_u[p]-(D_u[((s%1000)*dimension)+(k*(j/1000))+k] * ((D_u[((j%1000)*dimension)+(i*(j/1000))+i])/D_u[((j%1000)*dimension)+(j*(j/1000))+j]));
		i++;
		s++;
	 }
	// __syncthreads();
	
	
	
	
}
	


uint64_t getTime(){
	struct timeval t;
	gettimeofday(&t, NULL);
	return (uint64_t)(t.tv_sec)*1000000 + (uint64_t)(t.tv_usec);
}