# Project Living Index - Dhivya Sivaramakrishnan, Mangesh Bhangare


from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext, DataFrame, Row
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, FloatType
from pyspark.sql.functions import *

import sys

def main():
    conf = SparkConf().setAppName('ETL on Socio-Economic and Crime Data using HiveQL')
    sc = SparkContext(conf=conf)
    assert sc.version >= '1.5.1'
    sqlContext = SQLContext(sc)

    input_crime = sys.argv[1]
    input_socio = sys.argv[2]
    output = sys.argv[3]

    # read the Crime data from CSV file and build a schema
    crime_schema = StructType([StructField('ID', IntegerType(), False), StructField('Case_Number', StringType(), False),
                               StructField('Date', StringType(), False), StructField('Block', StringType(), False),
                               StructField('IUCR', StringType(), False), StructField('Primary_Type', StringType(), False),
                               StructField('Description', StringType(), False), StructField('Location_Description', StringType(), False),
                               StructField('Year', IntegerType(), False), StructField('Community_Code', StringType(), True),
                               StructField('X_Coordinate', StringType(), True), StructField('Y_Coordinate', StringType(), True),
                               StructField('Latitude', FloatType(), True), StructField('Longitude', FloatType(), True)])
    crime_csv = sqlContext.read.format('com.databricks.spark.csv').options(header='true').load(input_crime, schema=crime_schema)
    crime_csv_temp1 = crime_csv.filter(crime_csv['Community_Code'] != '')
    crime_csv_temp = crime_csv_temp1.filter(crime_csv['X_Coordinate'] != '')
    crime_csv_temp.registerTempTable('crime_table_temp')
    crime_data = sqlContext.sql("""SELECT Community_Code, count(IUCR) as Crime_Frequency
                                        FROM crime_table_temp
                                        WHERE Year >= 2011
                                        GROUP BY Community_Code""")
    crime_data.registerTempTable('crime_table')

    # read the Socio-Economic Indices data from CSV file and build a schema
    socio_schema = StructType([StructField('Community_Code', StringType(), True), StructField('Community_Area', StringType(), False),
                              StructField('Housing_Crowded', FloatType(), False), StructField('Household_BPL', FloatType(), False),
                               StructField('Unemployed', FloatType(), False), StructField('Without_Diploma', FloatType(), False),
                               StructField('Age_Bar', FloatType(), False), StructField('Per_Capita_Income', IntegerType(), False),
                               StructField('Hardship_Index', IntegerType(), False)])
    socio_csv_temp = sqlContext.read.format('com.databricks.spark.csv').options(header='true').load(input_socio, schema=socio_schema)
    socio_csv = socio_csv_temp.filter(socio_csv_temp['Community_Code'] != '')
    socio_csv.registerTempTable('socio_table')

    # join the Crime and Socio-Economic data tables based on Community Area Code
    living_index_data = sqlContext.sql("""SELECT socio.Community_Code, crime.Crime_Frequency,
                                          socio.Housing_Crowded, socio.Household_BPL,
                                          socio.Unemployed, socio.Without_Diploma,
                                          socio.Age_Bar, socio.Per_Capita_Income, socio.Hardship_Index
                                          FROM crime_table crime JOIN socio_table socio
                                          ON crime.Community_Code = socio.Community_Code
                                          ORDER BY socio.Community_Code""")
    living_index_data.saveAsParquetFile(output+"/living_index.kmeans_parquet")

if __name__ == "__main__":
 main()