import sys
import numpy
import csv


print "Reading in files from /mnt"


if len(sys.argv) != 2:
    print "usage: python predictions.py PREFIX_FOR_FILES"
    sys.exit(1)

prefix=sys.argv[1]
help = """
make sure these exact files exist:
/mnt/{0}query_matrix.matrix.market-20-11.out.U
/mnt/{0}query_matrix.matrix.market-20-11.out.V
""".format(prefix)

# Open some files
predictions = open("/mnt/{0}_predictions".format(prefix), 'w')
predictions.write("sku\n")
sku_id_lookup_file = csv.reader(open("/mnt/{0}_sku_mapping".format(prefix)))
test = open("/mnt/{0}_random_test".format(prefix), 'r')

# Build a lookup for sku_id conversions to sku
sku_id_lookup = {}
for row in sku_id_lookup_file:
    sku_id_lookup[str(row[1])] = str(row[0])

# when we dont have enough recommendations -- use these
tap_out = csv.reader(open("/mnt/{0}_best_five".format(prefix)))
top_skus = [row[0] for row in tap_out]

# category top 5 predictions -- when we dont have a query, use these
categories = dict(list())
category_file = csv.reader(open("/mnt/{0}_top_5_skus_by_category".format(prefix)))
for line in category_file:
    try:
        categories[line[0]].append(line[1])
    except KeyError:
        categories[line[0]] = list()
        categories[line[0]].append(line[1])


# lookup a real sku from its sku id
def sku_lookup(s):
    try:
        return str(sku_id_lookup[str(s)])
    except:
        print "ERROR: this sku {0} does not exist!".format(s)
        sys.exit(0)


# convert the strings to floats and do the dot product of vectors
# this will return our prediction from als
def convert_and_multiply(u, v):
    return(numpy.dot(map(float, u.split()), map(float, v.split())))

# Open the files and catch all errors
try:
    U = open("/mnt/{0}_query_matrix.matrix.market-20-11.out.U".format(prefix))
    V = open("/mnt/{0}_query_matrix.matrix.market-20-11.out.V".format(prefix))
except:
    print help


# Bit of cleanup, we do [4:] because we want to skip the first 3 lines in the file
# that contain header information
Ua = map(lambda s: s.replace("\n", ""), U.readlines()[4:]);
Va = map(lambda s: s.replace("\n", ""), V.readlines()[4:]);



print "Generating Predictions ..."
prediction_cache = {}
for line in test.readlines():
    top5=[0]*5
    recs=[0]*5
    line_a = line.strip().split(",")
    if line_a[3] != '':
        x = 1
        # Before we do this expensive prediction .. lets see if this query exists in the cache
        if line_a[3] in prediction_cache:
            predictions.write(" ".join(map(sku_lookup, prediction_cache[line_a[3]])) + "\n")
        else:
        # # preform prediction from als for this query since it existed in the training set
            for j,sku_features in enumerate(Ua):
                p = convert_and_multiply(Va[int(line_a[3])], sku_features)
                m = min(top5)
                if p > m:
                    idx = top5.index(m)
                    top5[idx] = p
                    recs[idx] = j+1
                    # Need to do this since we are using MAP
                    top5.sort(reverse=True)

            temp = sorted(zip(recs, top5), key=lambda k: k[1])
            recs, top5 = zip(*temp)
            predictions.write(" ".join(map(sku_lookup, recs)) + "\n")

    else:
        # we haven't seen this query before
        # recommend from our category top 5
        count = 0
        length = 0

        try:
            length = len(categories[line_a[2]])
        except:
            length = 0

        if length == 0:
            print "BEST 5"
            predictions.write(" ".join(map(str, top_skus)) + "\n")

        else:
            print "CAT 5"
            while len(categories[line_a[2]]) < 5:
                categories[line_a[2]].append(top_skus[count])
                count += 1
            
            predictions.write(" ".join(categories[line_a[2]]) + "\n")

print "Done!  your submission file is here /mnt/{0}_predictions".format(prefix)
