## Week 5: Batch Processing

### 5.1 Introduction

* :movie_camera: 5.1.1 [Introduction to Batch Processing](https://youtu.be/dcHe5Fl3MF8?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* :movie_camera: 5.1.2 [Introduction to Spark](https://youtu.be/FhaqbEOuQ8U?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

#### 5.1.1 Introduction to Batch Processing
* Processing data
  - Batch (80%)
  - Streaming (20%)
* The data is executed by job and then stored in a database
* Batch jobs
  - Weekly
  - Daily
  - Hourly
  - 3 times per hour
  - Every 5 minutes
* Technologies
  - Python Scripts > "Kubernetes, AWS Batch, Bytes Jobs"
  - SQL
  - Spark
  - Flink
* Workflow: estimate and get the essentially runtime in every step, & total times, delay time (retry), <br/>
    other process time such as metrics, .. (so minimum is daily is okay)
  - Lake CSV > Python > SQL(DBT) > Spark > Python
  - (Scale) For bigger file: bigger machine (Python), bigger cluster or add more machine (Spark)
* Advantages of Batch
  - Easy to manage
  - Retry
  - Scale
* Disadvantage
  - Delay

#### 5.1.2 Introduction to Spark
* Introduction: an open-source unified analytics engine and multi-languages for large-scale data processing (data engineering, data science, and machine learning on single-node machine or clusters.
* Data processing engine: Data Lake > Spark (Cluster: multi-machines) > Data Lake (DWH)
* High-level APIs: multi-languages such as PySpark, ..
* Spark for Batch and Streaming jobs
  - Batch jobs
  - Streaming
* When to use Spark?
  - DL (S3/GCS in Parquet format) > Spark > DL
  - Note: you also can express batch job as SQL such as Hive, Presto/Athena, BigQuery
* Workflow for Machine Learning
  - Workflow
  ```mermaid
  flowchart LR
    RawData --> Lake --> SQLAthena --> Spark --> PythonTrainML
    Spark --> SparkApplyML
    PythonTrainML --> Model
    Model --> SparkApplyML
    SparkApplyML --> DataLake
  ```
  * Note: Almost pre-processing is executed in express batch job (SQL)
### 5.2 Installation

Follow [these intructions](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_5_batch_processing/setup/) to install Spark:

* [Windows](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_5_batch_processing/setup/windows.md)
* [Linux](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_5_batch_processing/setup/linux.md)
* [MacOS](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_5_batch_processing/setup/macos.md)

And follow [this](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_5_batch_processing/setup/pyspark.md) to run PySpark in Jupyter

* :movie_camera: 5.2.1 [(Optional) Installing Spark (Linux)](https://youtu.be/hqUbB9c8sKg?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

#### 5.2.1 Installing Spark on Linux
* Installing Java
  - [Link](https://jdk.java.net/archive/)
  ```bash
  cd
  mkdir spark
  cd spark
  wget path
  tar xfzv filename
  export JAVA_HOME="${HOME}/spark/filename"
  export PATH="${JAVA_HOME}/bin:${PATH}"
  ```
* Installing Spark
  - [Link](https://spark.apache.org/downloads.html)
  ```bash
  wget path
  tar xfzv filename
  export SPARK_HOME="${HOME}/spark/filename"
  export PATH="${SPARK_HOME}/bin:${PATH}"
  ```
* .bashrc: add export lines to the end of the file
  ```bash
  nano .bashrc
  source .bashrc
  logout

  which java
  which pyspark
  ```
* Start jupyter
  ```bash
  mkdir notebooks
  cd notebooks
  jupyter notebook
  ```
* Setup PySpark
  ```bash
  export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
  export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9-src.zip:$PYTHONPATH"

  ls ${SPARK_HOME}/python/lib/
  export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.*-src.zip:$PYTHONPATH"
  ```
  ```jupyter notebook
  !wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv

  import pyspark
  pyspark.__version__

  from pyspark.sql import SparkSession
  from pyspark.context import SparkContext

  # connect to local master
  # coordinating jobs of a spark cluster
  # [] to specify the amount of CPUs to use
  spark = SparkSession.builder \
      .master("local[*]") \
      .appName('test') \
      .getOrCreate()
  
  sc = spark.sparkContext
  sc.setLogLevel('WARN')
  # sc.setLogLevel('info')
  
  df = spark.read \
      .option("header", "true") \
      .csv('taxi+_zone_lookup.csv')

  df.show()

  df.write.parquet('zones')
  
  !head taxi+_zone_lookup.csv

  !ls -lh
  ```
* Open port and Spark UI
  - http://localhost:8888/
  - http://localhost:4040/jobs/

### 5.3 Spark SQL and DataFrames

* :movie_camera: 5.3.1 [First Look at Spark/PySpark](https://youtu.be/r_Sf6fCB40c?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb) 
* :movie_camera: 5.3.2 [Spark Dataframes](https://youtu.be/ti3aC1m3rE8?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* :movie_camera: 5.3.3 [(Optional) Preparing Yellow and Green Taxi Data](https://youtu.be/CI3P4tAtru4?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

Script to prepare the Dataset [download_data.sh](code/download_data.sh)

**Note**: The other way to infer the schema (apart from pandas) for the csv files, is to set the `inferSchema` option to `true` while reading the files in Spark.

* :movie_camera: 5.3.4 [SQL with Spark](https://www.youtube.com/watch?v=uAlp2VuZZPY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

#### 5.3.1 First Look at Spark/PySpark
* Reading CSV files
  - Spark dataframe read csv file
  ```jupyter notebook
  # get schema
  df.schema

  from pyspark.sql import types
  # note: the boolean indicates that columm value can be nullable
  schema = types.StructType([
    types.StructField('hvfhs_license_num', types.StringType(), True), 
    types.StructField('dispatching_base_num', types.StringType(), True), 
    types.StructField('pickup_datetime', types.TimestampType(), True), 
    types.StructField('dropoff_datetime', types.TimestampType(), True), 
    types.StructField('PULocationID', types.IntegerType(), True), 
    types.StructField('DOLocationID', types.IntegerType(), True), 
    types.StructField('SR_Flag', types.StringType(), True)
  ])

  # read file again with schema
  df = spark.read \
    .format("csv") \
    .schema(schema) \
    .option("compression", "gzip") \
    .option("header", "true") \
    .load('fhvhv_tripdata_2021-01.csv.gz')
  ```
* Partitions
  ```jupyter notebook
  # DataLake (file1, file2, ..) --> Cluster pull using executors (executor1, executor2, ..)
  # and because one data file can be pull by one executor at the same time
  # so partition large file into many small files to can maximum optimization
  df.repartition(24)
  ```
* Saving data to Parquet for local experiments
  ```jupyter notebook
  df.write.parquet('fhvhv/2021/01/')
  ```
* Spark master UI
  - localhost:4040/jobs

#### 5.3.2 Spark DataFrames
* Actions vs transformations
  - Transformations - lazy (not executed immediately)
    - Selecting columns
    - Filtering
    - Joins
    - Group by
  - Actions: this evaluated to see the result -- eager (executed imediately)
    - Show, take, head
    - Write
* Functions and UDFs
  ```jupyter notebook
  from pyspark.sql import types
  from pyspark.sql import functions as F
  func_stuff_udf = F.udf(def_func, returnType=types.StringType())
  ```

#### 5.3.3 Preparing Yellow and Greeen Taxi Data
* /home/dtlam2601/de-zoomcamp/week_5_batch_processing/code/download_data.sh
  ```bash
  # change mode to executable
  chmod +x download_data.sh
  ./download_data.sh
  ./download_data.sh "yellow" 2021
  ```
* /home/dtlam2601/de-zoomcamp/week_5_batch_processing/code/5_taxi_schema

#### 5.3.4 SQL in Spark
* Read from green and yellow taxi parquet files
* Union both df_green_sel and df_yellow_sel (selected with common_columns) into df_trips_data with common_columns
  - common_columns = set(df_green.columns) & set(df_yellow.columns)
  - for loop join common columns
* Register sdf as table view: df_trips_data.createOrReplaceTempView('trips_data')
* Execute query sql: spark.sql("""SELECT * FROM trips_data""")
* Write results to parquet: 'data/report/revenue'

### 5.4 Spark Internals

* :movie_camera: 5.4.1 [Anatomy of a Spark Cluster](https://youtu.be/68CipcZt7ZA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* :movie_camera: 5.4.2 [GroupBy in Spark](https://youtu.be/9qrDsY_2COo&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* :movie_camera: 5.4.3 [Joins in Spark](https://youtu.be/lu7TrqAWuH4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

#### 5.4.1 Anatomy of a Spark Cluster
* Spark Driver, Master and Executors
  * Driver in machine: has package contains spark code (source code)
  * Master and Executors in Cluster:
    - The package is submited to master
    - Master send source code to the executors
    - Each executor pull data from packet file partition from the dataframe
      - Previously popular: Hadoop/HDFS
      - Now popular: S3/GCS (Cluster and Cloud Storage are in the same data center, so pull or also save the results back to the cloud storage is very fast)
  ```txt
  Driver submit a job --> master --> operator in an airflow --> coordinates everything, and executors are the machines that are doing actual computations,
  and spark keeps track of which machine are healthy and if some machine unhealthy, it reassigns the work,
  and we keep the data in cloud storage, we read from the cloud storage and writes the results back to the cloud storage.
  ```
  
#### 5.4.2 GroupBy in Spark
Two stages: GroupBy and Reshuffling
* How GroupBy works internally
  - Executor filter group each partition --> Sub-results
* Shuffling
  - Sub-results are reshuffling by the same key and combine into one
  
#### 5.4.3 Joins in Spark
* Joining two large tables
  - On the same key
* Merge sort join
* Joining one large and one small table
  - On the same key
* Broadcasting
  - Broadcast small table to all the executors

### 5.5 (Optional) Resilient Distributed Datasets

* :movie_camera: 5.5.1 [Operations on Spark RDDs](https://youtu.be/Bdu-xIrF3OM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* :movie_camera: 5.5.2 [Spark RDD mapPartition](https://youtu.be/k3uB2K99roI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

#### 5.5.1 Resilient Distributed Datasets: map and reduce
* What is RDD and how is it related to dataframes
  - Partitions: each executor executes each partition
  - DataFrame: has schema
  - RDDs: collections of objects
* From DataFrame to RDD
  ```jupyter
  rdd = df.select(..).rdd
  ```
* Operations on RDDs: map, filter, reduceByKey
  - WHERE vs .filter(): by row
  - GROUP BY vs .map()
  - Reduce By Key: left value and right value
* From RDD to DataFrame
  ```jupyter
  df_results = rdd.select().map().filter().map().toDF(results_schema)
  ```

#### 5.5.2 Spark RDD mapPartition

### 5.6 Running Spark in the Cloud

* :movie_camera: 5.6.1 [Connecting to Google Cloud Storage ](https://youtu.be/Yyz293hBVcQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* :movie_camera: 5.6.2 [Creating a Local Spark Cluster](https://youtu.be/HXBwSlXo5IA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* :movie_camera: 5.6.3 [Setting up a Dataproc Cluster](https://youtu.be/osAiAYahvh8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* :movie_camera: 5.6.4 [Connecting Spark to Big Query](https://youtu.be/HIm2BOj8C0Q&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

#### 5.6.1 Connecting to Google Cloud Storage
* Updating data to GCS
* Connecting Spark jobs to GCS

#### 5.6.2 Creating a Local Spark Cluster
* Creating the cluster
* Turning the notebook into the script
* Using spark-submit for submiting spark jobs

#### 5.6.3 Setting up a Dataproc Cluster
* [Dataproc Cluster](https://console.cloud.google.com/dataproc/clusters)
* Creating a cluster
  * On console.cloud.google.com > search dataprodc > Enable Dataproc Cluster
  * Create Cluster on Compute Engine
    * Set up cluster
      - Name the cluster and select the zone and region of the project connected with selected project
      - Select Cluster type: Single Node
      - Select components Jupyter Notebook and Docker
    * Configure nodes (optional)
    * Customize cluster (optional)
    * Manage security (optional)
* Running a Spark job with Dataproc
  - Copy python file to DataLake
  ```bash
  gsutil cp 10_cluster.py --output=gs://dtc_data_lake_dtc-de-396509/report-2021/
  ```
  - Run
    - Create a Cluster job
    - Select type job: pyspark
    - Select main file --output=gs://dtc_data_lake_dtc-de-396509/report-2021/
    - Add arguments
      - --input_green=gs://dtc_data_lake_dtc-de-396509/pq/green/2021/*/  
      - --input_yellow=gs://dtc_data_lake_dtc-de-396509/pq/yellow/2021/*/
      - --output=gs://dtc_data_lake_dtc-de-396509/report-2021/
* Submitting the job with the cloud SDK
  - Add Dataproc Administrator to IAM on IAM & Admin
  - [Dataproc Submit job gcloud](https://cloud.google.com/dataproc/docs/guides/submit-job#dataproc-submit-job-gcloud)
  ```bash
  gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=europe-west1 \
	gs://dtc_data_lake_dtc-de-396509/code/10_cluster.py \
    -- \
		--input_green=gs://dtc_data_lake_dtc-de-396509/pq/green/2020/*/ \
		--input_yellow=gs://dtc_data_lake_dtc-de-396509/pq/yellow/2020/*/ \
		--output=gs://dtc_data_lake_dtc-de-396509/report-2020/
  ```

#### 5.6.4 Connecting Spark to Big Query
* Writing the spark results to Big Query
  - [Use the BigQuery connector with Spark](https://cloud.google.com/dataproc/docs/tutorials/bigquery-connector-spark-example#pyspark)
  - Upload script to Google cloud storage
    ```bash
    gsutil cp 10_cluster.py gs://dtc_data_lake_dtc-de-396509/code/10_cluster.py
    ```
  - Run script
    ```bash
    gcloud dataproc jobs submit pyspark \
        --cluster=de-zoomcamp-cluster \
        --region=europe-west1 \
      	gs://dtc_data_lake_dtc-de-396509/code/10_cluster.py \
      	--jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar \
        -- \
      		--input_green=gs://dtc_data_lake_dtc-de-396509/pq/green/2020/*/ \
      		--input_yellow=gs://dtc_data_lake_dtc-de-396509/pq/yellow/2020/*/ \
      		--output=gs://dtc_data_lake_dtc-de-396509/report-2020/
    ```


### Homework


* [Homework](../cohorts/2023/week_5_batch_processing/homework.md)


## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/5_batch_processing.md)
* [Sandy's DE Learning Blog](https://learningdataengineering540969211.wordpress.com/2022/02/24/week-5-de-zoomcamp-5-2-1-installing-spark-on-linux/)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week5.md)
* [Alternative : Using docker-compose to launch spark by rafik](https://gist.github.com/rafik-rahoui/f98df941c4ccced9c46e9ccbdef63a03) 
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-5-batch-spark)
* [Notes by Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week5)
* Add your notes here (above this line)
