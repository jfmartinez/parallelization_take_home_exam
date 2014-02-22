parallelization_take_home_exam
==============================

Implemented various problems using CUDA,OpenMP and MPI

##Problem 1

Assume that you start with two arrays of random numbers (double precision) between -10 and 10. You are supposed to add these two arrays of length N on the GPU and eventually get the result into a host array of length N 

You will have to run a loop to investigate what happens when the value of N increases by factors of 2 from N=210, the amount of time (inclusive and exclusive) it takes for the program to add the two arrays as a function of the array size. 

You will have to do the sequence of steps above twice (plot all the result on the same plot though). The first time, the number of threads in a block is going to be 32. As the value of N increases, you’ll have to adjust the number of blocks you launch to get the job done. The second time around, you are going to use 1024 threads in a block. Again, as the value of N increases, you’ll have to adjust the number of blocks you launch to get the job done. 


Here’s is the description of the tasks you have to run: 

1. Allocate space on the host for arrays hA, hB, and hC, refC, and then populate hA and hB with random numbers between -10 and 10. Each of these arrays is of size N. 

2. Store the result of hA+hB into refC 

3. Allocate space on the device for dA, dB, and dC 

4. For inclusive timing, start the timing now 

5. Copy content of hA and hB into dA and dB, respectively. 

6. For exclusive timing, only start the timing now 

7. Invoke kernel that sums up the two arrays 

8. For exclusive timing, stop the timing now 

9. Copy the content of dC back into hC 

10.For inclusive timing, stop the timing now 

11.Report the amount of time required to complete the job 

12.Confirm that the numbers in refC and hC are identical within 1E-12 to N=220. Specifically, report in a plot