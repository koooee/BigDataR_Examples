#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Minor Modifications: Nick Kolegraff (only to work with BigDataR)

# TO RUN: ./pmf.sh


WORK_DIR=/tmp
DATASET=movielense_mm.mahout.txt
DATASET_FULL_PATH=/home/play/Datasets/Mahout/movielens_mm.mahout.txt

# are we running local or hadoop?
if [ `jps | cut -d" " -f2 | grep -c ^NameNode` -eq 1 ]; then # we have hadoop running
    # ensure the dataset exists
    (hadoop fs -put $DATASET_FULL_PATH $DATASET 2>&1) > /dev/null
fi

echo "creating work directory at ${WORK_DIR}"
mkdir -p ${WORK_DIR}/movielens

# create a 90% percent training set and a 10% probe set
mahout splitDataset --input $DATASET --output ${WORK_DIR}/dataset \
    --trainingPercentage 0.9 --probePercentage 0.1 --tempDir ${WORK_DIR}/dataset/tmp

# run distributed ALS-WR to factorize the rating matrix defined by the training set
mahout parallelALS --input ${WORK_DIR}/dataset/trainingSet/ --output ${WORK_DIR}/als/out \
    --tempDir ${WORK_DIR}/als/tmp --numFeatures 20 --numIterations 10 --lambda 0.065

# compute predictions against the probe set, measure the error
mahout evaluateFactorization --input ${WORK_DIR}/dataset/probeSet/ --output ${WORK_DIR}/als/rmse/ \
    --userFeatures ${WORK_DIR}/als/out/U/ --itemFeatures ${WORK_DIR}/als/out/M/ --tempDir ${WORK_DIR}/als/tmp

# compute recommendations
mahout recommendfactorized --input ${WORK_DIR}/als/out/userRatings/ --output ${WORK_DIR}/recommendations/ \
    --userFeatures ${WORK_DIR}/als/out/U/ --itemFeatures ${WORK_DIR}/als/out/M/ \
    --numRecommendations 6 --maxRating 5

# print the error
echo -e "\nRMSE is:\n"
cat ${WORK_DIR}/als/rmse/rmse.txt
echo -e "\n"

echo -e "\nSample recommendations:\n"
shuf ${WORK_DIR}/recommendations/part-m-00000 | head
echo -e "\n\n"