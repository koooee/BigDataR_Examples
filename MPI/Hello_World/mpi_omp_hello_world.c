#include <stdio.h>
#include <mpi.h>
#include <omp.h>

int main(int argc, char *argv[])
{
  int pid, num_pids;

  MPI_Init(&argc, &argv); /* Start MPI */
  MPI_Comm_rank (MPI_COMM_WORLD, &pid); /* get the process id */
  MPI_Comm_size (MPI_COMM_WORLD, &num_pids); /* get the number of processes */
  printf( "mpi process %d of %d\n", pid, num_pid );

  /* OMP is an api that allows multi-core programming through use of compiler directives */
  #pragma omp parallel
  printf("omp thread %d\n", omp_get_thread_num()); /* This should print a line for every core on the processor */
  

  MPI_Finalize(); /* Kill MPI Environment */
  return 0;
}
