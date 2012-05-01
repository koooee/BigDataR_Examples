pmf /home/play/Datasets/Graphlab/movielens_mm 0 --scheduler="round_robin(max_iterations=10,block_size=1)" --matrixmarket=true --lambda=0.065 --ncpus=2

# The first parameter '/home/play/movielens_mm' is a path to the original matrix you want to compute a factorization on.
# The second parameter '0' is stating you want to use the 'ALS' factorization technique (there are many avaliable)
# The rest of the parameters were described in the README file but placed here for reference.
#	    --scheduler - this is how tasks will be computed
#	    		  this give us parallelism and control 
#			  over how to compute things
#			  round_robin -- loop
#			  max_iterations -- number of times
#			  block_size -- number of tasks to compute at a time
#	    --matrix-market - tell graphlab that we are giving it 
#	    		      a matrix in 'matrix market format' 
#			      so it knows how to read it
#	    --lambda - this is a weight that will be applied to your 
#	    	       matrix vectors, optimal value is found through 
#		       trial and error
#	    --npus - the number of cpus/cores to use in the computation

