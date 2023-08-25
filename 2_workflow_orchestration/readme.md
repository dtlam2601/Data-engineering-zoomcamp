## Week 2: Workflow Orchestration

### Data Lake (GCS)
* What is a Data Lake
  * Data Lake is a system or repository of data stored in natural/raw format.
  * Users: Data Scientist, and Data Analysts
  * Usecases: Stream Processing, Real-time analysis, Machine learning.
  * Usage: store and access data as soon as possible.
  * Gotcha of Data Lake
    * Converting into Data Swamp
    * No versioning
    * Incompatiple schemas for same data without versioning
    * No metadata associated
    * Joins not possible
* ELT vs. ETL
  * ELT for large amounts of data: Data Lake. Provides Schema on Read.
  * ETL for a small amount of data: Data Warehouse
* Alternatives to components (S3/HDFS, Redshift, Snowflake etc.)
  * GCP - Cloud
  * AWS - S3
  * AZURE - AZURE Blob
* Video
* Slides

### 1. Introduction to Workflow orchestration
* What is orchestration?
  * Orchestration is a governing for data flow in a way that respects orchestration rules and business logic.
  * Orchestration turn any code into workflow that you can schedule and obverse.
  * Data flow that binds and otherwise disparate set of applications together.
* Workflow orchestrators vs. other types of orchestrators
  * Workflow orchestration and example
    * Workflow: order, packed, delivery address
    * Workflow Configuration: order of execution, packaging, and delivery type
    * Workflow Orchestration: schedule, privacy, if return, restarts or retries.
* Core features of a workflow orchestration tool
  - Remote Execution
  - Scheduling
  - Retries
  - Caching
  - Integration with external systems (APIs, database)
  - Ad-hoc runs
  - Parameterization
  - Alert you when something fails
* Different types of workflow orchestration tools that currently exist
  - Ingest Saas
  - Ingest Tech
  - Object Storage
  - Megastore
  - Git for Data
  - Open Table Formats
  - Compute
  - Orchestration
  - Observability
  - MLOps End-to-End
  - Data Centric AI/ML
  - Feature Stores
  - ML Observability
  - Notebooks
  - Analytics Workflow
  - Discovery & Governance
