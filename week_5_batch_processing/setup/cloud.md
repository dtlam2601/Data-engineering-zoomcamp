export JAVA_HOME="${HOME}/spark/jdk-11.0.2"
export PATH="${JAVA_HOME}/bin:${PATH}"

export SPARK_HOME="${HOME}/spark/spark-3.3.3-bin-hadoop3"
export PATH="${SPARK_HOME}/bin:${PATH}"

export PYTHONPATH="${SPARK_HOME}/python/"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH"

export PYSPARK_PYTHON=${SPARK_HOME}/python/
export PYSPARK_DRIVER_PYTHON=${SPARK_HOME}/python/

https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz
https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2021-01.csv.gz


gcloud compute ssh de-zoomcamp \
    --project dtc-de-396509 \
    --zone europe-west1-b \
    -- -L 8888:localhost:8888

jupyter nbconvert --to=script 10_local_cluster.ipynb


python 10_local_cluster.py \
  --input_green=data/pq/green/2020/01/ \
  --input_yellow=data/pq/yellow/2020/01/ \
  --output=data/report-2020/


URL="spark://de-zoomcamp.europe-west1-b.c.dtc-de-396509.internal:7077"

spark-submit \
  --master=${URL} \
  python 10_local_cluster.py \
	  --input_green=data/pq/green/2021/01/ \
	  --input_yellow=data/pq/yellow/2021/01/ \
	  --output=data/report-2021/

python 10_local_cluster.py \
  --input_green=data/pq/green/2020/*/ \
  --input_yellow=data/pq/yellow/2020/*/ \
  --output=data/report-2020/

gs://dtc_data_lake_dtc-de-396509/code/10_cluster.py

--input_green=gs://dtc_data_lake_dtc-de-396509/pq/green/2021/*/ \
--input_yellow=gs://dtc_data_lake_dtc-de-396509/pq/yellow/2021/*/ \
--output=gs://dtc_data_lake_dtc-de-396509/report-2021/

gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=europe-west1 \
	gs://dtc_data_lake_dtc-de-396509/code/10_cluster.py \
    -- \
		--input_green=gs://dtc_data_lake_dtc-de-396509/pq/green/2020/*/ \
		--input_yellow=gs://dtc_data_lake_dtc-de-396509/pq/yellow/2020/*/ \
		--output=gs://dtc_data_lake_dtc-de-396509/report-2020/


#### Write spark results to Big Query
https://cloud.google.com/dataproc/docs/tutorials/bigquery-connector-spark-example#pyspark
trips_data_all.report-2020

gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=europe-west1 \
  	gs://dtc_data_lake_dtc-de-396509/code/10_cluster.py \
  	--jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar \
    -- \
		--input_green=gs://dtc_data_lake_dtc-de-396509/pq/green/2020/*/ \
		--input_yellow=gs://dtc_data_lake_dtc-de-396509/pq/yellow/2020/*/ \
		--output=gs://dtc_data_lake_dtc-de-396509/report-2020/

