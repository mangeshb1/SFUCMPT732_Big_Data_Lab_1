# Project Crime - Dhivya Sivaramakrishnan, Mangesh Bhangare

from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext, DataFrame, Row
from pyspark.mllib.clustering import KMeans, KMeansModel
from numpy import array
from math import sqrt

import sys

conf = SparkConf().setAppName('K-Means clustering of Crime Data using MLlib')
sc = SparkContext(conf=conf)
assert sc.version >= '1.5.1'
sqlContext = SQLContext(sc)

# Read the input parquet
input_crime = sys.argv[1]

# Read the parquet data and convert to RDD
parquet_crime = sqlContext.read.parquet(input_crime)
parquet_crime.registerTempTable("crime_table")
crime_table = sqlContext.sql("SELECT * FROM crime_table")
crime_rdd = crime_table.map(lambda line: str(line.Year) + "," + str(line.Latitude) + ","
                                       + str(line.Longitude) + "," + str(line.Crime_Frequency))

# K-means does multiple runs to find the optimal cluster center, so cache the input to K-means
cluster_input = crime_rdd.map(lambda line: array([float(x) for x in line.split(',')])).cache()

# Perform K-means clustering
clusters = KMeans.train(cluster_input, 20, maxIterations=5,
        runs=5, initializationMode="random")

# Compute root mean squared error and change cluster centers
def squared_error(point):
    center = clusters.centers[clusters.predict(point)]
    return sqrt(sum([x**2 for x in (point - center)]))

error = cluster_input.map(lambda point: squared_error(point)).reduce(lambda x, y: x + y)
print("Squared error for a cluster = " + str(error))

# Save the cluster output into parquet files
clusters.save(sc, "myModel_crime")
sameModel = KMeansModel.load(sc, "myModel_crime")
