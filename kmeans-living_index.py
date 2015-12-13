# Project Living Index - Dhivya Sivaramakrishnan, Mangesh Bhangare

from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext, DataFrame, Row
from pyspark.mllib.clustering import KMeans, KMeansModel
from numpy import array
from math import sqrt

import sys

conf = SparkConf().setAppName('K-Means clustering of Socio-Economic factors and Crime factors using MLlib')
sc = SparkContext(conf=conf)
assert sc.version >= '1.5.1'
sqlContext = SQLContext(sc)

input_living_index = sys.argv[1]

# Read the parquet data and convert to RDD
parquet_living_index = sqlContext.read.parquet(input_living_index)
parquet_living_index.registerTempTable("living_index_table")
living_index_table = sqlContext.sql("SELECT * FROM living_index_table")
living_index_rdd = living_index_table.map(lambda colName: (str(colName.Community_Code) + "," + str(colName.Crime_Frequency)
                                                              + "," + str(colName.Housing_Crowded) + "," + str(colName.Household_BPL)
                                                              + "," + str(colName.Unemployed) + "," + str(colName.Without_Diploma)
                                                              + "," + str(colName.Age_Bar) + "," + str(colName.Per_Capita_Income)
                                                              + "," + str(colName.Hardship_Index)))

# K-means does multiple runs to find the optimal cluster center, so cache the input to K-means
cluster_input = living_index_rdd.map(lambda line: array([float(x) for x in line.split(',')])).cache()

# Perform K-means clustering
clusters = KMeans.train(cluster_input, 20, maxIterations=5,
        runs=5, initializationMode="random")

# Compute squared error and change cluster centers
def squared_error(point):
    center = clusters.centers[clusters.predict(point)]
    return sqrt(sum([x**2 for x in (point - center)]))

error = cluster_input.map(lambda point: squared_error(point)).reduce(lambda x, y: x + y)
print("Squared error for a cluster = " + str(error))

# Save the cluster model
clusters.save(sc, "myModel_living-index")
sameModel = KMeansModel.load(sc, "myModel_living-index")
