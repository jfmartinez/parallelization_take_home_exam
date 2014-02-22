// Author: Jose F. Martinez Rivera
// Course: ICOM4036- 040
// Professor: Dr. Wilson Rivera
// Hand-In Date: April 29, 2013


// Problem 1:
// Assume that you start with two arrays of random numbers (float precision) 
// between -10 and 10. You are supposed to add these two arrays of length N
// on the GPU and eventually get the result into a host array of length N
// You will have to run a loop to investigate what happens when the value of N
// increases by factors of 2 from N=2^10 to N=2^20. Specifically, report in a plot 
// the amount of time (inclusive and exclusive) it takes for the program to add 
// the two arrays as a function of the array size. 
// You will have to do the sequence of steps above twice (plot all the result on 
// the same plot though). The first time, the number of threads in a block is 
// going to be 32. As the value of N increases, you’ll have to adjust the number 
// of blocks you launch to get the job done. The second time around, you are 
// going to use 1024 threads in a block. Again, as the value of N increases, 
// you’ll have to adjust the number of blocks you launch to get the job done.
// Here’s is the description of the tasks you have to run:
//----
// 1. Allocate space on the host for arrays hA, hB, and hC, refC, and then 
// populate hA and hB with random numbers between -10 and 10. Each 
// of these arrays is of size N.
// 2. Store the result of hA+hB into refC
// 3. Allocate space on the device for dA, dB, and dC
// 4. For inclusive timing, start the timing now
// 5. Copy content of hA and hB into dA and dB, respectively.
// 6. For exclusive timing, only start the timing now
// 7. Invoke kernel that sums up the two arrays
// 8. For exclusive timing, stop the timing now
// 9. Copy the content of dC back into hC
// 10.For inclusive timing, stop the timing now
// 11.Report the amount of time required to complete the job
// 12.Confirm that the numbers in refC and hC are identical within 1E-12



//Adds the vectors together
__global__ void add_Vector( float *hA, float *hB, float *hC)
{
		int i = threadIdx.x + blockIdx.x * blockDim.x;
		
		hC[i] = hA[i] + hB[i];
			
}

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>



int N = (int) pow(2.0,10);


//Threads that are going to be tested
int threads_per_block_test[2] = {32, 1024};


//Creates random numbers
float fRand()
{
	//Chooses if the number is negative
	float options[2] = {-1, 1};
	int op = rand()%2;
	float max = (float) rand()/RAND_MAX * 10;
	float cap = rand()%12;

	float precision = 0;

	int i;
	for(i = 0; i < cap; i ++)
	{

		precision += (float)(rand()/RAND_MAX) * (1.0/pow(10.0,i+1));
	}
	return (max + precision) * options[op];

}


int main(void)
{	
	int j, k;


	int threads_per_block;

	//Goes through Test 1(32 Threads) and Test 2(1024 Threads)
	for(j = 0; j < 2; j++)
	{	
		threads_per_block = threads_per_block_test[j];

		printf("Threads: %d\n", threads_per_block);

		for(k = 0; k <= 10; k++)
		{		

			N = pow(2.0, k +10);
			printf("\tValue of N: %d\n\t", N);
			//Host variables
			float *hA;
			float *hB;
			float *hC;
			float *refC;

			//Device variables
			float *dA, *dB, *dC;

			//Size of float
			const int size = N * sizeof(float);


			//Inclusive time
			float incTime;

			//Exclusive time
			float excTime;

			//Initialize the cuda events
			cudaEvent_t incTimeStart, incTimeStop;
			cudaEvent_t excTimeStart, excTimeStop;


			//Create the timing events
			cudaEventCreate(&incTimeStart);
			cudaEventCreate(&incTimeStop);
			cudaEventCreate(&excTimeStart);
			cudaEventCreate(&excTimeStop);

			//Allocating space on the host
			hA = (float *)malloc(size);
			hB = (float *)malloc(size);
			hC = (float *)malloc(size);
			refC = (float *)malloc(size);

		   	//Loop for assigning random numbers
			int i;
			for(i = 0; i < N; i++)
			{

				hA[i] = fRand();
				hB[i] = fRand();
			
			
			}

			//Sequential sum of arrays A + B
			for( i = 0; i < N; i ++)
			{
				refC[i] = hA[i] + hB[i];

			}

			//Allocation of space on the device
			cudaMalloc((void**)&dA, size);
			cudaMalloc((void**)&dB, size);
			cudaMalloc((void**)&dC, size);


			//Inclusive Time Start
			cudaEventRecord(incTimeStart, 0);

			//Copy content of hA and hB into dA and dB
			cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice);
			cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice);

			//Exclusive Time Start
			cudaEventRecord(excTimeStart,0);

			//Call the kernel (add)

			add_Vector<<<N/threads_per_block, threads_per_block>>>(dA,dB, dC);

			//Exclusive Time Stop
			cudaEventRecord(excTimeStop, 0);

			//Synchronize time
			cudaEventSynchronize(excTimeStop);

			//Elapsed Exclusive Time
			cudaEventElapsedTime(&excTime, excTimeStart, excTimeStop);


			//Copy the result back to hC (array C)
			cudaMemcpy(hC, dC, size, cudaMemcpyDeviceToHost);

			//Inclusive Time Stop
			cudaEventRecord(incTimeStop, 0);

			//Elapsed Inclusive Time
			cudaEventSynchronize(incTimeStop);
			cudaEventElapsedTime(&incTime, incTimeStart, incTimeStop);

			printf("\tExclusive Time was: %f\n\t\tInclusive Time was: %f\n\t\tTotal Time: %f\n", excTime, incTime, excTime + incTime);

			int k;
			//Check if the results match (refC == hC)
			for(k = 0; k < N; k++)
			{

				if(abs(refC[k] - hC[k]) > (float)(1/pow(10.0, 12)))
				{	
					///printf("%d == %d\n", ref[i], hC[i]);
					printf("The results are not identical\n");
				}
			}




			//Free the space
			free(hA);
			free(hB);
			free(hC);
			free(refC);
			cudaFree(dA);
			cudaFree(dB);
			cudaFree(dC);
			cudaEventDestroy(incTimeStart);
			cudaEventDestroy(incTimeStop);
			cudaEventDestroy(excTimeStart);
			cudaEventDestroy(excTimeStop);

		}
	}
	return 0;


}

