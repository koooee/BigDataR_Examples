# Test how good your predictions are for the ACM hackathon on bestbuy data 2012
# Take a random sample of the trainnig data
# Split it to a train and test set
# Use that to compute MAP

# usage: python test.py test_file prediction file num_iterations
import sys
import os
import csv
import numpy

help = """
usage: python test.py test_file predictions_file
"""

maps = []  # Final list of evaluation metrics

def ap(sku, sku_list):
    try:
        return (1.0 / float(sku_list.index(sku)+1))
    except ValueError:
        return 0.0

for iteration in range(1, 11):
    print "Running Iteration {0}".format(iteration)
    print "Sampling Data ..."
    if os.system("(psql -f random_sample.sql acm 2>&1) > /dev/null") != 0:
        print "Failed to run random sampling"
        sys.exit(1)

    print "Extracting Query Matrix ..."
    if os.system("(psql -f extract_query_click_matrix.sql acm 2>&1) > /dev/null") != 0:
        print "Failed to run query matrix extraction"
        sys.exit(1)
    
    try:
        # Baseline Popular Skus
        # test_file = csv.reader(open('/mnt/small_data/test_small.csv'))
        # predictions_file = csv.reader(open('/mnt/popular_skus.csv'), delimiter=" ")

        # My Baseline
        test_file = csv.reader(open('/mnt/small_data_random_test'))
        predictions_file = csv.reader(open('/mnt/small_data_predictions'), delimiter=" ")
    except:
        print "Could not open your input files.  Do they exist? Do you have permissions?"
        sys.exit(0)


    # we don't need the header
    predictions_file.next()

# this is a VERY crude form of calculating precision
# I wanted this to be easy enough to understand, yet allow you to expand it if needed.
    true_positives = 0
    false_positives = 0
    precisions = []
    aps = []
    row_count = 0
    for i,row in enumerate(test_file):
        row_count += 1
        sku = str(row[2])
        predictions = predictions_file.next()
        if sku in predictions:
            true_positives +=1
        else:
            false_positives += 1
        
        average_precision = ap(sku, predictions)
        #print "precision at {0} is {1}".format(p_at, precision)
        aps.append(average_precision)
        maps.append(average_precision)


    print "TP: {0}".format(true_positives)
    print "FP: {0}".format(false_positives)
    print "Precision: {0}".format(float(true_positives) / (float(true_positives) + float(false_positives)))
    map_at_5 = sum(aps) / float(len(aps))
    print "MAP@5 = {0}".format(map_at_5)
    maps.append(map_at_5)


print "MAP across iterations: {0}".format(numpy.mean(map_at_5))
