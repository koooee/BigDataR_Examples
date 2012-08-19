# Extract the query matrix
# convert it to matrix market format for graphlab
# run als to get matrix decomposition of query features and product features to use for prediction

# no need to run this since these exist on the image 
#psql -f query_and_click_matrix.sql acm;

../helpers/convert_to_matrix_market_format.sh /mnt/query_matrix

# Get the number of cpus for graphlab
cpus=$(cat /proc/cpuinfo | grep -c processor)


pushd /mnt # Ensure graphlab writes to /mnt
pmf /mnt/query_matrix.matrix.market 0 --scheduler="round_robin(max_iterations=10,block_size=1)" --matrixmarket=true --lambda=0.065 --ncpus $cpus
popd