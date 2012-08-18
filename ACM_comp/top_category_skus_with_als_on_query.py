import sys
import numpy
import csv

help = """
this script takes two parameters, the file path to matrix U and matrix V from pmf.sh
usage: python gen_recommendations.py /path/to/matrix/U /path/to/matrix/V
"""

predictions = open('/mnt/predictions', 'w')

# when we dont have enough recommendations -- randomly select these
top_skus = list()
tap_out = csv.reader(open('/mnt/best_five'))
for row in tap_out:
    top_skus.append(row[0])

# category top 5 predictions
categories = dict(list())
category_file = csv.reader(open('/mnt/top_5_skus_by_category'))
for line in category_file:
    try:
        categories[line[0]].append(line[1])
    except KeyError:
        categories[line[0]] = list()
        categories[line[0]].append(line[1])

# convert the strings to floats and do the dot product of vectors
# this will return our prediction
def convert_and_multiply(u, v):
    return(numpy.dot(map(float, u.split()), map(float, v.split())))

# Open the files and catch all errors
try:
    U = open("/mnt/query_matrix.matrix.market-20-11.out.U")
    V = open("/mnt/query_matrix.matrix.market-20-11.out.V")
except:
    print help


# Bit of cleanup, we do [4:] because we want to skip the first 3 lines in the file
# that contain header information
Ua = map(lambda s: s.replace("\n", ""), U.readlines()[4:]);
Va = map(lambda s: s.replace("\n", ""), V.readlines()[4:]);

f = open('/mnt/big_data_test_file', 'r')
for line in f.readlines():
    top5=[0]*5
    recs=[0]*5
    line_a = line.strip().split(",")
    if line_a[1] != '':
        x = 1
        # # preform prediction from als for this query since it existed in the training set
        for j,sku in enumerate(Va):
            p = convert_and_multiply(Ua[int(line_a[1])], sku)
            m = min(top5)
            if p > m:
                idx = top5.index(m)
                top5[idx] = p
                recs[idx] = j
        
        for item in recs:
            print str(item)
            predictions.write(str(item) + "\t")

        predictions.write('\n')

    else:
        # we haven't seen this query before
        # recommend from our category top 5
        count = 0
        length = 0

        try:
            length = len(categories[line_a[2]])
        except:
            length=0

        if length == 0:
            for item in tap_out:
                predictions.write(str(item) + "\t")

            predictions.write('\n')

        else:
            while len(categories[line_a[2]]) < 5:
                categories[line_a[2]].append(top_skus[count])
                count += 1
                
            for item in categories[line_a[2]]:
                predictions.write(str(item) + "\t")
                
            predictions.write('\n')
            
        
        
    
