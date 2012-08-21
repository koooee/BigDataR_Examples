# Test how good your predictions are for the ACM hackathon on bestbuy data 2012

# usage: python test.py test_file prediction file

import csv

help = """
usage: python test.py test_file predictions_file
"""

try:
    test_file = csv.reader(open('/mnt/small_data_test'))
    predictions_file = csv.reader(open('/mnt/small_predictions'), delimiter=" ")
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
for i,row in enumerate(test_file):
    row = row.strip().split(" ")
    sku = str(row[0])
    predictions = predictions_file.next().strip().split(' ')
    if sku in predictions:
        true_positives +=1
    else:
        false_positives += 1

print true_positives / (true_positives + false_negitives)
    
    



