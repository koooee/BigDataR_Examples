#include <stdio.h>
#include <mpi.h>
#include <omp.h>

int main(int argc, char *argv[])
{
  int pid, num_pids, nodesize;
  char nodename[MPI_MAX_PROCESSOR_NAME];

  MPI_Init(&argc, &argv); /* Start MPI */
  MPI_Comm_rank(MPI_COMM_WORLD, &pid); /* Get the current process id */
  MPI_Comm_size(MPI_COMM_WORLD, &num_pids); /* Get the total number of processes */
  MPI_Get_processor_name(nodename, &nodesize); /* Get the hostname of the current process */

  printf( "mpi process %d of %d on node %s\n", pid, num_pids, nodename);

  /* openMP is an api that allows multi-core programming through use of compiler directives */
  #pragma omp parallel /* Tell the compiler to do this for every core on the processor */
  {
    printf("omp thread %d on node %s\n", omp_get_thread_num(), nodename); /* This should print a line for every core on the processor */
  } /* END omp parallel region */

  MPI_Finalize(); /* Kill MPI Environment */
  return 0;
}
