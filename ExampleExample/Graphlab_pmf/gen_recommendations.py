# This file will read in the pmf example output from grahplab and generate recommendations for each user
# this code was meant to be used for example purposes only, it is a VERY naive approach and won't scale for
# a large number of users, please only use it as an example to see the vector multiplication

import sys
import numpy

help = """
this script takes two parameters, the file path to matrix U and matrix V from pmf.sh
usage: python gen_recommendations.py /path/to/matrix/U /path/to/matrix/V
"""

# convert the strings to floats and do the dot product of vectors
# this will return our prediction
def convert_and_multiply(u, v):
    return(numpy.dot(map(float, u.split()), map(float, v.split())))

# Open the files and catch all errors
try:
    U = open(sys.argv[1])
    V = open(sys.argv[2])
except:
    print help


# Bit of cleanup, we do [4:] because we want to skip the first 3 lines in the file
# that contain header information
Ua = map(lambda s: s.replace("\n", ""), U.readlines()[4:]);
Va = map(lambda s: s.replace("\n", ""), V.readlines()[4:]);


############################################ DISCLAIMER ############################################################
# this is a really silly approach and shouldn't be used in practice, ever, for large scale problems                #
# unless you are ok with waiting for a really, really long time.                                                   #
# Why? Consider a case with 1 million users and 50K items, you'd be doing 50 Billion computations one by one.      #
# see you in a few weeks/months :-)                                                                                #
# plus, you generally don't need to compute recommendations for ever user,item pair.                               #
####################################################################################################################

# Iterate through ever user and movie pair.
for i,user in enumerate(Ua):
    topten = [0]*10
    recs = [0]*10

    for j,movie in enumerate(Va):
        p = convert_and_multiply(user, movie)
        m = min(topten)
        if p > m:
            idx = topten.index(m)
            topten[idx] = p
            recs[idx] = j
    
    print "Recommendations for user {0} {1}".format(i, recs)