🎥  [Video](https://www.youtube.com/watch?v=W3Zm6rjOq70&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=17&pp=iAQB&ab_channel=DataTalksClub%E2%AC%9B)

### 2. Introduction to Prefect concepts
* What is Prefect?
* Installing Prefect
* [Prefect flow](https://docs.prefect.io/2.11.5/concepts/flows/)
  * Like a function. You can turn any function to flow by adding the @flow decorator.
  * Take advantage:
    - Observation of flow execution is sent to the API.
    - Input arguments type can be validated.
    - Retries and timeout.
* Creating an ETL
* [Prefect task](https://docs.prefect.io/2.11.5/concepts/tasks/)
  * A task is a function that represent a discrete unit of work in a Prefect workflow.
* Blocks and collections
* Orion UI
🎥 [Video](https://www.youtube.com/watch?v=8oLs6pzHp68&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=19&ab_channel=DataTalksClub%E2%AC%9B)

### 3. ETL with GCP & Prefect
* Flow 1: Putting data to Google Cloud Storage
  * Data: https://github.com/DataTalksClub/nyc-tlc-data/releases/
  * Scenario: using Prefect with features as observability and orchestration, schedule, run and monitor.
  * Create a Virtualenv and Install Dependencies
    - Create a Virtualenv
    ```bash
    conda -n zoomcamp python:3.9
    conda activate zoomcamp
    ```
    - Install Dependencies: requirements.txt
    ```bash
    pip install -r requirements.txt
    ```
  * Recap: 'ingest_data.py' and pgAdmin
  * Transform the Script into a Prefect Flow
  * Running your first Prefect Flow
  * Prefect Task: Extract Data
    ```python
    @task(log_prints=True, retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
    def extract_data(url):
        if url.endswith('.csv.gz'):
            csv_name = 'yellow_trip_data_2021.csv.gz'
        else:
            csv_name = 'output.csv'
    
        # download the csv
        os.system(f"wget {url} -O {csv_name}")
    
        df = pd.read_csv(csv_name, nrows=10000)
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
        return df
    ``` 
  * Prefect Task: Transform / Data Cleanup
    ```python
    @task(log_prints=True)
    def transform_data(df):
        print(f"pre: missing passenger count {df['passenger_count'].isin([0]).sum()}")
        df = df[df['passenger_count'] != 0]
        print(f"post: missing passenger count {df['passenger_count'].isin([0]).sum()}")
        return df
    ``` 

  * Prefect Task: Load Data into Postgres
    ```python
    @task(log_prints=True, retries=3)
    def ingest_data(user, password, host, port, db, table_name, df):
    
        postgres_url = f"postgresql://{user}:{password}@{host}:{port}/{db}"
        engine = create_engine(postgres_url)
    
        # create table name 'yellow_taxi_data' with ddl into postgres database
        df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
        df.to_sql(name=table_name, con=engine, if_exists='append')
    ``` 

  * Prefect Flow: Parameterization & Subflows
    ```python
    @flow(name="Subflow", log_prints=True)
    def log_subflow(table_name: str):
        print(f"Logging Subflow for: {table_name}")
    ```
  * Prefect Orion: Quick Tour through the UI
    ```bash
    prefect orion start
    ```
    - PREFECT_API_URL=http://127.0.0.1:4200/api
    - View the API reference documentation at http://127.0.0.1:4200/docs
    - Check out the dashboard at http://127.0.0.1:4200
  * Overview of Notifications & Task Run Concurrency
  * Overview of Prefect Blocks
  * Prefect Blocks: SQLAlchemy - Part I
  * [Prefect Collections Catalog](https://docs.prefect.io/2.7/collections/catalog/)
  * Prefect Blocks: SQLAlchemy - Part II
    * Using Blocks with prefect_sqlalchemy
    ```python
    @task(log_prints=True, retries=3)
    def ingest_data(table_name, df):
        connection_block = SqlAlchemyConnector.load("postgres-connector")
        with connection_block.get_connection(begin=False) as engine:
            # create table name 'yellow_taxi_data' with ddl into postgres database
            df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
            df.to_sql(name=table_name, con=engine, if_exists='append')
    ```

  * Wrapping up & Review
    ```python
    #!/usr/bin/env python
    # coding: utf-8

    import os
    from sqlalchemy import create_engine
    from time import time
    import pandas as pd
    import argparse
    from prefect import flow, task
    from prefect.tasks import task_input_hash
    from datetime import timedelta
    from prefect_sqlalchemy import SqlAlchemyConnector

    @task(log_prints=True, retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
    def extract_data(url):
        if url.endswith('.csv.gz'):
            csv_name = 'yellow_trip_data_2021.csv.gz'
        else:
            csv_name = 'output.csv'

        # download the csv
        os.system(f"wget {url} -O {csv_name}")
    
        df = pd.read_csv(csv_name, nrows=10000)
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
        return df

    @task(log_prints=True)
    def transform_data(df):
        print(f"pre: missing passenger count {df['passenger_count'].isin([0]).sum()}")
        df = df[df['passenger_count'] != 0]
        print(f"post: missing passenger count {df['passenger_count'].isin([0]).sum()}")
        return df
    
    @task(log_prints=True, retries=3)
    def ingest_data(table_name, df):
        connection_block = SqlAlchemyConnector.load("postgres-connector")
    
        with connection_block.get_connection(begin=False) as engine:
            # create table name 'yellow_taxi_data' with ddl into postgres database
            df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
            df.to_sql(name=table_name, con=engine, if_exists='append')
    
    @flow(name="Subflow", log_prints=True)
    def log_subflow(table_name: str):
        print(f"Logging Subflow for: {table_name}")
    
    @flow(name="Ingest Flow")
    def main_flow(table_name: str):
        url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
    
        log_subflow(table_name)
        raw_data = extract_data(url)
        data = transform_data(raw_data)
        ingest_data(table_name, data)
    
    if __name__ == '__main__':
        table_name="yellow_taxi_trips"
        main_flow(table_name)
    ```
🎥 [Video](https://www.youtube.com/watch?v=cdtN6dhp708&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=19&ab_channel=DataTalksClub%E2%AC%9B)

### 4. From Google Cloud Storage to Big Query
* Flow 2: From GCS to BigQuery
  
🎥 Video

### 5. Parametrizing Flow & Deployments
* Parametrizing the script from your flow
* Parameter validation with Pydantic
* Creating a deployment locally
* Setting up Prefect Agent
* Running the flow
* Notifications
🎥 Video

### 6. Schedules & Docker Storage with Infrastructure
* Scheduling a deployment
* Flow code storage
* Running tasks in Docker
🎥 Video

### 7. Prefect Cloud and Additional Resources
* Using Prefect Cloud instead of local Prefect
* Workspaces
* Running flows on GCP
🎥 Video

* Prefect docs
* Pefect Discourse
* Prefect Cloud
* Prefect Slack
