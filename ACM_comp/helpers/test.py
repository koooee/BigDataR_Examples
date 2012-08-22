# Test how good your predictions are for the ACM hackathon on bestbuy data 2012
# Take a random sample of the trainnig data
# Split it to a train and test set
# Use that to compute MAP

# usage: python test.py test_file prediction file num_iterations

import csv
import numpy
help = """
usage: python test.py test_file predictions_file
"""
maps = []  # Final list of evaluation metrics
for i in range(1, 11):
    try:
        test_file = csv.reader(open('/mnt/small_data_random_test'))
        predictions_file = csv.reader(open('/mnt/small_data_predictions'), delimiter=" ")
    except:
        print "Could not open your input files.  Do they exist? Do you have permissions?"
        sys.exit(0)

    true_positives = 0
    false_positives = 0

    # we don't need the header
    test_file.next()
    predictions_file.next()

# this is a VERY crude form of calculating precision
# I wanted this to be easy enough to understand, yet allow you to expand it if needed.
    precisions = []
    for p_at in range(0, 5):
        for i,row in enumerate(test_file):
            sku = str(row[2])
            predictions = predictions_file.next()
            predictions = predictions[p_at:]
            if sku in predictions:
                true_positives +=1
            else:
                false_positives += 1
        precision = float(true_positives) / (float(true_positives + false_positives))
        print "precision at {0} is {1}".format(p_at, precision)
        precisions.append(precision)

    map_at_5 = numpy.mean(precisions)
    print "MAP@5 = {0} for iteration {1}".format(map_at_5, i)
    maps.append(map_at_5)

print "MAP across iterations: {0}".format(numpy.mean(maps))
