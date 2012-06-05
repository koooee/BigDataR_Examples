# Compile The example and execute it on the MPI cluster
# -fopenmp enables omp support
# mpicc will compile and link mpi programs properly
# mpiexec is an alias for BigDataR linux that is auto configured based on the number of nodes for the cluster configuration
#         you can view it's contents by cat ~/.bash_aliases | grep mpiexec

mpicc -fopenmp -o hello mpi_omp_hello_world.c
echo "Now run this command: mpiexec $PWD/hello"