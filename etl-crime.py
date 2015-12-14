# Project Crime - Dhivya Sivaramakrishnan, Mangesh Bhangare

from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext, DataFrame, Row
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, FloatType
from pyspark.sql.functions import *

import sys

def main():
    conf = SparkConf().setAppName('ETL on Crime Data using HiveQL')
    sc = SparkContext(conf=conf)
    assert sc.version >= '1.5.1'
    sqlContext = SQLContext(sc)
 
    input_crime = sys.argv[1]
    input_iucr = sys.argv[2]
    output = sys.argv[3]

    # read the crime data from CSV file and build a schema
    crime_schema = StructType([StructField('ID', IntegerType(), False), StructField('Case_Number', StringType(), False),
                               StructField('Date', StringType(), False), StructField('Block', StringType(), False),
                               StructField('IUCR', StringType(), False), StructField('Primary_Type', StringType(), False),
                               StructField('Description', StringType(), False), StructField('Location_Description', StringType(), False),
                               StructField('Year', IntegerType(), False), StructField('Community_Code', StringType(), True),
                               StructField('X_Coordinate', StringType(), True), StructField('Y_Coordinate', StringType(), True),
                               StructField('Latitude', StringType(), False), StructField('Longitude', StringType(), False)])
    crime_csv_temp = sqlContext.read.format('com.databricks.spark.csv').options(header='true').load(input_crime, schema=crime_schema)
    crime_csv = crime_csv_temp.filter(crime_csv_temp['X_Coordinate'] != '').filter(crime_csv_temp['Community_Code'] != '')
    crime_csv.registerTempTable('crime_table')

    # read the IUCR code data from CSV file and build a schema
    iucr_schema = StructType([StructField('IUCR', StringType(), False), StructField('Primary_Description', StringType(), False),
                              StructField('Secondary_Description', StringType(), False), StructField('Index_Code', StringType(), False)])
    iucr_csv = sqlContext.read.format('com.databricks.spark.csv').options(header='true').load(input_iucr, schema=iucr_schema)
    iucr_csv.registerTempTable('iucr_table')

    # join the Crime and IUCR tables based on IUCR (crime) code and type of criminal activity
    crime_data = sqlContext.sql("""SELECT crime.Date, crime.IUCR, iucr.Primary_Description,
                                   crime.Description, crime.Location_Description, iucr.Index_Code,
                                   crime.Year, crime.Latitude, crime.Longitude,
                                   crime.X_Coordinate, crime.Y_Coordinate
                                   FROM crime_table crime JOIN iucr_table iucr
                                   ON crime.IUCR = iucr.IUCR AND crime.Description = iucr.Secondary_Description
                                   ORDER BY crime.Date""")
    crime_data.registerTempTable('crime_table_groupBy')

    # use group by query to find the annual frequency of different crimes in an area
    crime_groupByIUCR = sqlContext.sql("""SELECT Year, Latitude, Longitude, count(IUCR) as Crime_Frequency
                                          FROM crime_table_groupBy
                                          GROUP BY Year, Latitude, Longitude""")
    crime_groupByIUCR.saveAsParquetFile(output+"/crime_parquet")

if __name__ == "__main__":
 main()