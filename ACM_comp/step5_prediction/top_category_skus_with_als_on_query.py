import sys
import numpy
import csv

print "Reading in files from /mnt"

predictions = open('/mnt/predictions', 'w')
test_file = open('/mnt/big_data_test_file', 'r')
query_recs = open('/mnt/output5.recommended-items.mtx')
sku_id_lookup_file = csv.reader(open('/mnt/sku_mapping'))

sku_id_lookup = {}
for row in sku_id_lookup_file:
    sku_id_lookup[str(row[1])] = str(row[0])

# when we dont have enough recommendations -- randomly select these
tap_out = csv.reader(open('/mnt/best_five'))
top_skus = [row[0] for row in tap_out]

# category top 5 predictions
categories = dict(list())
category_file = csv.reader(open('/mnt/top_5_skus_by_category'))
for line in category_file:
    try:
        categories[line[0]].append(line[1])
    except KeyError:
        categories[line[0]] = list()
        categories[line[0]].append(line[1])

# burn the first 4 since this is the matrix market header
query_recs_mapping = [v.strip().split('      ')  for k,v in enumerate(query_recs.read().split('\n')) if k > 3]
query_recs_mapping = [[item.strip() for item in row] for row in query_recs_mapping]

# helper function to lookup a real sku from its sku id
def sku_lookup(s):
    try:
        return str(sku_id_lookup[str(s)])
    except:
        print "ERROR: this sku {0} does not exist!".format(s)
        sys.exit(0)

print "Generating Predictions ..."
for line in test_file.readlines():
    line_a = line.strip().split(",")
    if line_a[1] != '':
        predictions.write(" ".join(map(sku_lookup, query_recs_mapping[int(line_a[1])])) + "\n")
    else:
        # we haven't seen this query before
        # recommend from our category top 5
        count = 0
        length = 0

        try:
            length = len(categories[line_a[2]])
        except:
            length = 0

        # we haven't seen this category before so just output the top 5 skus
        if length == 0:
            predictions.write(" ".join(map(str, top_skus)) + "\n")

        # otherwise, use the top 5 skus in this category
        # notice, some categories don't have more than 5 skus so we just fill
        # the empty ones with the top 5 skus
        else:
            while len(categories[line_a[2]]) < 5:
                categories[line_a[2]].append(top_skus[count])
                count += 1
            
            predictions.write(" ".join(categories[line_a[2]]) + "\n")

print "Done!  your submission file is here /mnt/predictions"
