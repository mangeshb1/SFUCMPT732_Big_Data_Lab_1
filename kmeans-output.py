# Project Crime/Living Index - Dhivya Sivaramakrishnan, Mangesh Bhangare

from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext, DataFrame, Row

import sys

conf = SparkConf().setAppName('Output of K-Means clustering')
sc = SparkContext(conf=conf)
assert sc.version >= '1.5.1'
sqlContext = SQLContext(sc)

input_cluster = sys.argv[1]
output = sys.argv[2]
 
# Read the parquet data (output of K-means) and convert to RDD 
parquet_cluster = sqlContext.read.parquet(input_cluster)
parquet_cluster.registerTempTable("cluster_data")
cluster_output = sqlContext.sql("SELECT * FROM cluster_data")

# Save the result as a text file containing tuples
cluster_tuple = cluster_output.rdd.map(tuple)
cluster_output = cluster_tuple.saveAsTextFile(output)
