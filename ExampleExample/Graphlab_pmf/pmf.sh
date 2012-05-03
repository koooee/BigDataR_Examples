# This example will compute ALS on BigDataR Linux
# This was an example from Danny Bickson:
# http://graphlab.org/pmf.html

pmf /home/play/Datasets/Graphlab/movielens_mm 0 --scheduler="round_robin(max_iterations=10,block_size=1)" --matrixmarket=true --lambda=0.065 --ncpus=2

#	    --scheduler - this is how tasks will be computed
#	    		  this give us parallelism and control 
#			  over how to compute things
#			  round_robin -- cycle over users and items
#			  max_iterations -- number of times
#			  block_size -- should be 1
#	    --matrix-market - tell graphlab that we are giving it 
#	    		      a matrix in 'matrix market format' 
#			      so it knows how to read it
#	    --lambda - this is a weight that will be applied to your 
#	    	       matrix vectors, optimal value is found through 
#		       trial and error. prevents overfitting.
#	    --npus - the number of cpus/cores to use in the computation
#	    --D - the demension of the factorized matricies. too small
#	          results in fast run time but less accuracy. Too Large
#		  results in slow runtime but more accurate. Typical values
#		  are 20 -> 50.
#            --maxval - maximum value of allowed rating
#	    --minval - minimum value of allowed rating
