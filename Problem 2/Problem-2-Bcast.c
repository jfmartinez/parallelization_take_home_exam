// Author: Jose F. Martinez Rivera
// Course: ICOM4036- 040
// Professor: Dr. Wilson Rivera
// Hand-In Date: April 29, 2013

// Problem 2:
// Bcast


#include <mpi.h>
#include <stdio.h>
#include <math.h>
#include <time.h>

int main( int argc, char *argv[])
{	
	int myid, numprocs, count, source;

	//Timers
	double bcastTimeStart, bcastTimeEnd;

	MPI_Status status;

	//Memory Allocation
	char *info = malloc(pow(2.0, 30) * sizeof(char));

	//Initializes MPI Code
	MPI_Init(&argc, &argv);

	MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
	MPI_Comm_rank(MPI_COMM_WORLD, &myid);
	
	source=0;
	
	


	int power;
	for(power = 0; power <= 30; power++){
		

		int count = pow(2.0, power);

		int i;
		
		//Adds data to the information being sent
		for(i = 0; i < count; i++)
		{
			info[i] = i;
		}
		
		//Waits for all to finish
		MPI_Barrier(MPI_COMM_WORLD);
		
		//Start the timer
		bcastTimeStart = MPI_Wtime();

	
		
		//Broadcasts the data to all the processes
		MPI_Bcast(info, count, MPI_BYTE, source, MPI_COMM_WORLD);

		//Waits for all to finish
		MPI_Barrier(MPI_COMM_WORLD);

		//Ends and records the time
		bcastTimeEnd = MPI_Wtime();

		if(myid == source){
		
		
		printf("Transfer: %d took %f to complete.\n", power, bcastTimeEnd - bcastTimeStart);
	

		}	
		

}	
		MPI_Finalize();

	
	return 0;
}
