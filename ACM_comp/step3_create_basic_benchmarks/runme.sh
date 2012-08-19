(psql -f best_five.sql acm 2>&1) > /dev/null
if [ $? -eq 0 ]; then echo "Created Best 5 Benchmark"; else echo "FAILED. Creating best 5 benchmark failed.  Does it already exist? Do the tables it needs exist?"; fi

(psql -f top_by_category.sql acm 2>&1) > /dev/null
if [ $? -eq 0 ]; then echo "Created Best 5 Category Benchmark"; else echo "FAILED. Creating best 5 category benchmark failed.  Does it already exist? Do the tables it needs exist?"; fi