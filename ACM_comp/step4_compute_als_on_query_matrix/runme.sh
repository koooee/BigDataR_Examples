#!/bin/bash -e
# Extract the query matrix
# convert it to matrix market format for graphlab
# run als to get matrix decomposition of query features and product features to use for prediction

# no need to run this since these exist on the image 
(psql -f query_and_click_matrix.sql acm 2>&1) > /dev/null
if [ $? -eq 0 ]; then echo "Created query and click matrix"; else echo "Didn't create query and click matrix, check if they already exist"; fi

../helpers/convert_to_matrix_market_format.sh /mnt/query_matrix

# Get the number of cpus for graphlab
cpus=$(cat /proc/cpuinfo | grep -c processor)


pushd /mnt # Ensure graphlab writes to /mnt
pmf /mnt/query_matrix.matrix.market 0 --scheduler="round_robin(max_iterations=10,block_size=1)" --matrixmarket=true --lambda=0.065 --ncpus $cpus

if [ -f output ]; then rm output; fi
if [ -f outpute ]; then rm outpute; fi

ln -s /mnt/*.U /mnt/output
ln -s /mnt/*.V /mnt/outpute

echo -n "Generating Recommendations from the query matrix ... "
(glcluster /mnt/output 8 5 0 --matrixmarket=true --training_ref='/mnt/query_matrix.matrix.market' --ncpus=$cpus 2>&1) > /dev/null
if [ $? -eq 0 ]; then echo "Done."; else echo "Error Generating Query Recommendations.  Make sure these files exist /mnt/*.V and /mnt/*.U otherwise the factorization didn't work properly"; fi
popd