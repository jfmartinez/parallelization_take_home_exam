parallelization_take_home_exam
==============================

Implemented various problems using CUDA,OpenMP and MPI

##Problem 1
Assume that you start with two arrays of random numbers (double precision) between -10 and 10. You are supposed to add these two arrays of length N on the GPU and eventually get the result into a host array of length N.

You will have to run a loop to investigate what happens when the value of N increases by factors of 2 from N=210 to N=220 . Specifically, report in a plot the amount of time (inclusive and exclusive) it takes for the program to add the two arrays as a function of the array size.

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

10. For inclusive timing, stop the timing now

11. Report the amount of time required to complete the job 12.Confirm that the numbers in refC and hC are identical within 1E-12



##Problem 2

Write an MPI program that utilizes 16 processes to do one thing: process 0 will send to the other 15 processes an array of data. Specifically, transfer from process 0 to the other processes 20 bytes; 21 bytes; 22 bytes; ...; 230 bytes. Generate a plot that shows the amount of time required by each of these transfers. Do not register the amount of time necessary to allocate memory. You might want to allocate memory once, for the most demanding case (230 bytes), and then use it for all the other data transfer cases.

Compare (on the same plot) two scenarios:

1. You use a MPI_Bcast operation to transfer the data

2. You use a for-loop to carry out the data transfer using point-to-point Send/Receive operations

You should use the MPI_Ssend flavor of the send operation to endure synchronization of the send/receive operation. This is just to make sure things are fair for small data transactions, when the data might be buffered by OpenMPI for you. In other words, we are enforcing a “rendezvous” always policy and not get tricked by “eager” mode transfers.