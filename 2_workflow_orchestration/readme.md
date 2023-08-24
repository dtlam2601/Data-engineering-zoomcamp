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
* Workflow orchestrators vs. other types of orchestrators
* Core features of a workflow orchestration tool
* Different types of workflow orchestration tools that currently exist
🎥 Video

### 2. Introduction to Prefect concepts
* What is Prefect?
* Installing Prefect
* Prefect flow
* Creating an ETL
* Prefect task
* Blocks and collections
* Orion UI
🎥 Video

### 3. ETL with GCP & Prefect
* Flow 1: Putting data to Google Cloud Storage
🎥 Video

4. From Google Cloud Storage to Big Query
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
